require 'text_line'
require 'error'

module TinyBasic

class Text
  attr_reader :lines, :current

  def initialize
    clear
  end

  def << line
    case line
    when String
      self << TextLine.new(line)
    when TextLine
      @current = line
      unless @current.direct?
        if @current.has_statements?
          lines[line.no] = @current unless @current.direct?
        else 
          lines.delete(@current.no)
        end
      end
      @current
    else
      raise WhatError.new
    end
  end

  def empty?
    @lines.empty?
  end

  def clear
    @lines = {}
  end

  def exec_print_list no
    lines.keys.sort.each do |n|
      next if n < no
      l = lines[n]
      puts "#{l.no} #{l.statements}"
    end
  end

  def find_line no
    @lines[no]
  end

  def find_next_line no
    @lines.keys.each do |n|
      return @lines[n] if n > no
    end
    nil
  end

  private


end


end
