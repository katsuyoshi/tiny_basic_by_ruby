# @see: https://userweb.alles.or.jp/chunichidenko/tinybasic_9.html
module TinyBasic

class TinyBasicError < StandardError
  attr_reader :line

  def initialize(line)
    @line = line
    super
  end

  def name
    self.class.name.split('::').last.gsub(/Error/, "")
  end

  def to_s
    s = "#{name}?"
    unless line.direct?
      s += " #{line.error_message}"
    end
    s
  end

end

class WhatError < TinyBasicError
end

class HowError < TinyBasicError
end

class SorryError < TinyBasicError
end


end
