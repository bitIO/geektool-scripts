#!/usr/bin/ruby

require "rubygems"
require "gruff"
require "sparklines"
begin   
=begin
  g = Gruff::Pie.new
  g.maximum_value=ARGV[2].to_i
  g.minimum_value=0
  #g.data( ARGV[1], ARGV[0].to_i )
  #g.data( 'Total', ARGV[2].to_i )
  g.data( 'Total', ARGV[0].to_i )
  g.data( 'Wired', ARGV[1].to_i )
  g.data( 'Active', ARGV[2].to_i )
  g.data( 'Inactive', ARGV[3].to_i )
  g.data( 'Used', ARGV[4].to_i )
  g.data( 'Free', ARGV[5].to_i )

  g.theme = {
   :colors => %w(orange purple green white red),
   :marker_color => 'blue',
   :background_colors => 'transparent',
   :font_color => 'white'
 }


  g.write("/Users/bit_jammer/Development/geektool/system/graphs/" + ARGV[6] + ".png")
=end

  output="/Users/bit_jammer/Development/geektool/system/graphs/"  + ARGV[1] + ".png"
  percentage=(ARGV[0].to_i*100)/ARGV[2].to_i
  Sparklines.plot_to_file(
    output, percentage, {
      :background_color => 'transparent',
      :type => 'pie',
      :upper => 200,
      :diameter => 100,
      :remain_color => 'green',
    }    
  )
   
rescue Exception => e
  puts e.message
  puts e.backtrace
end
