$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper'

class TextTest < Test::Unit::TestCase
  def setup
    @text = Text.new
  end

  def teardown
  end

  def test_clear
    @text << "10 print"
    @text << "20 print"
    assert_equal(false, @text.empty?)
    @text.clear
    assert_equal(true, @text.empty?)
  end


end


