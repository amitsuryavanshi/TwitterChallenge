require 'hashtag_urls'

if ARGV.length != 1
 puts "Provide one hashtag!!! eg. ruby twitter_hashtag_urls <xyz>"
else
 obj =  HashtagUrls::TwitterUrls.new(ARGV[0])
 tweets = obj.extract_twitts
 if tweets.none?
  puts "There are no tweets related to given hashtag"
 else  
  urls = obj.extract_urls_from_twitts(tweets)
  puts urls.empty? ? "There are no urls in tweets related to given hashtag" : obj.format_urls(urls)
 end
end

