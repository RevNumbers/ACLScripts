#!/bin/bash
while read line
  do
    ORIGACL=$(echo $line | awk '{print $8}')
    PROTOCOL=$(echo $line | awk '{print $10}')
    ORIGSRC=$(echo $line | awk '{print $11}')
    ORIGDST=$(echo $line | awk '{print $13}')
    ORIGSRC_PORT=$(echo $ORIGSRC | awk -F"(" '{print $2}' | sed 's/)//g')
    ORIGDST_PORT=$(echo $ORIGDST | awk -F"(" '{print $2}' | sed 's/)//g')

    if [ $ORIGSRC_PORT -lt $ORIGDST_PORT ]
      then
        DESTINATION="$ORIGSRC"
        SOURCE="$ORIGDST"
      else
	SOURCE="$ORIGSRC"
	DESTINATION="$ORIGDST"
    fi
#    echo "SOURCE      = $SOURCE"
#    echo "DESTINATION = $DESTINATION"
    SRCINTF=$(echo $SOURCE | awk -F"/" '{print $1}')
    SRCIP=$(echo $SOURCE | awk -F"/" '{print $2}' | awk -F"(" '{print $1}')
    SRCPORT=$(echo $SOURCE | awk -F"(" '{print $2}' | sed 's/)//g')    
    DSTINTF=$(echo $DESTINATION | awk -F"/" '{print $1}')
    DSTIP=$(echo $DESTINATION | awk -F"/" '{print $2}' | awk -F"(" '{print $1}')
    DSTPORT=$(echo $DESTINATION | awk -F"(" '{print $2}' | sed 's/)//g')
    ACLNAME=$(echo -n $SRCINTF; echo _acl)

    SRCSUBNETT=$(echo $SRCIP | egrep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
    SRCSUBNET=$(echo $SRCSUBNETT$(echo "0"))
    DSTSUBNETT=$(echo $DSTIP | egrep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
    DSTSUBNET=$(echo $DSTSUBNETT$(echo "0"))

    echo "access-list $ACLNAME permit $PROTOCOL $SRCSUBNET 255.255.255.0 $DSTSUBNET 255.255.255.0 eq $DSTPORT"
done < $1
