module TinyBasic

class TextLine
  attr_reader :no, :statements
  attr_reader :pointer

  Commands = [
    :list,
    :run,
    :new,
    :next,
    :let,
    :if,
    :goto,
    :gosub,
    :return,
    :rem,
    :for,
    :input,
    :print,
    :stop,
  ]

  def initialize line
    if /^(\d*)\s*(.*)\s*/ =~ line
      @no = ($1 || 0)&.to_i
      @statements = $2.upcase
    else
      raise WhatError.new
    end
    reset
  end

  def direct?
    no == 0
  end

  def has_statements?
    @statements&.length != 0
  end

  def command
    Commands.each do |cmd|
      cmd_str = cmd.to_s.upcase
      len = cmd_str.length
      0.upto len do |i|
        ch = statements[pointer + i]
        if ch == "."
          move_pointer(i + 1)
          return cmd
        end
        if cmd_str[i] == ch
          if i == len - 1
            move_pointer(i + 1)
            return cmd
          end
        else
          break
        end
      end
    end
    return nil
  end

  def number
    str = ""
    i = 0
    while ch = statements[pointer + i]
      case ch
      when '0'..'9'
        str << ch
      when ' '
        # Skip a space.
        # But break if str already set.
        break unless str.empty?
      else
        break
      end
      i += 1
    end
    move_pointer(i)
    if str.empty?
      nil
    else
      n = str.to_i
      raise HowError unless n <= 32768
      n
    end
  end

  def string
    i = 0
    quote = nil
    loop do
      ch = statements[pointer + i]
      case ch
      when '"', "'"
        quote = ch
        move_pointer(1)
        break
      when ' '
        move_pointer(1)
      else
        return nil
      end
    end

    str = ""
    loop do
      ch = statements[pointer + i]
      case ch
      when quote, nil
        move_pointer(1)
        return str
      else
        str += ch
        move_pointer(1)
      end
    end
  end

  def end_line?
    i = 0
    loop do
      case statements[pointer + i]
      when ' '
        i += 1
      when nil
        break
      else
        move_pointer(i)
        return false
      end
    end
    move_pointer(i)
    true
  end

  def separator?
    loop do
      case statements[pointer]
      when ' '
        move_pointer(1)
      when ';'
        move_pointer(1)
        return true
      else
        return false
      end
    end
  end

  def sharp?
    loop do
      case statements[pointer]
      when ' '
        move_pointer(1)
      when '#'
        move_pointer(1)
        return true
      else
        return false
      end
    end
  end
  

  def reset
    @pointer = 0
  end

  def move_pointer n
    @pointer += n
  end

end

end
