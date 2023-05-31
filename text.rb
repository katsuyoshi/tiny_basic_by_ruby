module TinyBasic

class TextLine
  attr_accessor :no, :statements
  def initialize line
    if /^(\d*)\s*(.*)\s*/ =~ line
      p [$1, $2]  # DEBUGME
      @no = $1&.to_i
      @statements = $2
    else
      raise "what"
    end
  end

  def direct?
    no&.== 0
  end

  def has_statements?
    @statements&.!= nil
  end

  def command
    p statements  # DEBUGME
    case statements
    when /^list/i
      :list
    when /^run/i
      :run
    when /^new/i
      :new
    else
      nil
    end
  end

end

class Text
  attr_reader :lines, :current
  def initialize
    @lines = {}
  end

  def << line
    case line
    when String
      self << TextLine.new(line)
    when TextLine
      @current = line
p @current  # DEBUGME
      unless @current.direct?
p __LINE__, @current
        if @current.has_statements?
          p __LINE__
          lines.delete(@current.no)
        else 
          p __LINE__
          lines[line.no] = @current unless @current.direct?
        end
      p lines  # DEBUGME
      end
    else
      raise "What?"
    end
  end

  def direct?
    current&.direct?
  end

  def exec_line
    case current&.command
    when :list
      print_list
    when :run
      # TODO:
    when :new
      @lines = {}
    end
  end

  def print_list
    p lines  # DEBUGME
    lines.keys.sort.each do |no|
      l = lines[no]
      puts "#{l.no} #{l.statements}"
    end
  end

end


end
