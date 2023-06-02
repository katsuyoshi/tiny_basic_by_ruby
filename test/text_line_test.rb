$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper'

class TextLineTest < Test::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_line_with_no
    l = TextLine.new("10 print")
    assert_equal(10, l.no)
    assert_equal("PRINT", l.statements)
    assert_equal(false, l.direct?)
    assert_equal(true, l.has_statements?)
  end

  def test_line_with_list
    l = TextLine.new("list")
    assert_equal(0, l.no)
    assert_equal("LIST", l.statements)
    assert_equal(true, l.direct?)
    assert_equal(true, l.has_statements?)
  end

  def test_line_with_list_with_zero
    l = TextLine.new("0 list")
    assert_equal(0, l.no)
    assert_equal("LIST", l.statements)
    assert_equal(true, l.direct?)
    assert_equal(true, l.has_statements?)
  end


end
