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
    ACE=$(echo $line | awk '{print $1,$2,$3,$4,$5,$6}')
    ACL=$(echo $(echo $ACE | awk '{print $2}')_acl)
    PROTO=$(echo $ACE | awk '{print $1}')
    SRCINT=$(echo $ACE | awk '{print $2}')
    SRCADDR=$(echo $ACE | awk '{print $3}')
    DSTINT=$(echo $ACE | awk '{print $4}')
    DSTADDR=$(echo $ACE | awk '{print $5}')
    DSTPORT=$(echo $ACE | awk '{print $6}')
    #echo -e "Log Entry:\t" $ACL $PROTO $SRCINT $SRCADDR $DSTINT $DSTADDR $DSTPORT
    #echo -e "Access Entry:\t" access-list $ACL extended permit $PROTO $SRCADDR 255.255.255.0 $DSTADDR 255.255.255.0 eq $DSTPORT
    #echo
  if [[ $ACL =~ "inside_acl" ]]
   then
    if [ $DSTPORT == $PREVPORT ]
      then
        declare SRCOBJ_$PROTO$DSTPORT="SRCOBJ_$PROTO$DSTPORT $SRCADDR"
        CURRENTSRCOBJ="SRCOBJ_$PROTO$DSTPORT"
        echo "DSTPORT  is $DSTPORT"
        echo "PREVPORT is $PREVPORT"
        echo "$CURRENTSRCOBJ is ${!CURRENTSRCOBJ}"
        echo "SRCOBJS is $SRCOBJS"
        echo -e "network-object $SRCADDR 255.255.255.0" >> inside_OBJs/SRCOBJin_$PROTO$DSTPORT.txt.tmp
      else
        echo -e "object-group network SRCOBJin_$PROTO$DSTPORT" >> inside_OBJs/SRCOBJin_$PROTO$DSTPORT.txt.tmp
        echo -e "description source networks for inside_acl $PROTO port $DSTPORT" >> inside_OBJs/SRCOBJin_$PROTO$DSTPORT.txt.tmp
        echo -e "network-object $SRCADDR 255.255.255.0" >> inside_OBJs/SRCOBJin_$PROTO$DSTPORT.txt.tmp
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
        echo -e "network-object $SRCADDR 255.255.255.0" >> outside_OBJs/SRCOBJout_$PROTO$DSTPORT.txt.tmp
      else
        echo -e "object-group network SRCOBJout_$PROTO$DSTPORT" >> outside_OBJs/SRCOBJout_$PROTO$DSTPORT.txt.tmp
        echo -e "description source networks for outside_acl $PROTO port $DSTPORT" >> outside_OBJs/SRCOBJout_$PROTO$DSTPORT.txt.tmp
        echo -e "network-object $SRCADDR 255.255.255.0" >> outside_OBJs/SRCOBJout_$PROTO$DSTPORT.txt.tmp
        SRCOBJS="$SRCOBJS $CURRENTSRCOBJ"
     fi
fi
    PREVPORT=$DSTPORT
done < $1

# Reset our variables before we run it again for SRC objects
COUNT=
ACL=
PROTO=
SRCINT=
SRCADDR=
DSTINT=
DSTADDR=
DSTPORT=
PREVPORT=1

while read line
  do
    ACE=$(echo $line | awk '{print $1,$2,$3,$4,$5,$6}')
    ACL=$(echo $(echo $ACE | awk '{print $2}')_acl)
    PROTO=$(echo $ACE | awk '{print $1}')
    SRCINT=$(echo $ACE | awk '{print $2}')
    SRCADDR=$(echo $ACE | awk '{print $3}')
    DSTINT=$(echo $ACE | awk '{print $4}')
    DSTADDR=$(echo $ACE | awk '{print $5}')
    DSTPORT=$(echo $ACE | awk '{print $6}')
    #echo -e "Log Entry:\t" $ACL $PROTO $SRCINT $SRCADDR $DSTINT $DSTADDR $DSTPORT
    #echo -e "Access Entry:\t" access-list $ACL extended permit $PROTO $SRCADDR 255.255.255.0 $DSTADDR 255.255.255.0 eq $DSTPORT
    #echo
  if [[ $ACL =~ "inside_acl" ]]
   then
    if [ $DSTPORT == $PREVPORT ]
      then
        declare DSTOBJ_$PROTO$DSTPORT="DSTOBJ_$PROTO$DSTPORT $DSTADDR"
        CURRENTDSTOBJ="DSTOBJ_$PROTO$DSTPORT"
        echo "DSTPORT  is $DSTPORT"
        echo "PREVPORT is $PREVPORT"
        echo "$CURRENTDSTOBJ is ${!CURRENTDSTOBJ}"
        echo "DSTOBJS is $DSTOBJS"
        echo -e "network-object $DSTADDR 255.255.255.0" >> inside_OBJs/DSTOBJin_$PROTO$DSTPORT.txt.tmp
      else
        echo -e "object-group network DSTOBJin_$PROTO$DSTPORT" >> inside_OBJs/DSTOBJin_$PROTO$DSTPORT.txt.tmp
        echo -e "description destination networks for inside_acl $PROTO port $DSTPORT" >> inside_OBJs/DSTOBJin_$PROTO$DSTPORT.txt.tmp
        echo -e "network-object $DSTADDR 255.255.255.0" >> inside_OBJs/DSTOBJin_$PROTO$DSTPORT.txt.tmp
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
        echo -e "network-object $DSTADDR 255.255.255.0" >> outside_OBJs/DSTOBJout_$PROTO$DSTPORT.txt.tmp
      else
        echo -e "object-group network DSTOBJout_$PROTO$DSTPORT" >> outside_OBJs/DSTOBJout_$PROTO$DSTPORT.txt.tmp
        echo -e "description destination networks for outside_acl $PROTO port $DSTPORT" >> outside_OBJs/DSTOBJout_$PROTO$DSTPORT.txt.tmp
        echo -e "network-object $DSTADDR 255.255.255.0" >> outside_OBJs/DSTOBJout_$PROTO$DSTPORT.txt.tmp
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

sed -i 's/network-object/\ network-object/' *_OBJs/*.txt
sed -i 's/description/\ description/' *_OBJs/*.txt
