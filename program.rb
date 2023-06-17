require 'text'
require 'error'

module TinyBasic

ForVariable = Struct.new(:var, :limit, :step, :line)

class Program
  attr_reader :text, :current
  attr_reader :variables, :array
  attr_reader :stack, :for_var

  Commands = {
    list: :exec_print_list,
    run: :exec_run,
    new: :clear,
    next: :exec_next,
    let: :parse_let,
    if: :exec_if,
    goto: :exec_goto,
    gosub: :exec_gosub,
    return: :exec_return,
    rem: :not_implemented,
    for: :exec_for,
    input: :not_implemented,
    print: :exec_print,
    stop: :exec_stop,
  }


  def initialize
    @text = Text.new
    @variables = {}
    @array = []
    @stack = []
  end

  # @return true: executed direct command; false: append a line to the text area
  def << line
    @current = text << line
    if @current.direct?
      exec_line @current
      true
    else
      false
    end
  end

  def exec_line line
    line.start
    until line.end_line?
      cmd = line.command?
      case cmd
      when :run, :new
        # Check there is nothing after the command.
        raise WhatError.new(line) unless line.end_line?
        send Commands[cmd]
      when :stop
        # Check there is nothing after the command.
        raise WhatError.new(line) unless line.end_line?
        return send Commands[cmd], line
      when :goto, :gosub
        return send Commands[cmd], line
      when :list
        n = line.number?
        raise WhatError.new(line) unless line.end_line?
        send Commands[cmd], n || 0
      when :print, :if, :for
        send Commands[cmd], line
      when :next, :return
        line = send Commands[cmd], line
      when :rem
        line.stop
      else
        # Let
        send Commands[:let], line
      end
    end
    line.direct? ? nil : text.next_line(line)
  end

  private

  
  # execuet command

  def not_implemented
  end

  def exec_run line = nil
    line ||= text.first_line
    @current = line if line
    while @current
      @current = exec_line(@current)
      @current&.start
    end
  end

  def exec_print_list no
    text.exec_print_list no
  end

  def clear
    text.clear
  end

  def exec_stop line
    line.stop
    nil
  end

  def exec_goto line
    no = expression line
    next_line = text.find_line no
    unless next_line
      raise HowError.new(line)
    end
    # Check there is nothing or separator after the command.
    raise WhatError.new(line) unless line.separator? || line.end_line?
    next_line
  end

  def exec_if line
    if expression(line) == 0
      line.stop
    end
  end

  def exec_for line
    stack.push @for_var if @for_var

    var = line.variable?
    idx = nil
    if var == '@'
      idx = parenthesis(line)
    end
    unless line.equal?
      raise WhatError.new(line)
    end
    if var == '@'
      array[idx] = expression(line)
    else
      variables[var] = expression(line)
    end

    unless line.other_key? == :to
      raise WhatError.new(line)
    end
    limit = expression(line)

    step = 1
    if line.other_key? == :step
      step = expression(line)
    end

    @for_var = ForVariable.new(idx || var, limit, step, TextLine.new(line))

    # remove duplicated var's data
    duplicated = stack.find{|e| e.is_a?(ForVariable) && e.var == @for_var.var}
    stack.delete duplicated

    line
  end

  def exec_next line

    var = line.variable?
    if @for_var.nil? || var.nil? || @for_var.var != var
      raise WhatError.new(line)
    end
    
    var = @for_var.var
    step = @for_var.step
    val = nil

    # add step
    case var
    when String
      val = variables[var] += step
    when Integer
      val = array[var] += step
    end

    # check loop end
    end_for = false
    if step < 0
      if val < @for_var.limit
        end_for = true
      end
    else
      if val > @for_var.limit
        end_for = true
      end
    end

    if end_for
      @for_var = stack.pop
      line
    else
      TextLine.new(@for_var.line)
    end
  end

  def exec_gosub line
    no = expression(line)
    unless line.separator? || line.end_line?
      raise WhatError.new(line)
    end
    next_line = text.find_line no
    unless next_line
      raise HowError.new(line)
    end

    gosub_var = ForVariable.new(nil, nil, nil, TextLine.new(line))
    stack.push(gosub_var)
    next_line
  end

  def exec_return line
    unless line.separator? || line.end_line?
      raise WhatError.new(line)
    end

    gosub_var = stack.pop
    unless gosub_var && gosub_var&.var.nil?
      raise WhatError.new(line)
    end

    TextLine.new(gosub_var.line)
  end

  def exec_print line
    digits = 6
    loop do
      comma = line.comma?
      if line.separator? || line.end_line?
        puts unless comma
        return
      elsif line.sharp?
        digits = expression(line)
      elsif str = line.string?
        print str
      else
        v = expression(line)
        print v.to_s.rjust(digits, ' ')
      end
    end
  end

  def parse_let line
    loop do
      if line.separator? || line.end_line?
        return
      elsif var = line.variable?
        idx = nil
        if var == '@'
          idx = parenthesis(line)
        end
        unless line.equal?
          raise WhatError.new(line)
        end
        if var == '@'
          array[idx] = expression(line)
        else
          variables[var] = expression(line)
        end
        unless line.comma?
          if line.separator? || line.end_line?
            return
          else
            raise WhatError.new(line)
          end
        end
      else
        raise WhatError.new(line)
      end
    end
  end


  def expression line
    expression_1(line)
  end

  def expression_1 line
    v1 = expression_2(line)
    op = line.operator?
    unless op
      return v1
    end

    v2 = expression_2(line)
    case op
    when :">="
      v1 >= v2 ? 1 : 0
    when :"#"
      v1 != v2 ? 1 : 0
    when :">"
      v1 > v2 ? 1 : 0
    when :"="
      v1 == v2 ? 1 : 0
    when :"<="
      v1 <= v2 ? 1 : 0
    when :"<"
      v1 < v2 ? 1 : 0
    end
  end

  def expression_2 line
    v1 = expression_3(line)
    loop do
      if line.adding?
        v2 = expression_3(line)
        v = v1 + v2
        unless -32768 <= v && v <= 32767
          raise HowError.new(line)
        end
        v1 = v
      elsif line.subtracting?
        v2 = expression_3(line)
        v = v1 - v2
        unless -32768 <= v && v <= 32767
          raise HowError.new(line)
        end
        v1 = v
      else
        break
      end
    end
    v1
  end

  def expression_3 line
    v1 = expression_4(line)
    loop do
      if line.multiplying?
        v2 = expression_4(line)
        v = v1 * v2
        unless -32768 <= v && v <= 32767
          raise HowError.new(line)
        end
        v1 = v
      elsif line.dividing?
        v2 = expression_4(line)
        v1 = v1 / v2
      else
        break
      end
    end
    v1
  end

  def parenthesis line
    unless line.left_parenthesis?
      raise WhatError.new(line)
    end
    v = expression(line)
    unless line.right_parenthesis?
      raise WhatError.new(line)
    end
    v
  end

  def expression_4(line)
    case line.function?
    when :abs
      v = parenthesis line
      v.abs

    when :rnd
      v = parenthesis line
      unless 1 <= v && v <= 32767 - 1
        raise HowError.new(line)
      end
      rand(v) + 1

    when :size
      # DUMMY SIZE
      1024 * 1024

    else
      var = line.variable?
      case var
      when nil
        n = line.number?
        if n
          n
        else
          if line.current == '('
            parenthesis line
          else
            nil
          end
        end

      when '@'
        # array a[0-32767]
        n = parenthesis line
        unless n
          raise WhatError.new(line)
        end
        unless 0 <= n && n <= 32767
          raise HowError.new(line)
        end
        array[n] || 0
      else
        # variable 'A'-'Z'
        variables[var] || 0
      end
    end
  end

end

end
