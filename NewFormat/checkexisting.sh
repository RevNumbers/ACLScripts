#!/bin/bash
function acl_output () {
  echo "$1 $3 255.255.255.0 $5 255.255.255.0 eq $6"
}

while read -r line
  do
    grep "`acl_output $line`" $2 >/dev/null
    if [ $? -eq 1 ]
      then
        echo $line
    fi
done < $1
