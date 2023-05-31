$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))

require 'text'
require 'version'

include TinyBasic

@text = Text.new

puts "Tiny Basic by Ruby #{VERSION}."

loop do
  print "> "
  buf = gets
  @text << buf
  
  if @text.direct?
    @text.exec_line
  end

  break if /exit|quit/ =~ buf
end
