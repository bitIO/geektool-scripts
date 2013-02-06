dataen=`sar -n DEV 1 1 | egrep "^Average:\ *$1" | awk '{ print $3,$4,$5,$6 }'`
ipkts=`echo $dataen | cut -d ' ' -f1`
ibytes=`echo $dataen | cut -d ' ' -f2`
opkts=`echo $dataen | cut -d ' ' -f3`
obytes=`echo $dataen | cut -d ' ' -f4`
printf "       Ipakts/s: %-15s Opakts/s: %-15s\n" "$ipkts" "$opkts"
printf "       Ibytes/s: %-15s Obytes/s: %-15s\n" "$ibytes" "$obytes"
ruby /Users/bit_jammer/Development/geektool/system/network/networkgraph-gruff.rb $2 $ibytes $obytes
