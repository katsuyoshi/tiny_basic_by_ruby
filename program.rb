require 'text'

module TinyBasic

class Program
  attr_reader :text, :current

  Commands = {
    list: :print_list,
    run: :not_implemented,
    new: :not_implemented,
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
    stop: :not_implemented,
}


  def initialize
    @text = Text.new
  end

  def << line
    @current = text << line
    if @current.direct?
      exec @current.statements
    end
  end

  def exec str
    cmd, str = command str
    send Commands[cmd] if cmd
  end

  private

  def command str
    Commands.keys.each do |cmd|
      cmd_str = cmd.to_s.upcase
      len = cmd_str.length
      0.upto len do |i|
        if str[i] == "."
          return [cmd, str((i + 1)..-1)]
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

  
  def not_implemented
  end


  def print_list
    text.print_list
  end

end

end
