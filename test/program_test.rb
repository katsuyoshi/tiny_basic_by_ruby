$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper'

class Program
  def _expression(line)
    expression(line)
  end
  def _expression_2(line)
    expression_2(line)
  end
  def _expression_3(line)
    expression_3(line)
  end
  def _expression_4(line)
    expression_4(line)
  end
  def _set_variable var, val
    variables[var] = val
  end
  def _set_array idx, val
    array[idx] = val
  end
end

class ProgramTest < Test::Unit::TestCase
  def setup
    @prog = Program.new
  end

  def teardown
  end

  # expression 4
  def test_expression_4_with_number
    l = TextLine.new "10 20"
    assert_equal 20, @prog._expression_4(l)
  end

  def test_expression_4_with_variable
    l = TextLine.new "10 a"
    @prog._set_variable('A', 123)
    assert_equal 123, @prog._expression_4(l)
    l = TextLine.new "10 b"
    assert_equal 0, @prog._expression_4(l)
  end

  def test_expression_4_with_array
    l = TextLine.new "10 @(12)"
    @prog._set_array(12, 345)
    assert_equal 345, @prog._expression_4(l)
    l = TextLine.new "10 @(0)"
    assert_equal 0, @prog._expression_4(l)
  end

  def test_expression_4_with_abs
    l = TextLine.new "10 abs(1)"
    assert_equal 1, @prog._expression_4(l)
  end

  def test_expression_4_with_parenthesis
    l = TextLine.new "10 (1)"
    assert_equal 1, @prog._expression_4(l)
  end

  # expression 3
  def test_expression_3_with_multiply
    l = TextLine.new "10 12 * 34"
    assert_equal 408, @prog._expression_3(l)
  end

  def test_expression_3_with_dividing
    l = TextLine.new "10 56 / 12"
    assert_equal 4, @prog._expression_3(l)
  end
  
  def test_expression_3_with_multiply_dividing
    l = TextLine.new "10 12 * 34 / 56"
    assert_equal 7, @prog._expression_3(l)
  end
  
  # expression 2
  def test_expression_2_with_adding
    l = TextLine.new "10 12 + 34"
    assert_equal 46, @prog._expression_2(l)
  end

  def test_expression_2_with_subtracting
    l = TextLine.new "10 56 - 12"
    assert_equal 44, @prog._expression_2(l)
  end
    
  def test_expression_2_with_adding_and_subtracting
    l = TextLine.new "10 12 + 34 - 56"
    assert_equal( -10, @prog._expression_2(l))
  end

  # expression
  def test_expression_with_formula
    l = TextLine.new "10 (1 + 2) * (3 + 4) / (5 - 6)"
    assert_equal( -21, @prog._expression_2(l))
  end

  # let
  def test_let_a_eq_1
    l = TextLine.new "a = 1"
    @prog << l
    assert_equal(1, @prog.variables["A"])
  end

  def test_let_a_b_c
    l = TextLine.new "a = 1, b = 1 + 1, c = a + b;"
    @prog << l
    assert_equal(1, @prog.variables["A"])
    assert_equal(2, @prog.variables["B"])
    assert_equal(3, @prog.variables["C"])
  end

  def test_let_array
    l = TextLine.new "let @(10) = 12 * 34"
    @prog << l
    assert_equal(408, @prog.array[10])
  end

 
end

class ProgramStringTest < Test::Unit::TestCase

  def setup
    @prog = Program.new
    @orignal_stdout = $stdout
    @new_stdio = StringIO.new
    $stdout = @new_stdio
  end

  def teardown
    $stdout = @orignal_stdout
    #puts @new_stdio.string
  end

  # print
  def test_print_string
    l = TextLine.new "print 'abc'"
    @prog << l
    assert_equal("ABC\n", $stdout.string)
  end

  def test_print_number
    l = TextLine.new "print 123"
    @prog << l
    assert_equal("   123\n", $stdout.string)
  end

  def test_print_with_format
    l = TextLine.new "print #4, 123"
    @prog << l
    assert_equal(" 123\n", $stdout.string)
  end

  def test_print_with_format_2
    l = TextLine.new "print 'abc', #4, 1 + 2 + 3 * 4"
    @prog << l
    assert_equal("ABC  15\n", $stdout.string)
  end

  def test_print_end_with_comma
    l = TextLine.new "print 'abc',"
    @prog << l
    assert_equal("ABC", $stdout.string)
  end

  def test_print_with_multi_statements
    l = TextLine.new "print 'abc'; print 123,"
    @prog << l
    assert_equal("ABC\n   123", $stdout.string)
  end

end


