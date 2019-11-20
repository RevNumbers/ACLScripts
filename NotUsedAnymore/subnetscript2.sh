#!/bin/bash
COUNT=
ACL=
PROTO=
SRCINT=
SRCADDR=
DSTINT=
DSTADDR=
DSTPORT=

while read line
  do
    ACEMOD=$(echo $line | awk -F"/" '{print $1 " " $2 " " $3}')
    ACE=$(echo $ACEMOD | awk '{print $1,$2,$3,$4,$5,$6,$7,$8}')
    COUNT=$(echo $ACE | awk '{print $1}')
    ACL=$(echo $ACE | awk '{print $2}')
    PROTO=$(echo $ACE | awk '{print $3}')
    SRCINT=$(echo $ACE | awk '{print $4}')
    SRCADDR=$(echo $ACE | awk '{print $5}')
    SRCSUBN=$(echo $ACE | awk '{print $5}' | awk -F"." '{print $1 "." $2 "." $3 ".0"}')
    DSTINT=$(echo $ACE | awk '{print $6}')
    DSTADDR=$(echo $ACE | awk '{print $7}')
    DSTSUBN=$(echo $ACE | awk '{print $7}'| awk -F"." '{print $1 "." $2 "." $3 ".0"}')
    DSTPORT=$(echo $ACE | awk '{print $8}')
    echo -e "Log Entry:\t" $ACL $PROTO $SRCINT $SRCSUBN $DSTINT $DSTSUBN $DSTPORT
    echo -e "Access Entry:\t" access-list $ACL extended permit $PROTO $SRCSUBN 255.255.255.0 $DSTSUBN 255.255.255.0 eq $DSTPORT 
    echo
done < $1
