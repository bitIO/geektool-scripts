#!/usr/bin/ruby

RMAGICK_BYPASS_VERSION_TEST = true

require "rubygems"
require "gruff"
require "fileutils"

def getfilecontent(path)
  # read data from file (if not empty)
  if !File.exists? path
    f = File.new path, "w+"
  end
  data = File.read( path )  
  if data.length > 0 && data != '""'
    return dataarray = data.split(" ")
  else
    return Array.new
  end
end

def injectvalue(array, value)
  # array can contain only a fixed number elements
  while array.length >= 50 
    array.shift
  end
  array.push value.to_f
  return array.length == 50
end

def updatefiles(array, file)
  # update file date and write to file  
  File.open(file, "w") do |file|
    file.printf("%s", array.join(" ")) 
  end
end

begin
  basepath      = "/Users/bit_jammer/Development/geektool/system/network/"
  graphpath     = "/Users/bit_jammer/Development/geektool/system/graphs/network/" + ARGV[0] + ".png"
  
  indataarray  = getfilecontent  basepath + ARGV[0] + "in.bin"
  outdataarray = getfilecontent  basepath + ARGV[0] + "out.bin"
  if injectvalue(indataarray,ARGV[1]) && injectvalue(outdataarray,ARGV[2])
    
    # create the graph 
    g = Gruff::Line.new 400
    g.data(ARGV[0] + " in", indataarray.map{|i| i.to_f})
    g.data(ARGV[0] + " out", outdataarray.map{|i| i.to_f})
  #  g.hide_legend=true
    g.hide_title=true
    g.hide_dots=true
#    g.hide_line_markers=true
#    g.hide_line_numbers=true
    g.legend_font_size=30
#    g.maximum_value=5300000
    g.theme = {
     :colors => %w(orange purple green white red),
  #   :marker_color => 'blue',
     :background_colors => 'transparent',
     :font_color => 'white',
    }
    g.write graphpath
  end
    
  updatefiles(indataarray, basepath + ARGV[0] + "in.bin")
  updatefiles(outdataarray, basepath + ARGV[0] + "out.bin")
rescue Exception => e
  puts e.message
  puts e.backtrace
end
