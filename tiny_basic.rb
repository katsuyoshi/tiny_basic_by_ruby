$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))

require 'text'
require 'version'

include TinyBasic

puts "Tiny Basic by Ruby #{VERSION}."

loop do
  print "> "
  buf = gets
  print buf
  exit if /exit|quit/ =~ buf
end
