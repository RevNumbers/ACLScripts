#!/bin/bash
mkdir inside_acl_OBJ-ports 2>/dev/null
echo "================================================"

# Function for matching the source IP to an Object
function source_match
{
    # Set a variable... we like variables
    SHOST=$(echo $line | awk '{print $3}')
        #echo "Checking for a subnet match"
        CLASS24=$(echo $line | awk '{print $3}' | awk -F"." '{print $1 "." $2 "." $3 ".0"}')
        CLASS23o3=$(echo $line | awk '{print $3}' | awk -F"." '{print $3}')
        CLASS23=$(echo $(echo $line | awk '{print $3}' | awk -F"." '{print $1 "." $2 "."}')$(if [ $((CLASS23o3%2)) -eq 0 ]; then echo $CLASS23o3; else echo $(($CLASS23o3-1)).0; fi))
        CLASS16=$(echo $line | awk '{print $3}' | awk -F"." '{print $1 "." $2 ".0.0"}')
	CLASS12=$(echo $line | awk '{print $3}' | awk -F"." '{print $1 ".16.0.0"}')
        CLASS8=$(echo $line | awk '{print $3}' | awk -F"." '{print $1 ".0.0.0"}')
        SMATCHSUB24="$(grep -w $CLASS24 outbound_OBJs_src/* | head -1)"
        SMATCHSUB24A=($(grep -w $CLASS24 outbound_OBJs_src/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        SMATCHSUB23="$(grep -w $CLASS23 outbound_OBJs_src/* | head -1)"
        SMATCHSUB23A=($(grep -w $CLASS23 outbound_OBJs_src/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        SMATCHSUB16="$(grep -w $CLASS16 outbound_OBJs_src/* | head -1)"
        SMATCHSUB16A=($(grep -w $CLASS16 outbound_OBJs_src/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        SMATCHSUB12="$(grep -w $CLASS12 outbound_OBJs_src/* | head -1)"
        SMATCHSUB12A=($(grep -w $CLASS12 outbound_OBJs_src/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        SMATCHSUB8="$(grep -w $CLASS8 outbound_OBJs_src/* | head -1)"
        SMATCHSUB8A=($(grep -w $CLASS8 outbound_OBJs_src/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
		
        if test -n ${SMATCHSUB24A[0]}
          then
	    unset SMATCH24ARR
            for file in ${SMATCHSUB24A[@]}
              do
		if [[ $(grep -w $CLASS24 outbound_OBJs_src/$file | awk '{print $3}') =~ "255.255.255.0" ]]
		  then
                    SMATCH24ARR+=($file)
		fi
            done
        fi
        if test -n ${SMATCHSUB23A[0]}
          then
	    unset SMATCH23ARR
            for file in ${SMATCHSUB23A[@]}
              do
		if [[ $(grep -w $CLASS23 outbound_OBJs_src/$file | awk '{print $3}') =~ "255.255.254.0" ]]
		  then
                    SMATCH23ARR+=($file)
		fi
            done
        fi
        if test -n ${SMATCHSUB16A[0]}
          then
	    unset SMATCH16ARR
            for file in ${SMATCHSUB16A[@]}
              do
		if [[ $(grep -w $CLASS16 outbound_OBJs_src/$file | awk '{print $3}') =~ "255.255.0.0" ]]
		  then
                    SMATCH16ARR+=($file)
		fi
            done
        fi
        if test -n ${SMATCHSUB12A[0]}
          then
	    unset SMATCH12ARR
            for file in ${SMATCHSUB12A[@]}
              do
		if [[ $(grep -w $CLASS12 outbound_OBJs_src/$file | awk '{print $3}') =~ "255.240.0.0" ]]
		  then
                    SMATCH12ARR+=($file)
		fi
            done
        fi
        if test -n ${SMATCHSUB8A[0]}
          then
	    unset SMATCH8ARR
            for file in ${SMATCHSUB8A[@]}
              do
		if [[ $(grep -w $CLASS8 outbound_OBJs_src/$file | awk '{print $3}') =~ "255.0.0.0" ]]
		  then
                    SMATCH8ARR+=($file)
		fi
            done
        fi

    if test -n $SMATCH
      then
#        echo "Source address $(echo $line | awk '{print $3}') Matched a host"
        SMATCHHA=($(grep -w $(echo $line | awk '{print $3}') outbound_OBJs_src/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
#        echo $SMATCH3 | awk -F"/" '{print $2}' | awk -F":" '{print $1}'
   fi
SMATCHARR=(${SMATCH8ARR[@]} ${SMATCH12ARR[@]} ${SMATCH16ARR[@]} ${SMATCH23ARR[@]} ${SMATCH24ARR[@]} ${SMATCHHA[@]})

}

# Function for matching the destination IP to an Object
function destination_match
{
    # Set a variable... we like variables
    DHOST=$(echo $line | awk '{print $5}')
        #echo "Checking for a subnet match"
        CLASS24=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 "." $2 "." $3 ".0"}')
        CLASS23o3=$(echo $line | awk '{print $5}' | awk -F"." '{print $3}')
        CLASS23=$(echo $(echo $line | awk '{print $5}' | awk -F"." '{print $1 "." $2 "."}')$(if [ $((CLASS23o3%2)) -eq 0 ]; then echo $CLASS23o3; else echo $(($CLASS23o3-1)).0; fi))
        CLASS16=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 "." $2 ".0.0"}')
        CLASS12=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 ".16.0.0"}')
        CLASS8=$(echo $line | awk '{print $5}' | awk -F"." '{print $1 ".0.0.0"}')
        DMATCHSUB24="$(grep -w $CLASS24 outbound_OBJs/* | head -1)"
        DMATCHSUB24A=($(grep -w $CLASS24 outbound_OBJs/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        DMATCHSUB23="$(grep -w $CLASS23 outbound_OBJs/* | head -1)"
        DMATCHSUB23A=($(grep -w $CLASS23 outbound_OBJs/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        DMATCHSUB16="$(grep -w $CLASS16 outbound_OBJs/* | head -1)"
        DMATCHSUB16A=($(grep -w $CLASS16 outbound_OBJs/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        DMATCHSUB12="$(grep -w $CLASS12 outbound_OBJs/* | head -1)"
        DMATCHSUB12A=($(grep -w $CLASS12 outbound_OBJs/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
        DMATCHSUB8="$(grep -w $CLASS8 outbound_OBJs/* | head -1)"
        DMATCHSUB8A=($(grep -w $CLASS8 outbound_OBJs/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))

        if test -n ${DMATCHSUB24A[0]}
          then
            unset DMATCH8ARR
            for file in ${DMATCHSUB24A[@]}
              do
                if [[ $(grep -w $CLASS24 outbound_OBJs/$file | awk '{print $3}') =~ "255.255.255.0" ]]
                  then
                    DMATCH24ARR+=($file)
                fi
            done
        fi
        if test -n ${DMATCHSUB23A[0]}
          then
            unset DMATCH23ARR
            for file in ${DMATCHSUB23A[@]}
              do
                if [[ $(grep -w $CLASS23 outbound_OBJs/$file | awk '{print $3}') =~ "255.255.254.0" ]]
                  then
                    DMATCH23ARR+=($file)
                fi
            done
        fi
        if test -n ${DMATCHSUB16A[0]}
          then
            unset DMATCH16ARR
            for file in ${DMATCHSUB16A[@]}
              do
                if [[ $(grep -w $CLASS16 outbound_OBJs/$file | awk '{print $3}') =~ "255.255.0.0" ]]
                  then
                    DMATCH16ARR+=($file)
                fi
            done
        fi
        if test -n ${DMATCHSUB12A[0]}
          then
            unset DMATCH12ARR
            for file in ${DMATCHSUB12A[@]}
              do
                if [[ $(grep -w $CLASS12 outbound_OBJs/$file | awk '{print $3}') =~ "255.240.0.0" ]]
                  then
                    DMATCH12ARR+=($file)
                fi
            done
        fi
        if test -n ${DMATCHSUB8A[0]}
          then
            unset DMATCH8ARR
            for file in ${DMATCHSUB8A[@]}
              do
                if [[ $(grep -w $CLASS8 outbound_OBJs/$file | awk '{print $3}') =~ "255.0.0.0" ]]
                  then
                    DMATCH8ARR+=($file)
                fi
            done
        fi

    if test -n $DMATCH
      then
#        echo "destination address $(echo $line | awk '{print $5}') Matched a host"
        DMATCHHA=($(grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | awk -F"/" '{print $2}' | awk -F":" '{print $1}'))
#        echo $DMATCH3 | awk -F"/" '{print $2}' | awk -F":" '{print $1}'
   fi
DMATCHARR=(${DMATCH8ARR[@]} ${DMATCH12ARR[@]} ${DMATCH16ARR[@]} ${DMATCH23ARR[@]} ${DMATCH24ARR[@]} ${DMATCHHA[@]})

}

while read -r line
  do
    # The destination object group that matched
    DMATCH="$(grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}')"
    # The port number and TCP/UDP
    DMATCH2="$(echo $line | awk '{print $1,$6}')"
    DMATCH3="$(grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1)" # | awk '{print $1}' | awk -F"/" '{print $2}')"
    grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}' >/dev/null || echo "$(echo $line | awk '{print $5}') HAS NO DMATCH (line 200)"
    #Debugging
#    echo "DMATCH   == $DMATCH"
#    echo "DMATCH2  == $DMATCH2"
#    echo "DMATCH3  == $DMATCH3"


    # The source object group that matched
    SMATCH="$(grep -w $(echo $line | awk '{print $3}') outbound_OBJs_src/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}')"
    SMATCH3="$(grep -w $(echo $line | awk '{print $3}') outbound_OBJs_src/* | head -1)" # | awk '{print $1}' | awk -F"/" '{print $2}')"
    grep -w $(echo $line | awk '{print $5}') outbound_OBJs/* | head -1 | awk '{print $1}' | awk -F"/" '{print $2}' >/dev/null || echo "$(echo $line | awk '{print $5}') HAS NO SMATCH (line 210)"
    #Debugging
#    echo "SMATCH   == $SMATCH"
#    echo "SMATCH3  == $SMATCH3"
#    if test -z $DMATCH
#      then
#        echo $line
#        echo "DMATCH   == $DMATCH"
#        echo "DMATCH2  == $DMATCH2"
#        echo "DMATCH3  == $DMATCH3"
#    fi
#    if [[ ! $(echo $line | awk '{print $5}') =~ $(echo $DMATCH3 | awk '{print $4}') ]]
#      then
#       echo $line
#       echo "DMATCH3  == $DMATCH3"
#       echo "DMATCH   == $DMATCH"
#       echo "DMATCH2  == $DMATCH2"
#    fi


source_match
destination_match

#    echo $DMATCH
#    echo $DMATCH2
#     echo "================================================"
#     echo "SOURCE       ==  $SHOST"
#     echo "DESTINATION  ==  $DHOST"
#     echo "DMATCH8ARR   ==  ${DMATCH8ARR[@]}"
#     echo "DMATCH16ARR  ==  ${DMATCH16ARR[@]}"
#     echo "DMATCH24ARR  ==  ${DMATCH24ARR[@]}"
#     echo "DMATCHSUB8A  ==  ${DMATCHSUB8A[@]}"
#     echo "DMATCHSUB16A ==  ${DMATCHSUB16A[@]}"
#     echo "DMATCHSUB24A ==  ${DMATCHSUB24A[@]}"
#     echo "DMATCHHA     ==  ${DMATCHHA[@]}"
#     echo "SMATCH8ARR   ==  ${SMATCH8ARR[@]}"
#     echo "SMATCH12ARR  ==  ${SMATCH12ARR[@]}"
#     echo "SMATCH16ARR  ==  ${SMATCH16ARR[@]}"
#     echo "SMATCH23ARR  ==  ${SMATCH23ARR[@]}"
#     echo "SMATCH24ARR  ==  ${SMATCH24ARR[@]}"
#     echo "SMATCHSUB8A  ==  ${SMATCHSUB8A[@]}"
#     echo "SMATCHSUB16A ==  ${SMATCHSUB16A[@]}"
#     echo "SMATCHSUB24A ==  ${SMATCHSUB24A[@]}"
#     echo "SMATCHHA     ==  ${SMATCHHA[@]}"
#     echo "--------FINAL OBJECTS---------"
     echo "SOURCE         ==  $SHOST"
     echo "DESTINATION    ==  $DHOST"
     echo "TRAFFIC        ==  $DMATCH2"
     echo "Src OBJECTS    ==  ${SMATCHARR[@]}"	 
     echo "Dst OBJECTS    ==  ${DMATCHARR[@]}"	
     echo "------------------------------" 
#DSTOBJ=$(destination_match)
#SRCOBJ=$(source_match)
#SHOST=$(echo $line | awk '{print $3}')

#echo "Destination host is $DHOST"
#echo "Source matched $SRCOBJ"
#echo "Destination matched $DSTOBJ"
#MATCHED=0
#for dest in ${DMATCHHA[@]}
#  do
#    DESTOBJECT=$(echo $dest | cut -c 4-)
#    cat inside_acl | grep "object-group $SRCOBJ object-group $DESTOBJECT" && MATCHED=1
#done
#if [ $MATCHED -ne 1 ]
#  then
#    echo "$SRCOBJ ($SHOST) and $DESTOBJECT ($DHOST) DO NOT MATCH AN ACL ENTRY"
#fi
#OACLENTRY=$(cat inside_acl | grep "object-group $SRCOBJ object-group $DSTOBJ")
#HACLENTRY=$(cat inside_acl | grep "object-group $SRCOBJ host $DHOST")
#echo "OACLENTRY = $OACLENTRY"
#echo "HACLENTRY = $HACLENTRY"
unset ACLMATCH
unset NOMATCH
while read -r line
  do
    ACLBREAK=0
#    echo "looping through ACL..."
    for source in ${SMATCHARR[@]}
      do
#	echo "looping through sources..."
#	echo "source is $source"
	for destination in ${DMATCHARR[@]}
	  do
#	    echo "looping through destinations..."
#	    echo "destination is $destination"
	    unset ACLMATCH
	    unset NOMATCH 
	    ACLMATCH1=$(echo $line | grep "access-list inside_acl extended permit ip object-group $source")
#	    echo "ACLMATCH1 is $ACLMATCH1"
	    ACLMATCH2=$(echo $ACLMATCH1 | grep $destination)
#	    echo "ACLMATCH2 is $ACLMATCH2"
#	    echo "testing if ACLMATCH2 is null..."
	    if test -n "$ACLMATCH2"
	      then
		ACLMATCH=1
		NOMATCH=0
	      else
#		echo "checking if destination host matches"
		ACLMATCH2=$(echo $ACLMATCH1 | grep $DHOST)
	    fi
	    if test -n "$NOMATCH"
	      then
		echo "ACL ENTRY MATCHED  ==  $ACLMATCH2"
		ACLBREAK=1
            fi	    
	    if [ $ACLBREAK -eq 1 ]
	      then
	        break
	    fi
        done
        if [ $ACLBREAK -eq 1 ]
          then
            break
        fi
    done
    if [ $ACLBREAK -eq 1 ]
      then
        break
    fi
done < inside_acl
    if [ $ACLBREAK -eq 0 ]
      then
        echo "TRAFFIC DID NOT MATCH ACL"
      else
      ACLMATCHD=$(echo $ACLMATCH2 | awk '{print $NF}')
      if [[ "$ACLMATCHD" =~ "255" ]]
        then
          ACLMATCHD=$(echo $ACLMATCH2 | awk '{print $8}')
      fi
      echo "Adding \"service $(echo $DMATCH2 | awk '{print $1}') destination eq $(echo $DMATCH2 | awk '{print $2}')\" to outbound_service_OBJs/$(echo $ACLMATCHD)-ServiceOBJ"
      echo "service $(echo $DMATCH2 | awk '{print $1}') destination eq $(echo $DMATCH2 | awk '{print $2}')" >> outbound_service_OBJs/$(echo $ACLMATCHD)-ServiceOBJ
    fi
     echo "================================================"
done < $1
