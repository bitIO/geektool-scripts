#!/bin/bash
myen0=`ifconfig en0 | grep "inet " | grep -v 127.0.0.1 | awk '{printf("%s", $2 (NR==1 ? " / " : ""))}'`
if [ "$myen0" == "" ]
then
  printf "INACTIVE\n\n\n\n"
else
	printf "My ip(s): $myen0\n"
	dataen=`sar -n DEV 1 1 | egrep "^Average:\ *en0" | awk '{ print $3,$4,$5,$6 }'`
	ipkts=`echo $dataen | cut -d ' ' -f1`
	ibytes=`echo $dataen | cut -d ' ' -f2`
	opkts=`echo $dataen | cut -d ' ' -f3`
	obytes=`echo $dataen | cut -d ' ' -f4`
	printf "Ipakts/s: %-10s Opakts/s: %-10s\n" "$ipkts" "$opkts"
	printf "Ibytes/s: %-10s Obytes/s: %-10s\n" "$ibytes" "$obytes"
	ruby /Users/bit_jammer/Development/geektool/system/network/networkgraph-gruff.rb ethernet $ibytes $obytes
fi
