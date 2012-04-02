require File.join(File.dirname(__FILE__), 'test_helper')

class TrendsTest < Test::Unit::TestCase # :nodoc:
  context "trends" do
    setup do
      @trends = parse_json :file => 'trends'
    end

    should "find the 10 current trends on Twitter" do
      trends = @trends['trends'].values.first
      assert_equal 10, trends.size
    end
  end
end
