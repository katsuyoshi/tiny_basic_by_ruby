require 'text'
require 'error'

module TinyBasic

class Program
  attr_reader :text, :current

  attr_reader :variables, :array
  attr_reader :variable_stack

  Commands = {
    list: :print_list,
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
    print: :print,
    stop: :stop,
  }


  def initialize
    @text = Text.new
    @variables = {}
    @array = []
    @variable_stack = []
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

  private

  
  # execuet command

  def not_implemented
  end

  def print_list no
    text.print_list no
  end

  def clear
    text.clear
  end

  def stop
  end

  def print line
  p line
    digits = 6
    loop do
      if line.separator? || line.end_line?
        puts
        return
      elsif line.sharp?
        digits = line.number?
      elsif str = line.string?
        print str
      else
        v = expression line
        print v.to_s.rjust(digits, ' ')
      end
    end
  end

  def expression line
    v = expression_2 line
    return v if v
    v = expression_3 line
    return v if v
    expression_4 line
  end

  def expression_2 line
    nil
  end

  def expression_3 line
    nil
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

  def expression_4 line
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
          parenthesis line
        end

      when '@'
        n = parenthesis line
        unless n
          raise WhatError.new
        end
        unless 0 <= n && n <= 32767
          raise HowError.new
        end
        variable_stack << n
      else
        variable_stack << var
      end
    end
  end

end

end
