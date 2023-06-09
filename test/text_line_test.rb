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

  def test_line_list
    l = TextLine.new("list")
    assert_equal(:list, l.command?)
    assert_equal(true, l.end_line?)
  end

  def test_line_n_list
    l = TextLine.new("list 20")
    assert_equal(:list, l.command?)
    assert_equal(20, l.number?)
    assert_equal(true, l.end_line?)
  end

  def test_separator_q
    l = TextLine.new("print 'abc';")
    l.command?
    assert_equal false, l.separator?

    l = TextLine.new("print;")
    l.command?
    assert_equal true, l.separator?
  end

  def test_sharp_q
    l = TextLine.new("print 'abc';")
    l.command?
    assert_equal false, l.sharp?

    l = TextLine.new("print #3;")
    l.command?
    assert_equal true, l.sharp?
  end

  def test_string
    l = TextLine.new("print 'abc';")
    l.command?
    assert_equal 'ABC', l.string?

    l = TextLine.new("print \"def\";")
    l.command?
    assert_equal "DEF", l.string?

    l = TextLine.new("print ;")
    l.command?
    assert_equal nil, l.string?
  end

  def test_function
    l = TextLine.new("print abs;")
    l.command?
    assert_equal :abs, l.function?

    l = TextLine.new("print rnd;")
    l.command?
    assert_equal :rnd, l.function?

    l = TextLine.new("print size;")
    l.command?
    assert_equal :size, l.function?

    l = TextLine.new("print abc;")
    l.command?
    assert_equal nil, l.function?

  end

  def test_ommited_function
    l = TextLine.new("print a.;")
    l.command?
    assert_equal :abs, l.function?

    l = TextLine.new("print r.;")
    l.command?
    assert_equal :rnd, l.function?

    l = TextLine.new("print s.;")
    l.command?
    assert_equal :size, l.function?

    l = TextLine.new("print .;")
    l.command?
    assert_equal :rnd, l.function?

  end

end
