#!/bin/bash

# This script looks at the log entries for "inbound" traffic
# "inbound" in this case is from the outside to the inside

# Example filtered log input:
#
# inbound     outside     172.21.5.169     62572     inside     10.105.104.147     389        tcp
#    ^           ^             ^             ^          ^             ^             ^          ^
# direction   src_int       src_ip       src_port    dst_int       dst_ip        dst_port   protocol
#


#Array Assignments:
# 0     -       Direction
# 1     -       Source Interface
# 2     -       Source IP
# 3     -       Source Port
# 4     -       Destination Interface
# 5     -       Destination IP
# 6     -       Destination Port
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
  echo "${logline[7]} ${logline[1]} ${logline[2]} ${logline[4]} ${logline[5]} ${logline[6]}"
done < $1 > inbound_traffic.txt

sort inbound_traffic.txt -o inbound_traffic-sorted.txt
uniq inbound_traffic-sorted.txt inbound_traffic-sorted-uniq.txt

