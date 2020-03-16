#!/bin/bash
mkdir inside_acl_OBJ-ports 2>/dev/null

while read -r line
  do
    # The object group that matched
    MATCH="$(grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}')"
    # The port number and TCP/UDP
    MATCH2="$(echo $line | awk '{print $1,$6}')" 
    MATCH3="$(grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1)" # | awk '{print $1}' | awk -F"/" '{print $2}')"
    grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}' >/dev/null || echo "$(echo $line | awk '{print $5}') HAS NO MATCH"

#    if test -z $MATCH
#      then
#        echo $line
#        echo "MATCH   == $MATCH"
#        echo "MATCH2  == $MATCH2"
#        echo "MATCH3  == $MATCH3"
#    fi
#    if [[ ! $(echo $line | awk '{print $5}') =~ $(echo $MATCH3 | awk '{print $4}') ]]
#      then
#       echo $line
#       echo "MATCH3  == $MATCH3"
#       echo "MATCH   == $MATCH"
#       echo "MATCH2  == $MATCH2"
#    fi

    # if it matched somethin, put it in the file, if not, do some other stuff 
    if test -z $MATCH 
    #elif test -z $MATCH 
      then
	#echo "Checking for a subnet match"
        CLASS24=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 "." $2 "." $3 ".0"}')
        CLASS16=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 "." $2 ".0.0"}')
        CLASS8=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 ".0.0.0"}')
        MATCHSUB24="$(grep -w $CLASS24 outbound_OBJs/* | head -1)"
	MATCHSUB16="$(grep -w $CLASS16 outbound_OBJs/* | head -1)"
	MATCHSUB8="$(grep -w $CLASS8 outbound_OBJs/* | head -1)"
	  if [[ $(echo $MATCHSUB24 | awk '{print $4}') =~ "255.255.255.0" ]]
	    then
#	      echo "$(echo $line | awk '{print $5}') Matched a class 24"
	      echo $MATCH2 >> inside_acl_OBJ-ports/$(echo $MATCHSUB24 | awk '{print $1}' | awk -F"/" '{print $2}' | awk -F":" '{print $1}')
	    elif [[ $(echo $MATCHSUB16 | awk '{print $4}') =~ "255.255.0.0" ]]
	      then
#	        echo "$(echo $line | awk '{print $5}') Matched a class 16"
 	        echo $MATCH2 >> inside_acl_OBJ-ports/$(echo $MATCHSUB16 | awk '{print $1}' | awk -F"/" '{print $2}' | awk -F":" '{print $1}')
	    elif [[ $(echo $MATCHSUB8 | awk '{print $4}') =~ "255.0.0.0" ]]
              then
#		echo "$(echo $line | awk '{print $5}') Matched a class 8"
		echo $MATCH2 >> inside_acl_OBJ-ports/$(echo $MATCHSUB8 | awk '{print $1}' | awk -F"/" '{print $2}' | awk -F":" '{print $1}')
		#echo "Would normally be put in inside_acl_OBJ-ports/$(echo $MATCHSUB8 | awk '{print $1}' | awk -F"/" '{print $2}' | awk -F":" '{print $1}')"
            else
	        echo "$(echo $line | awk '{print $5}') HAS NO MATCH"
          fi
#        echo "CLASS24    == $CLASS24"
#        echo "MATCHSUB24 == $MATCHSUB24"
#        echo "CLASS16    == $CLASS16"
#        echo "MATCHSUB16 == $MATCHSUB16"
#        echo "CLASS8     == $CLASS8"
#        echo "MATCHSUB8  == $MATCHSUB8"
      else
#	echo "$(echo $line | awk '{print $5}') Matched a host"
        #echo $MATCH2 will be in inside_acl_OBJ-ports/$(echo $MATCH3 | awk -F"/" '{print $2}' | awk -F":" '{print $1}')
        echo $MATCH2 >> inside_acl_OBJ-ports/$(echo $MATCH3| awk -F"/" '{print $2}' | awk -F":" '{print $1}')
#	echo
   fi
    #echo $MATCH
    #echo $MATCH2

done < $1
