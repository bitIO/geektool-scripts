#!/usr/bin/ruby

RMAGICK_BYPASS_VERSION_TEST = true

require "rubygems"
require "sparklines"

begin
  basepath =  "/Users/bit_jammer/Development/geektool/system/network/"
  graphpath = "/Users/bit_jammer/Development/geektool/system/graphs/network/"
  dataarray = Array.new
  
  # read data from file (if not empty)
  if !File.exists? basepath + ARGV[0] + ".bin"
    f = File.new basepath + ARGV[0] + ".bin", "w+"
  end
  data = File.read(basepath + ARGV[0] + ".bin")  
  if data.length > 0 && data != '""'
    dataarray = data.split(" ")
  end
  # array can contain only a fixed number elements
  if dataarray.length == 50
    dataarray.pop
  end
  dataarray.push ARGV[1]

  if dataarray.length < 50
    return
  end
  
  # create the graph
  output = graphpath  + ARGV[0] + ".png"
  plot = dataarray.map{|i| i.to_f}
  
  Sparklines.plot_to_file(
    output, plot, {
      :background_color => 'transparent',
      :type => 'area',
      :height => 50,
      :has_max => true,
      :upper => -100000000 
    }    
  )

  # update file date and write to file  
  File.open(basepath + ARGV[0] + ".bin", "w") do |file|
    file.printf("%s", dataarray.join(" ")) 
  end
rescue Exception => e
  puts e.message
  puts e.backtrace
end
