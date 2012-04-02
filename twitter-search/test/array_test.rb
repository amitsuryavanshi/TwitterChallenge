require File.join(File.dirname(__FILE__), 'test_helper')

class ArrayTest < Test::Unit::TestCase # :nodoc:
  should "be a descendant of Array" do
    tweets = TwitterSearch::Tweets.new({})
    assert tweets.class.ancestors.include?(Array)
  end
end
