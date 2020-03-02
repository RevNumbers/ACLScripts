#!/bin/bash
mkdir inside_acl_OBJ-ports 2>/dev/null

while read -r line
  do
    MATCH="$(grep $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}')"
    MATCH2="$(echo $line | awk '{print $1,$6}')" 

    echo $MATCH2 >> inside_acl_OBJ-ports/$MATCH
    #echo $MATCH
    #echo $MATCH2

done < $1
