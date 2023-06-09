require 'text'
require 'error'

module TinyBasic

class Program
  attr_reader :text, :current

  attr_reader :variables, :array

  Commands = {
    list: :exec_print_list,
    run: :not_implemented,
    new: :clear,
    next: :not_implemented,
    let: :not_implemented,
    if: :not_implemented,
    goto: :not_implemented,
    gosub: :not_implemented,
    return: :not_implemented,
    rem: :not_implemented,
    for: :not_implemented,
    input: :not_implemented,
    print: :exec_print,
    stop: :stop,
  }


  def initialize
    @text = Text.new
    @variables = {}
    @array = []
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
    line.reset
    until line.end_line?
      cmd = line.command?
      case cmd
      when :run, :new, :stop
        # Check there is nothing after the command.
        raise WhatError.new unless line.end_line?
        send Commands[cmd]
      when :list
        n = line.number?
        raise WhatError.new unless line.end_line?
        send Commands[cmd], n || 0
      when :print
        send Commands[cmd], line
      end
    end
  end

  private

  
  # execuet command

  def not_implemented
  end

  def exec_print_list no
    text.exec_print_list no
  end

  def clear
    text.clear
  end

  def stop
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
      v1 = v2 ? 1 : 0
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
          raise HowError.new
        end
        v1 = v
      elsif line.subtracting?
        v2 = expression_3(line)
        v = v1 - v2
        unless -32768 <= v && v <= 32767
          raise HowError.new
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
          raise HowError.new
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
      raise WhatError.new
    end
    v = expression(line)
    unless line.right_parenthesis?
      raise WhatError.new
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
        raise HowError.new
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
          raise WhatError.new
        end
        unless 0 <= n && n <= 32767
          raise HowError.new
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
