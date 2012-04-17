require 'hashtag_urls'

if ARGV.length != 1
  puts "Provide one hashtag!!! eg. ruby twitter_hashtag_urls <xyz>"
else
  obj =  HashtagUrls::TwitterUrls.new(ARGV[0])
  urls = obj.urls
  if urls.empty?
    puts obj.message
  else
    urls.each_with_index do |url, i|
      puts (i+1).to_s + ". " + url
    end
  end
end
