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
      tweet = double('Tweet')
      tweet.stub(:text){"Tweet with url http://www.abc.com"}
      TwitterSearch::Client.any_instance.stub(:query).and_return([tweet,tweet,tweet])
      @obj.urls.should eq ["http://www.abc.com"]
    end

    it "should set appropriate massage if error occurs while extracting tweets" do
      TwitterSearch::Client.any_instance.stub(:query) {raise 'An error has occured'}
      @obj.urls
      @obj.message.should eq "Somethig went wrong while extacting tweets from twitter"
    end

    it "should set appropriate massage if there are no tweets related to given hashtag" do
      TwitterSearch::Client.any_instance.stub(:query).and_return([])
      @obj.urls
      @obj.message.should eq "There are no tweets related to given hashtag - ror"
    end

    it "should set appropriate massage if there are no ulrs in tweets related to given hashtag" do
      tweet = double('Tweet')
      tweet.stub(:text){"Tweet wothout url"}
      TwitterSearch::Client.any_instance.stub(:query).and_return([tweet,tweet,tweet])
      @obj.urls
      @obj.message.should eq "There are no urls in tweets related to given hashtag - ror"
    end
  end
    
end
