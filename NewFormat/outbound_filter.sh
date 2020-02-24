#!/bin/bash

# This script looks at the log entries for "outbound" traffic
# "outbound" in this case is from the inside to the outside

# Example filtered log input:
#
# outbound     outside     10.24.11.35     135     inside     10.105.104.10     52149       tcp
#    ^            ^             ^           ^        ^              ^             ^          ^
# direction    dst_int       dst_ip     dst_port   src_int        src_ip       src_port   protocol

#Array Assignments:
# 0	-	Direction
# 1	-	Destination Interface
# 2	-	Destination IP
# 3	-	Destination Port
# 4	-	Source Interface
# 5	-	Source IP
# 6	-	Source Port
# 7	-	TCP/UDP

function acl_output () {
  # define an array with the current line
  #line="$1"
  #logline=($(echo $line))
  #echo "access-list inside_access_list extended permit tcp ${logline[5]} 255.255.255.0 ${logline[2]} 255.255.255.0 eq ${logline[3]}"
  echo "access-list inside_access_list extended permit tcp $5 255.255.255.0 $2 255.255.255.0 eq $3"
}

function subnet () {
  echo $1 | awk -F"." '{print $1 "." $2 "." $3 ".0"}'
}

while read -r line
  do
  # define an array with the current line
  logline=($(echo $line))
  echo "${logline[7]} ${logline[4]} $(subnet ${logline[5]}) ${logline[1]} $(subnet ${logline[2]}) ${logline[3]}"
done < $1 > outbound_traffic.txt

sort outbound_traffic.txt -o outbound_traffic-sorted.txt
uniq outbound_traffic-sorted.txt outbound_traffic-sorted-uniq.txt
