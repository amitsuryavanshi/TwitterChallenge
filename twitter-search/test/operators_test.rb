require File.join(File.dirname(__FILE__), 'test_helper')

class OperatorsTest < Test::Unit::TestCase # :nodoc:
  context "quoted phrase" do
    setup do
      query   = { :q => '"happy hour"' }
      fake_query(query, 'happy_hour_exact.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing the exact phrase "happy hour"' do
      @tweets.each do |tweet|
        assert_match /happy hour/i, tweet.text
      end
    end
  end

  context "OR" do
    setup do
      query   = { :q => 'obama OR hillary' }
      fake_query(query, 'obama_or_hillary.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing either "obama" or "hillary" (or both)' do
      @tweets.each do |tweet|
        assert_match /obama|hillary/i, tweet.text
      end
    end
  end

  context "minus" do
    setup do
      query   = { :q => 'beer -root' }
      fake_query(query, 'beer_minus_root.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing "beer" but not "root"' do
      assert @tweets.all? { |tweet|
        tweet.text =~ /beer/i ||
        tweet.text !~ /root/i
      }
    end
  end

  context "hashtag" do
    setup do
      query   = { :q => '#haiku' }
      fake_query(query, 'hashtag_haiku.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing the hashtag "haiku"' do
      @tweets.each do |tweet|
        assert_match /#haiku/i, tweet.text
      end
    end
  end

  context "from" do
    setup do
      query   = { :q => 'from:alexiskold' }
      fake_query(query, 'from_alexiskold.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets sent from person "alexiskold"' do
      @tweets.each do |tweet|
        assert_equal 'alexiskold', tweet.from_user
      end
    end
  end

  context "to" do
    setup do
      query   = { :q => 'to:techcrunch' }
      fake_query(query, 'to_techcrunch.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets sent to person "techcrunch"' do
      @tweets.each do |tweet|
        assert_match /^@techcrunch/i, tweet.text
      end
    end
  end

  context "@client.query :q => '@mashable'" do
    setup do
      query   = { :q => '@mashable' }
      fake_query(query, 'reference_mashable.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets referencing person "mashable"' do
      @tweets.each do |tweet|
        assert_match /@mashable/i, tweet.text
      end
    end
  end

  context "near" do
    should 'raise SearchOperatorError' do
      assert_raise TwitterSearch::SearchOperatorError do
        client = TwitterSearch::Client.new
        client.query '"happy hour" near:"san francisco"'
      end
    end
  end

  context "within" do
    should 'raise SearchOperatorError' do
      assert_raise TwitterSearch::SearchOperatorError do
        client = TwitterSearch::Client.new
        client.query 'near:NYC within:15mi'
      end
    end
  end

  context "since" do
    setup do
      query   = { :q => 'superhero since:2009-06-29' }
      fake_query(query, 'superhero_since.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should "find tweets containing superhero" do
      @tweets.each do |tweet|
        assert_match /superhero/i, tweet.text
      end
    end

    should 'find tweets sent since date "2009-06-29" (year-month-day)' do
      @tweets.each do |tweet|
        date = convert_date(tweet.created_at)
        assert date > DateTime.new(2009, 6, 29)
      end
    end
  end

  context "until" do
    setup do
      query   = { :q => 'ftw until:2009-06-30' }
      fake_query(query, 'ftw_until.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should "find tweets containing ftw" do
      @tweets.each do |tweet|
        assert_match /ftw/i, tweet.text
      end
    end

    should "find tweets sent up to date 2009-06-30" do
      @tweets.each do |tweet|
        assert convert_date(tweet.created_at) < DateTime.new(2009, 6, 30, 11, 59)
      end
    end
  end

  context "positive attitude" do
    setup do
      query   = { :q => 'movie -scary :)' }
      fake_query(query, 'movie_positive_tude.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing "movie", but not "scary", and with a positive attitude' do
      assert @tweets.all? { |tweet|
        tweet.text =~ /movie/i &&
        tweet.text !~ /scary/i &&
        positive_attitude?(tweet.text)
      }
    end
  end

  context "negative attitude" do
    setup do
      query   = { :q => 'flight :(' }
      fake_query(query, 'flight_negative_tude.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing "flight" and with a negative attitude' do
      assert @tweets.all? { |tweet|
        tweet.text =~ /flight/i &&
        negative_attitude?(tweet.text)
      }
    end
  end

  context "question" do
    setup do
      query   = { :q => 'traffic ?' }
      fake_query(query, 'traffic_question.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing "traffic" and asking a question' do
      assert @tweets.all? { |tweet|
        tweet.text =~ /traffic/i &&
        tweet.text.include?('?')
      }
    end
  end

  context "filter" do
    setup do
      query   = { :q => 'hilarious filter:links' }
      fake_query(query, 'hilarious_links.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing "hilarious" and linking to URLs' do
      assert @tweets.all? { |tweet|
        tweet.text =~ /hilarious/i &&
        hyperlinks?(tweet.text)
      }
    end
  end
end
