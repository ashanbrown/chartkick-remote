require "test_helper"

class TestChartkickRemote < Minitest::Test
  include Chartkick::Remote::Helper

  # TODO actual tests

  def setup
    @data = [[34, 42], [56, 49]]
  end

  def test_line_chart
    assert line_chart(@data)
  end

  def test_pie_chart
    assert pie_chart(@data)
  end

  def test_column_chart
    assert column_chart(@data)
  end

  def test_column_chart_with_block
    assert column_chart { @data }
  end

  def controller
    @controller ||= Class.new do
      attr_accessor :chartkick_remote_blocks, :params
    end.new
  end

  def test_remote_chart_sets_chartkick_block
    controller.params = {_chartkick_remote_chart_id: 1}
    assert column_chart(remote: true) { [[1,2]] }
    assert controller.chartkick_remote_blocks[1].call == [[1,2]]
  end
end