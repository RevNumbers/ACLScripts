#!/bin/bash

for i in *-uniq
  do 
    NETOBJECT=$(echo $i | awk -F"_" '{ print substr($0, index($0,$2)) }'| awk -F"-" '{print $1}')
    SEROBJECT=$(echo $NETOBJECT)_Services
    echo "object service $SEROBJECT"
    while read -r line
      do
        PROTOCOL=$(echo $line | awk '{print $1}')
        PORT=$(echo $line | awk '{print $2}')
        echo " service $PROTOCOL destination eq $PORT"
    done < $i
done


