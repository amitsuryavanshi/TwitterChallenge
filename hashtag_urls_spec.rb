require 'rubygems'
require 'rspec'
require 'hashtag_urls'

describe HashtagUrls do
  
  before(:each) do
    @obj = HashtagUrls::TwitterUrls.new('ror')
  end

  describe "HashtagUrls.validate_hashtag" do
    it "should raise Error if anything other than string is provided as hashtag" do
      lambda{HashtagUrls::TwitterUrls.new(1)}.should raise_error
    end
  end

  describe "HashtagUrls.extract_twitts" do
    it "should fetch atmost 100 twitts related to given hashtag" do
      twitts = @obj.extract_twitts
      twitts.first.should be_an_instance_of TwitterSearch::Tweet
      twitts.count.should be_between(1, 100)
    end
  end
  
  describe "HashtagUrls.extract_urls_from_twitts" do
    it "should extract urls from given twitts" do
      twitts = @obj.extract_twitts
      urls = @obj.extract_urls_from_twitts(twitts)
      urls.each do |url|
        url.should match /^http/
      end
    end
  end
  
  describe "HashtagUrls.format_urls" do
    it "should format given urls" do
      twitts = @obj.extract_twitts
      urls = @obj.extract_urls_from_twitts(twitts)
      formated_urls = @obj.format_urls(urls)
      formated_urls.should match /^[1..100]. http/
    end
  end
end
