require File.join(File.dirname(__FILE__), 'test_helper')

class PaginationTest < Test::Unit::TestCase # :nodoc:
  context "results per page" do
    setup do
      query   = { :q => 'Boston Celtics', :rpp => '30' }
      fake_query(query, 'results_per_page.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_find_tweets
    should_have_text_for_all_tweets
    should_return_page 1
    should_return_tweets_in_sets_of 30
  end

  context "@client.query :q => 'a Google(or Twitter)whack', :rpp => '2'" do
    setup do
      query   = { :q => 'beginning class is in-depth ruby', :rpp => '2' }
      fake_query(query, 'only_one_result.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should 'not be able to get next page of @tweets' do
      assert ! @tweets.has_next_page?
    end
  end

  context "get next page" do
    setup do
      query     = { :q => 'thoughtbot', :rpp => '1' }
      fake_query(query, 'page_one.json')
      @page_one = TwitterSearch::Client.new.query(query)

      query     = { :q => 'thoughtbot', :rpp => '1', :page => '2' }
      fake_query(query, 'page_two.json')
      @page_two = TwitterSearch::Client.new.query(query)
    end

    should 'be able to get next page of @tweets' do
      assert @page_one.has_next_page?

      query_string = "max_id=2407099995&q=thoughtbot&rpp=1&page=2"
      uri = "#{TwitterSearch::Client::TWITTER_SEARCH_API_URL}?#{query_string}"
      FakeWeb.register_uri(:get, uri,
        :response => File.here / 'json' / "page_two.json")

      next_page = @page_one.get_next_page
      assert_equal @page_two[0].created_at, next_page[0].created_at
      assert_equal @page_two[0].text,       next_page[0].text
    end
  end
end
