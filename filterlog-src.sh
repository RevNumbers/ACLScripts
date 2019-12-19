#!/bin/bash
# Create a function that will do EXTREMELY basic /24 subnetting
# Modified so it's a little easier to read/understand and handles the src port being left in

#function subnet {
#while read line
#  do
#   newline="$(echo -n $(echo $line | grep -oE '^[[:digit:]]{1,6}[[:blank:]][[:alpha:]]{6,7}_acl[[:blank:]][[:alpha:]]{3}[[:blank:]][[:alpha:]]{6,7}\/[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.'))"
#   newline="$newline$(echo -n "0 ")"
#   newline="$newline $(echo $line | awk '{print $5,$6}')"
#   port="$(echo $newline | awk '{print $NF}')"
#   secondoctet=$(echo $newline | awk -F"/" '{print $3}' | grep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
#   newnewline="$(echo $newline | awk -F"/" '{print $1"/"$2"/"}')$secondoctet"
#   newnewline="$(echo $newnewline)0 $port"
#   echo $newnewline   
#done < $1
#}

function subnet {
# High Source Port
HSRCPORT=$2
# High Destination Port
HDSTPORT=$3

while read line
 do
  SACLNAME=$(echo $line | awk '{print $2}')
  SPROTOCOL=$(echo $line | awk '{print $3}')
  SSRCINT=$(echo $line | awk '{print $4}' | awk -F"/" '{print $1}')
  SSRCIP=$(echo $line | awk '{print $4}' | awk -F"/" '{print $2}')
  SSRCPORT=$(echo $line | awk '{print $5}')
  SDSTINT=$(echo $line | awk '{print $6}' | awk -F"/" '{print $1}')
  SDSTIP=$(echo $line | awk '{print $6}' | awk -F"/" '{print $2}')
  SDSTPORT=$(echo $line | awk '{print $7}')
  SSRCSUBNETT=$(echo $SSRCIP | egrep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
  SSRCSUBNET=$(echo $SSRCSUBNETT$(echo "0"))
  SDSTSUBNETT=$(echo $SDSTIP | egrep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
  SDSTSUBNET=$(echo $SDSTSUBNETT$(echo "0"))
  if [ $SSRCPORT -le $HSRCPORT ] || [ $SDSTPORT -le $HDSTPORT ]
    then
      echo "$SACLNAME $SPROTOCOL $SSRCINT $SSRCSUBNET $SSRCPORT $SDSTINT $SDSTSUBNET $SDSTPORT"
  fi
done < $1
}


# Set some variables
INFILE=$(echo $1 | awk -F"." '{print $1}')
OUTFILE=$INFILE-filtered
OUTFILET=$OUTFILE-temp
INFILELINECOUNT=$(cat $1 | wc -l)
ACLFILE=$INFILE-ACLs

echo "Filtering the log for ACL hits..."
cat $1 | grep "ASA-6-106100" > $ACLFILE

# Below are the fields in the orginal file:
# Example line:		Dec  7 22:59:59 VAL-CISCO-5525-P1 : %ASA-6-106100: access-list outside_acl permitted tcp outside/10.0.4.146(54201) -> inside/10.105.104.66(52311) hit-cnt 1 first hit [0xcbdec20f, 0x0196c5de]
# 1	Month			"Dec"
# 2	Day			"7"
# 3	Timestamp		"22:59:59"
# 4	Device			"VAL-CISCO-5525-P1"
# 5	A colon...		":"
# 6	MessageID		"%ASA-6-106100:"
# 7	access-list		"access-list"
# 8	ACL name		"outside_acl"
# 9	what it did		"permitted"
# 10	protocol		"tcp"
# 11	src interface/IP(port)	"outside/10.0.4.146(54201)
# 12	direction arrow		"->"
# 13	dst interface/IP(port)	"inside/10.105.104.66(52311)
# 14	hit-cnt			"hit-cnt"
# 15	hit-cnt count		"1"
# 16	first			"first"
# 17	hit			"hit"
# 18	hex identifier		"[0xcbdec20f,"
# 19	hex identifier		"0x0196c5de]"

echo "Filtering the log for fields we care about..."
echo "Sample output:"
head -1 $ACLFILE | awk '{print $8 " " $10 " " $11 " " $13}'
cat $ACLFILE | awk '{print $8 " " $10 " " $11 " " $13}' > $OUTFILET.txt.tmp

# Below are the fields in the current file:
# Example line: outside_acl tcp outside/10.0.4.146(54201) inside/10.105.104.66(52311)
# 1	ACL name                "outside_acl"
# 2	protocol                "tcp"
# 3	src interface/IP(port)  "outside/10.0.4.146(54201)
# 4	dst interface/IP(port)  "inside/10.105.104.66(52311)

echo "Removing all but TCP/UDP traffic..."
cat $OUTFILET.txt.tmp | egrep 'tcp|udp' > $OUTFILET.txt

echo "Removing extraneous characters..."
echo "Sample output:"
head -1 $OUTFILET.txt | awk -F"(" '{print $1 " " $2 " " $3}' | sed 's/)//g'
cat $OUTFILET.txt | awk -F"(" '{print $1 " " $2 " " $3}' | sed 's/)//g' > $OUTFILE-temp2.txt

# Below are the fields in the current file:
# Example line:  outside_acl tcp outside/10.0.4.146 54201 inside/10.105.104.66 52311
# 1     ACL name                "outside_acl"
# 2     protocol                "tcp"
# 3     src interface/IP	"outside/10.0.4.146"
# 4	src port		"54201"
# 5     dst interface/IP	"inside/10.105.104.66"
# 6	dst port		"52311"



##########################################################
##	Removed section where src port was stripped	##
##########################################################


cp $OUTFILE-temp2.txt $OUTFILE.txt
echo "Splitting the large file into smaller ones in case we need them..."
mkdir $INFILE-split
cd $INFILE-split
split -d -a 1 -l 1048500 --additional-suffix=.txt ../$OUTFILE.txt $OUTFILE-
cd ..

echo "Sorting..."
cat $OUTFILE.txt | sort > $OUTFILE-sorted.txt

echo "Checking for uniqueness..."
cat $OUTFILE-sorted.txt | uniq -c > $OUTFILE-sorted-uniq.txt

echo "Resorting the unique results..."
cat $OUTFILE-sorted-uniq.txt | sort -n > $OUTFILE-sorted-uniq-sorted.txt

echo "Cleaning up the mess we made..."
rm $OUTFILE-temp*
rm $OUTFILE-sorted.txt
rm $OUTFILE-sorted-uniq.txt
rm $OUTFILE.txt
rm $INFILE-ACLs
mv $OUTFILE-sorted-uniq-sorted.txt $OUTFILE.txt
OUTFILELINECOUNT=$(cat $OUTFILE.txt | wc -l)
echo "Done!"
echo -e "\nOriginal file contained $INFILELINECOUNT lines"
echo "Filtered and sorted we got it down to $OUTFILELINECOUNT lines"  
echo
echo

# Below are the fields in the current file:
# Example line:        1 outside_acl tcp outside/10.0.4.146 54201 inside/10.105.104.66 52311
# 1	Number of hits/lines	"1"
# 2     ACL name                "outside_acl"
# 3     protocol                "tcp"
# 4     src interface/IP	"outside/10.0.4.146"
# 5	src port		"54201"
# 6     dst interface/IP	"inside/10.105.104.66"
# 7	dst port		"52311"




# High Source Port
HIGHSRC=10000
# High Destination Port
HIGHDST=10000
echo "Doing some basic subnetting and removing lines"
echo "with source ports higher than $HSRCPORT and"
echo "destination ports higher than $HDSTPORT"
# I don't remember why I'm excluding lines that begin is a 0... so I'll leave this here
  #subnet $OUTFILE.txt | grep -v "^0" | awk '{print $2,$3,$4,$5,$6}' > $OUTFILE-subnets.txt

subnet $OUTFILE.txt $HIGHSRC $HIGHDST> $OUTFILE-subnets.txt

# Sort and add a hit count
cat $OUTFILE-subnets.txt | sort | uniq -c | sort -n > $OUTFILE-subnets-count.txt

# Remove anything with a hitcount less than the Subnetted HIT COUNT variable (SHITCOUNT)
while read line
  do
   # Get the Subnetted Hit Count
   SHITCOUNT=$(echo $line | awk '{print $1}')
   if [ $SHITCOUNT -ge 5 ]
     then
       echo $line >> $OUTFILE-subnets-count2.txt
   fi
done < $OUTFILE-subnets-count.txt


# Need to fix this to work with source ports... and make it a little more simple
#echo "Sorting and removing lines with high port numbers..."
#cat $OUTFILE-subnets-count2.txt | sort | uniq > $OUTFILE-subnets-sort-uniq.txt
#cat $OUTFILE-subnets-sort-uniq.txt | grep -vE '\.0[[:blank:]][123456][[:digit:]][[:digit:]][[:digit:]][[:digit:]]$' > $OUTFILE-subnets-sort-uniq-nohigh.txt
#cat $OUTFILE-subnets-sort-uniq-nohigh.txt | grep -vE '\.0[[:blank:]][456789][[:digit:]][[:digit:]][[:digit:]]$' > $OUTFILE-subnets-sort-uniq-nohigh2.txt
#cat $OUTFILE-subnets-sort-uniq-nohigh2.txt | sed 's/\//\ /g' | awk '{print $2,$3,$4,$5,$6,$7,$8}' > $OUTFILE-forExcelImport.txt

##########################################################
##      Removing high port number matches moved to	##
##			Subnet function			##
##########################################################

cp $OUTFILE-subnets-count2.txt $OUTFILE-forExcelImport.txt

echo
echo
echo "Please import $OUTFILE-forExcelImport.txt into excel, source by inside/outside, then tcp/udp, then port number".
echo "Once complete bring it back over here and we'll run some more scripts on it..."
echo "Done."
