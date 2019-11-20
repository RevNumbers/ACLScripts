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
        declare DSTOBJ_$PROTO$DSTPORT="DSTOBJ_$PROTO$DSTPORT $DSTADDR"
        CURRENTDSTOBJ="DSTOBJ_$PROTO$DSTPORT"
        echo "DSTPORT  is $DSTPORT"
        echo "PREVPORT is $PREVPORT"
        echo "$CURRENTDSTOBJ is ${!CURRENTDSTOBJ}"
        echo "DSTOBJS is $DSTOBJS"
        echo -e "network-object $DSTADDR 255.255.255.0" >> inside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
      else
        echo -e "object-group network DSTOBJ_$PROTO$DSTPORT" >> inside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
        echo -e "description source networks for $PROTO$DSTPORT" >> inside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
        echo -e "network-object $DSTADDR 255.255.255.0" >> inside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
        DSTOBJS="$DSTOBJS $CURRENTDSTOBJ"
    fi
  else
    if [ $DSTPORT == $PREVPORT ]
      then
        declare DSTOBJ_$PROTO$DSTPORT="DSTOBJ_$PROTO$DSTPORT $DSTADDR"
        CURRENTDSTOBJ="DSTOBJ_$PROTO$DSTPORT"
        echo "DSTPORT  is $DSTPORT"
        echo "PREVPORT is $PREVPORT"
        echo "$CURRENTDSTOBJ is ${!CURRENTDSTOBJ}"
        echo "DSTOBJS is $DSTOBJS"
        echo -e "network-object $DSTADDR 255.255.255.0" >> outside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
      else
        echo -e "object-group network DSTOBJ_$PROTO$DSTPORT" >> outside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
        echo -e "description source networks for $PROTO$DSTPORT" >> outside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
        echo -e "network-object $DSTADDR 255.255.255.0" >> outside_OBJs/DSTOBJ_$PROTO$DSTPORT.txt.tmp
        DSTOBJS="$DSTOBJS $CURRENTDSTOBJ"
     fi
fi
    PREVPORT=$DSTPORT
done < $1

# Clean up the objects (removing duplicates)
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
