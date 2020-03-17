#!/bin/bash
mkdir outside_acl_OBJ-ports 2>/dev/null

while read -r line
  do
    # The object group that matched
    MATCH="$(grep $(echo $line | awk '{print $5}') inbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}')"
    # The port number and TCP/UDP
    MATCH2="$(echo $line | awk '{print $1,$6}')" 

    # if it matched somethin, put it in the file, if not, do some other stuff 
    if [ -n $MATCH ]
      then
        echo $MATCH2 >> outside_acl_OBJ-ports/$MATCH
      else
        CLASS24=$(echo $line | awk '{print $5}' | awk -F"." {print $1 "." $2 "." $3 ".0"})
        CLASS16=$(echo $line | awk '{print $5}' | awk -F"." {print $1 "." $2 ".0.0")
        CLASS8=$(echo $line | awk '{print $5}' | awk -F"." {print $1 ".0.0.0"})
        MATCHSUB24="$(grep $CLASS24 inbound_OBJs/* | head -1)"
	MATCHSUB16="$(grep $CLASS16 inbound_OBJs/* | head -1)"
	MATCHSUB8="$(grep $CLASS8 inbound_OBJs/* | head -1)"
	  if [[ $(echo $MATCHSUB24 | awk '{print $4}') =~ "255.255.255.0" ]]
	    then
	      echo $MATCH2 >> outside_acl_OBJ-ports/$(echo $MATCHSUB24 | awk '{print $1}' | awk -F"/" '{print $2}')
	    elif [[ $(echo $MATCHSUB16 | awk '{print $4}') =~ "255.255.0.0" ]]
	      then
 	        echo $MATCH2 >> outside_acl_OBJ-ports/$(echo $MATCHSUB16 | awk '{print $1}' | awk -F"/" '{print $2}')
	    elif [[ $(echo $MATCHSUB8 | awk '{print $4}') =~ "255.0.0.0" ]]
              then
		echo $MATCH2 >> outside_acl_OBJ-ports/$(echo $MATCHSUB8 | awk '{print $1}' | awk -F"/" '{print $2}')
          fi
   fi
    #echo $MATCH
    #echo $MATCH2

done < $1
