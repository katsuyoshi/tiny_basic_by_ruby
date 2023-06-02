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
    print: :not_implemented,
    stop: :stop,
}


  def initialize
    @text = Text.new
  end

  # @return true: executed direct command; false: append a line to the text area
  def << line
    @current = text << line
    if @current.direct?
      exec @current.statements
      true
    else
      false
    end
  end

  def exec str
    cmd, str = command str
    case cmd
    when :run, :new, :stop
      # Check there is nothing after the command.
      raise WhatError unless str.empty?
      send Commands[cmd]
    when :list
      n, str = number str
      p [n, str]
      send Commands[cmd], n || 0
    end

  end

  private

  def command str
    Commands.keys.each do |cmd|
      cmd_str = cmd.to_s.upcase
      len = cmd_str.length
      0.upto len do |i|
        if str[i] == "."
          return [cmd, str[(i + 1)..-1]]
        end
        if cmd_str[i] == str[i]
          return [cmd, str[(i + 1)..-1]] if i == len - 1
        else
          break
        end
      end
    end
    return [nil, str]
  end

  def number str
    numstr = ""
    idx = 0
    str.each_char.with_index do |c, i|
      idx = i
      if ('0'..'9').include? c
        numstr << c 
      else
        break unless numstr.empty? && c == " "
      end
    end
    if numstr.empty?
      [nil, str]
    else
      n = numstr.to_i
      raise HowError unless n <= 32768
p [str, n, str[idx..-1], idx]
      [n, str[(idx + 1)..-1]]
    end
  end
  
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

end

end
