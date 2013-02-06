#!/usr/bin/ruby

require "rubygems"
require "twitter"
begin
  
  Twitter.configure do |config|
    config.consumer_key = 'Ka1mAWKH7CMB5pfnuAkA'
    config.consumer_secret = 'gPXA3A3bBs5z5LcnRP1IvJ1H0nesWScacaze6bUSocc'
    config.oauth_token =  '68004390-gBcedhTNsiuTjHjOQA8vBtX161txJw8I6FO6vmd4'
    config.oauth_token_secret = 'AMiORj91b3kEbhC9W4DIJEX9RtO2lcgfBcVj4rAndU'
  end
  
  # Initialize your Twitter client
  client = Twitter::Client.new

  timeline = client.home_timeline :count => 100
  while timeline.length > 0
    tweet = timeline.shift
    # key values are:
    # id, created_at, source, truncated, reteewt_count, retweeted, source, test, 
    # user { name, profile_image_url, screen_name}
    puts tweet
  end
rescue Exception => e
  puts e.message
  puts e.backtrace
end