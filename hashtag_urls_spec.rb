require 'rubygems'
require 'rspec'
require 'hashtag_urls'

describe HashtagUrls do
  before(:each) do
    @obj = HashtagUrls::TwitterUrls.new('ror')
  end

  describe "HashtagUrls::TwitterUrls.validate_hashtag" do
    it "should raise Error if anything other than string is provided as hashtag" do
      lambda{HashtagUrls::TwitterUrls.new(1)}.should raise_error
    end
  end

  describe "HashtagUrls::TwitterUrls.urls" do
    it "should extract urls pertaining to given hashtag" do
      @obj.urls.each do |url|
        url.should match /^http/
      end
    end
    
    it "should fetch atmost 100 twitts related to given hashtag" do
      @obj.urls.count.should be_between(1, 100)
    end
  end
    
end
