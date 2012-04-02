require File.join(File.dirname(__FILE__), 'test_helper')

class ForeignLanguagesTest < Test::Unit::TestCase # :nodoc:
  context "english" do
    setup do
      query   = { :q => 'congratulations', :lang => 'en' }
      fake_query(query, 'english.json')
      @tweets = TwitterSearch::Client.new.query(query)
    end

    should_have_default_search_behaviors

    should 'find tweets containing "congratulations" and are in English' do
      assert @tweets.all? { |tweet|
        tweet.text     =~ /congratulation/i &&
        tweet.language == 'en'
      }
    end
  end

  # context "client.query(:q => 'با', :lang => 'ar')" do
  #   setup do
  #     query   = { :q => 'با', :lang => 'ar' }
  #     fake_query(query, 'arabic.json')
  #     @tweets = TwitterSearch::Client.new.query(query)
  #   end

  #   should_have_default_search_behaviors

  #   should 'find tweets containing "با" and are in Arabic' do
  #     assert @tweets.all? { |tweet|
  #       tweet.text.include?('با') &&
  #       tweet.language == 'ar'
  #     }
  #   end
  # end
end
