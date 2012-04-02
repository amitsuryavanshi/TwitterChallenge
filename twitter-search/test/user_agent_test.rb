require File.join(File.dirname(__FILE__), 'test_helper')

class UserAgentTest < Test::Unit::TestCase # :nodoc:
  context "A new Client instance" do
    setup do
      @client = TwitterSearch::Client.new
    end

    should 'respond to user agent' do
      assert_respond_to @client, :agent
    end

    should 'set a default user agent' do
      assert_equal @client.headers['User-Agent'], "twitter-search"
      assert_equal @client.agent, "twitter-search"
    end

    should 'set a default timeout for the http request' do
      assert_equal @client.timeout, TwitterSearch::Client::DEFAULT_TIMEOUT
    end
  end
end
