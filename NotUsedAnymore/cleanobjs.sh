#!/bin/bash
for i in inside_OBJs/*.tmp
  do
    OBJFILENAME=$(echo $i | awk -F"." '{print $1"."$2}')
    cat $i | awk 'NR<3{print $0;next}{print $0| "sort -r"}' | uniq > $OBJFILENAME
    rm $i
done
for o in outside_OBJs/*.tmp
  do
    OBJFILENAME=$(echo $o | awk -F"." '{print $1"."$2}')
    cat $o | awk 'NR<3{print $0;next}{print $0| "sort -r"}' | uniq > $OBJFILENAME
    rm $o
done
