$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper'

class TextTest < Test::Unit::TestCase
  def setup
    @text = Text.new
    @text << "10 print"
    @text << "20 print"
  end

  def teardown
  end

  def test_clear
    assert_equal(false, @text.empty?)
    @text.clear
    assert_equal(true, @text.empty?)
  end

  def test_find_line
    assert_not_nil(@text.find_line(10))
    assert_not_nil(@text.find_line(20))
    assert_nil(@text.find_line(30))
  end

  def test_find_next_line
    assert_equal(@text.find_line(20), @text.find_next_line(10))
    assert_nil(@text.find_next_line(20))
  end



end


