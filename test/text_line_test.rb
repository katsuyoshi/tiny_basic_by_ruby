$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper'

class MyTest < Test::Unit::TestCase
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

  # test command
  def test_command_list
    assert_equal(:list, TextLine.new("list").command)
    assert_equal(:list, TextLine.new("LIST").command)
    assert_equal(:list, TextLine.new("List").command)
    assert_equal(:list, TextLine.new("L.").command)
    assert_equal(:list, TextLine.new("LI.").command)
    assert_equal(:list, TextLine.new("LIS.").command)
  end

  # test command
  def test_command_list_short
    assert_equal(:list, TextLine.new(".").command)
    assert_equal(:list, TextLine.new("l.").command)
    assert_equal(:list, TextLine.new("li.").command)
    assert_equal(:list, TextLine.new("lis.").command)
  end


end
