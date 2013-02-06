#!/bin/bash
printf "External ip is "
wip=`curl --silent http://checkip.dyndns.org | awk '{print $6}' | cut -f 1 -d "<"`
printf "%s" "$wip"
