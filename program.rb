require 'text'

module TinyBasic

class Program
  attr_reader :text, :current

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
    cmd = line.command
    case cmd
    when :run, :new, :stop
      # Check there is nothing after the command.
      raise WhatError unless line.end_line?
      send Commands[cmd]
    when :list
      n = line.number
      raise WhatError unless line.end_line?
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
    digits = 6
    loop do
      if line.separetor? || line.end_line?
        puts
        return
      elsif line.sharp?
        digits = line.number
      elsif str = line.string
        print str
      end
    end
  end

end

end
