#!/bin/bash
while read line
  do
   newline="$(echo -n $(echo $line | grep -oE '^[[:digit:]]{1,6}[[:blank:]][[:alpha:]]{6,7}_acl[[:blank:]][[:alpha:]]{3}[[:blank:]][[:alpha:]]{6,7}\/[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.'))"
   newline="$newline$(echo -n "0 ")"
   newline="$newline $(echo $line | awk '{print $5,$6}')"
   port="$(echo $newline | awk '{print $NF}')"
   secondoctet=$(echo $newline | awk -F"/" '{print $3}' | grep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
   newnewline="$(echo $newline | awk -F"/" '{print $1"/"$2"/"}')$secondoctet"
   newnewline="$(echo $newnewline)0 $port"
   echo $newnewline
   
done < $1
