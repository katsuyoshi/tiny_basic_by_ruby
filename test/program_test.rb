$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)))
require 'test_helper'

class Program
  def _expression_4 line
    expression_4 line
  end
end

class ProgramTest < Test::Unit::TestCase
  def setup
    @prog = Program.new
  end

  def teardown
  end

  def test_expression_4_with_number
    l = TextLine.new "10 20"
    assert_equal 20, @prog._expression_4(l)
  end

  def test_expression_4_with_variable
    l = TextLine.new "10 a"
    @prog._expression_4(l)
    assert_equal ['A'], @prog.variable_stack
  end

  def test_expression_4_with_abs
    l = TextLine.new "10 abs(1)"
    assert_equal 1, @prog._expression_4(l)
  end

end
