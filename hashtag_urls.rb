require 'rubygems'
require 'twitter_search'


  
module HashtagUrls

  class TwitterUrls
    attr_accessor :message 
 
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
      twitt_urls = []
      twitts = extract_twitts
      if twitts.none?
        @message = "There are no tweets related to given hashtag - #{@hashtag}" unless @message
        twitt_urls
      else
        twitts.each{|tweet| twitt_urls += URI.extract(tweet.text,'http')}
        @message = "There are no urls in tweets related to given hashtag - #{@hashtag}" if twitt_urls.empty?
        twitt_urls.uniq
      end
    end

    # fecting twitts related to hashtag from twitter
    def extract_twitts    
      begin
        client = TwitterSearch::Client.new
        client.query(:q => "##{@hashtag}", :rpp => '100')
      rescue
        @message = "Somethig went wrong while extacting twitts from twitter"
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