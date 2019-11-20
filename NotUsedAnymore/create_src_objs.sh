#!/bin/bash
COUNT=
ACL=
PROTO=
SRCINT=
SRCADDR=
DSTINT=
DSTADDR=
DSTPORT=
PREVPORT=1
mkdir inside_OBJs 2>/dev/null
mkdir outside_OBJs 2>/dev/null

while read line
  do
    ACE=$(echo $line | awk '{print $1,$2,$3,$4,$5,$6,$7}')
    ACL=$(echo $ACE | awk '{print $1}')
    PROTO=$(echo $ACE | awk '{print $2}')
    SRCINT=$(echo $ACE | awk '{print $3}')
    SRCADDR=$(echo $ACE | awk '{print $4}')
    DSTINT=$(echo $ACE | awk '{print $5}')
    DSTADDR=$(echo $ACE | awk '{print $6}')
    DSTPORT=$(echo $ACE | awk '{print $7}')
    #echo -e "Log Entry:\t" $ACL $PROTO $SRCINT $SRCADDR $DSTINT $DSTADDR $DSTPORT
    #echo -e "Access Entry:\t" access-list $ACL extended permit $PROTO $SRCADDR 255.255.255.0 $DSTADDR 255.255.255.0 eq $DSTPORT
    #echo
  if [[ $SRCINT =~ "inside" ]]
   then
    if [ $DSTPORT == $PREVPORT ]
      then
        declare SRCOBJ_$PROTO$DSTPORT="SRCOBJ_$PROTO$DSTPORT $SRCADDR"
        CURRENTSRCOBJ="SRCOBJ_$PROTO$DSTPORT"
        echo "DSTPORT  is $DSTPORT"
        echo "PREVPORT is $PREVPORT"
        echo "$CURRENTSRCOBJ is ${!CURRENTSRCOBJ}"
        echo "SRCOBJS is $SRCOBJS"
        echo -e "network-object $SRCADDR 255.255.255.0" >> inside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
      else
        echo -e "object-group network SRCOBJ_$PROTO$DSTPORT" >> inside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
        echo -e "description source networks for $PROTO$DSTPORT" >> inside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
        echo -e "network-object $SRCADDR 255.255.255.0" >> inside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
        SRCOBJS="$SRCOBJS $CURRENTSRCOBJ"
    fi
  else
    #echo DSTPORT is $DSTPORT
    #echo PREVPORT is $PREVPORT
    if [ $DSTPORT == $PREVPORT ]
      then
        declare SRCOBJ_$PROTO$DSTPORT="SRCOBJ_$PROTO$DSTPORT $SRCADDR"
        CURRENTSRCOBJ="SRCOBJ_$PROTO$DSTPORT"
        echo "DSTPORT  is $DSTPORT"
        echo "PREVPORT is $PREVPORT"
        echo "$CURRENTSRCOBJ is ${!CURRENTSRCOBJ}"
        echo "SRCOBJS is $SRCOBJS"
        echo -e "network-object $SRCADDR 255.255.255.0" >> outside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
      else
        echo -e "object-group network SRCOBJ_$PROTO$DSTPORT" >> outside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
        echo -e "description source networks for $PROTO$DSTPORT" >> outside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
        echo -e "network-object $SRCADDR 255.255.255.0" >> outside_OBJs/SRCOBJ_$PROTO$DSTPORT.txt
        SRCOBJS="$SRCOBJS $CURRENTSRCOBJ"
     fi
fi
    PREVPORT=$DSTPORT
done < $1

