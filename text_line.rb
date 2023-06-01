module TinyBasic

class TextLine
  attr_accessor :no, :statements

  def initialize line
    if /^(\d*)\s*(.*)\s*/ =~ line
      @no = ($1 || 0)&.to_i
      @statements = $2.upcase
    else
      raise WhatError.new
    end
  end

  def direct?
    no == 0
  end

  def has_statements?
    @statements&.length != 0
  end

end

end
