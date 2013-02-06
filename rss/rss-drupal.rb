#!/usr/bin/ruby

require 'rubygems'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

source = "http://rubyforge.org/export/rss_sfnewreleases.php" # url or local file
content = "" # raw content of rss feed will be loaded here
open(source) do |s| content = s.read end
rss = RSS::Parser.parse(content, false)

#puts "Root values"
#print "RSS title: ", rss.channel.title, "\n"
#print "RSS link: ", rss.channel.link, "\n"
#print "RSS description: ", rss.channel.description, "\n"
#print "RSS publication date: ", rss.channel.date, "\n"
#
#puts "Item values"
#print "number of items: ", rss.items.size, "\n"
#print "title of first item: ", rss.items[0].title, "\n"
#print "link of first item: ", rss.items[0].link, "\n"
#print "description of first item: ", rss.items[0].description, "\n"
#print "date of first item: ", rss.items[0].date, "\n"
