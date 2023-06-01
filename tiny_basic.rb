$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))

require 'program'
require 'version'

include TinyBasic

@prog = Program.new

puts "Tiny Basic by Ruby #{VERSION}."
puts
puts "OK"

loop do
  print "> "
  buf = gets
  @prog << buf
  break if /exit|quit/ =~ buf
end
