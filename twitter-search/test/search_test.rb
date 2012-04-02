require File.join(File.dirname(__FILE__), 'test_helper')

class SearchTest < Test::Unit::TestCase # :nodoc:
  context "single word" do
    setup do
      fake_query('Obama', 'obama.json')
      @tweets = TwitterSearch::Client.new.query('Obama')
    end

    should_have_default_search_behaviors

    should 'find tweets containing the single word "Obama"' do
      assert @tweets.all? { |tweet| tweet.text =~ /obama/i }
    end
  end

  context "two words" do
    setup do
      fake_query('twitter search', 'twitter_search.json')
      @tweets = TwitterSearch::Client.new.query('twitter search')
    end

    should_have_default_search_behaviors

    should 'find tweets containing both "twitter" and "search"' do
      assert @tweets.all?{ |t| t.text =~ /twitter/i && t.text =~ /search/i }
    end
  end

  context "two words with :q option" do
    setup do
      fake_query({ :q => 'twitter search' }, 'twitter_search.json')
      @tweets = TwitterSearch::Client.new.query(:q => 'twitter search')
    end

    should_have_default_search_behaviors

    should 'find tweets containing both "twitter" and "search"' do
      assert @tweets.all?{ |t| t.text =~ /twitter/i && t.text =~ /search/i }
    end
  end

  context "response is a 404" do
    setup do
      uri = "http://search.twitter.com/search.json?q=rails+-from%3Adhh+from%3Alof&since_id=1791298088"
      FakeWeb.register_uri(:get, uri,
        :response => File.here / 'responses' / 'complicated_search_404',
        :status   => [404, "Not Found"])
    end

    should "raise a SearchServerError" do
      assert_raise TwitterSearch::SearchServerError do
        client = TwitterSearch::Client.new
        client.query(:q => 'rails -from:dhh from:lof', :since_id => 1791298088)
      end
    end
  end

  context "response is 200 but an unparsable body" do
    setup do
      uri = "http://search.twitter.com/search.json?rpp=100&q=ftc&since_id=2147483647&page=16"
      FakeWeb.register_uri(:get, uri,
        :response => File.here / 'responses' / 'error_page_parameter_403',
        :status   => [403, "Forbidden"])
    end

    should "raise a SearchServerError" do
      assert_raise TwitterSearch::SearchServerError do
        client = TwitterSearch::Client.new
        client.query(:q => 'ftc', :rpp => '100', :since_id => '2147483647', :page => '16')
      end
    end
  end
end
