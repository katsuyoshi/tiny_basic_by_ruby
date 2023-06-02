$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))

require 'program'
require 'version'

include TinyBasic

@prog = Program.new

puts "Tiny Basic by Ruby #{VERSION}."

loop do
  puts
  puts "OK"

  loop do
    print "> "
    buf = gets
    exit if /exit|quit/ =~ buf

    r = @prog << buf
    break if r
  end
end
