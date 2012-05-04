require 'rubygems'
require 'twitter_search'


  
module HashtagUrls

  class TwitterUrls
    attr_reader :message 
 
    def initialize(hashtag)
      @hashtag = hashtag
      validate_hashtag
    end

    # returns uls 
    def urls
      @urls ||= get_urls
    end

  
    private
  
    def get_urls
      tweet_urls = []
      tweets = extract_tweets
      if tweets.none?
        @message = "There are no tweets related to given hashtag - #{@hashtag}" unless @message
        tweet_urls
      else
        tweets.each{|tweet| tweet_urls += URI.extract(tweet.text,'http')}
        @message = "There are no urls in tweets related to given hashtag - #{@hashtag}" if tweet_urls.empty?
        tweet_urls.uniq
      end
    end

    # fetching tweets related to hashtag from twitter
    def extract_tweets
      begin
        client = TwitterSearch::Client.new
        client.query(:q => "##{@hashtag}", :rpp => '100')
      rescue
        @message = "Somethig went wrong while extacting tweets from twitter"
        []
      end
    end

    # validating input given as hashtag is a string
    def validate_hashtag
      raise HashtagUrls::HashtagTypeError, "Provide String as a hashtag" unless @hashtag.class == String
    end

  end

  class HashtagTypeError < ArgumentError
  end

end