require 'rubygems'
require File.join(File.dirname(__FILE__), 'twitter-search/lib/twitter_search')


  
module HashtagUrls

class TwitterUrls
  
  def initialize(hashtag)
     @hashtag = hashtag
  end

  # fecting twitts related to hashtag from twitter
  def extract_twitts
    validate_hashtag
    client = TwitterSearch::Client.new('thunderthimble')
    client.query(:q => "##{@hashtag}", :rpp => '100')
  end

  # extracting unique urls from the given twitts
  def extract_urls_from_twitts(twitts)
    twitt_urls = []
    twitts.each{|tweet| twitt_urls += URI.extract(tweet.text,'http')}
    twitt_urls.uniq
  end
  
  # formating the extracted urls
  def format_urls(twitt_urls)
    formated_urls=""
    twitt_urls.each_with_index do |url, i|
      formated_urls += (i+1).to_s + ". " + url + "\n"
    end
    formated_urls
  end

  private
  
  # validating input given as hashtag is a string
  def validate_hashtag
    raise HashtagUrls::HashtagTypeError, "Provide String as a hashtag" unless @hashtag.class == String
  end

end

class HashtagTypeError < ArgumentError
end

end
