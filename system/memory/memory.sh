totalmem=`sysctl -n hw.memsize`
totalmem=`expr $totalmem / 1024 / 1024`

top -l1 -u -o cpu -S | head -12 > /tmp/geektool-top.tmp
mem=`grep PhysMem /tmp/geektool-top.tmp`
mem=${mem#*:}

# wired memory
wired=${mem%%M wired,*}
mem=${mem#*,}
ruby /Users/bit_jammer/Development/geektool/system/memory.rb $wired wired $totalmem

# active memory
active=${mem%%M active,*}
mem=${mem#*,}
ruby /Users/bit_jammer/Development/geektool/system/memory.rb $active active $totalmem

# inactive memory
inactive=${mem%%M inactive,*}
mem=${mem#*,}
ruby /Users/bit_jammer/Development/geektool/system/memory.rb $inactive inactive $totalmem

# used
used=${mem%%M used,*}
mem=${mem#*,}
ruby /Users/bit_jammer/Development/geektool/system/memory.rb $used used $totalmem

# free
free=${mem%%M free.*}
ruby /Users/bit_jammer/Development/geektool/system/memory.rb $free free $totalmem

#ruby /Users/bit_jammer/Development/geektool/system/memory.rb $totalmem $wired $active $inactive $used $free memory
