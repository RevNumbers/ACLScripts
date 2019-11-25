#!/bin/bash

echo -e "! Objects associated with the inside_acl ACL"

cat inside_OBJs/*

echo
echo -e "! Objects associated with the outside_acl ACL"

cat outside_OBJs/*

echo
echo -e "! inside_acl Additions"

for i in $(ls -1 inside_OBJs/DST* | awk -F"/" '{print $2}')
  do
    DSTOBJECTNAME=$(echo $i | awk -F"." '{print $1}')
    SRCOBJECTNAME=$(echo $DSTOBJECTNAME | sed 's/DST/SRC/g')
    PROTOCOL=$(echo $DSTOBJECTNAME | awk -F"_" '{print $2}' | cut -c 1-3)
    PORT=$(echo $DSTOBJECTNAME | awk -F"_" '{print $2}' | cut -c 4-7)
    ACLENTRY=$(echo "access-list inside_acl extended permit $PROTOCOL object-group $SRCOBJECTNAME object-group $DSTOBJECTNAME eq $PORT")
    EXISTINGACL=$(grep "$ACLENTRY" existingACL.txt >/dev/null 2>&1 && echo 1 || echo 0)
    if [ $EXISTINGACL -ne 1 ]
      then
        echo $ACLENTRY
    fi
done

echo
echo -e "! outside_acl Additions"

for o in $(ls -1 outside_OBJs/DST* | awk -F"/" '{print $2}')
  do
    DSTOBJECTNAME=$(echo $o | awk -F"." '{print $1}')
    SRCOBJECTNAME=$(echo $DSTOBJECTNAME | sed 's/DST/SRC/g')
    PROTOCOL=$(echo $DSTOBJECTNAME | awk -F"_" '{print $2}' | cut -c 1-3)
    PORT=$(echo $DSTOBJECTNAME | awk -F"_" '{print $2}' | cut -c 4-7)
    ACLENTRY=$(echo "access-list outside_acl extended permit $PROTOCOL object-group $SRCOBJECTNAME object-group $DSTOBJECTNAME eq $PORT")
    EXISTINGACL=$(grep "$ACLENTRY" existingACL.txt >/dev/null 2>&1 && echo 1 || echo 0)
    if [ $EXISTINGACL -ne 1 ]
      then
        echo $ACLENTRY
    fi
done
