#!/bin/bash
# Create a function that will do EXTREMELY basic /24 subnetting
function subnet {
while read line
  do
   newline="$(echo -n $(echo $line | grep -oE '^[[:digit:]]{1,6}[[:blank:]][[:alpha:]]{6,7}_acl[[:blank:]][[:alpha:]]{3}[[:blank:]][[:alpha:]]{6,7}\/[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.'))"
   newline="$newline$(echo -n "0 ")"
   newline="$newline $(echo $line | awk '{print $5,$6}')"
   port="$(echo $newline | awk '{print $NF}')"
   secondoctet=$(echo $newline | awk -F"/" '{print $3}' | grep -oE '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.')
   newnewline="$(echo $newline | awk -F"/" '{print $1"/"$2"/"}')$secondoctet"
   newnewline="$(echo $newnewline)0 $port"
   echo $newnewline   
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

echo "Filtering the log for fields we care about..."
echo "Sample output:"
head -1 $ACLFILE | awk '{print $8 " " $10 " " $11 " " $13}'
cat $ACLFILE | awk '{print $8 " " $10 " " $11 " " $13}' > $OUTFILET.txt.tmp

echo "Removing all but TCP/UDP traffic..."
cat $OUTFILET.txt.tmp | egrep 'tcp|udp' > $OUTFILET.txt

echo "Removing extraneous characters..."
echo "Sample output:"
head -1 $OUTFILET.txt | awk -F"(" '{print $1 " " $2 " " $3}' | sed 's/)//g'
cat $OUTFILET.txt | awk -F"(" '{print $1 " " $2 " " $3}' | sed 's/)//g' > $OUTFILE-temp2.txt

echo "Re-Filtering so it looks pretty..."
echo "Sample output:"
head -1 $OUTFILE-temp2.txt | awk '{print $1 " " $2 " " $3 " " $5 " " $6}'
#head -1 $OUTFILE-temp2.txt | awk '{print $1 " " $2 " " $3 " " $5 " " $6}' | sed 's/\//\ /g'
cat $OUTFILE-temp2.txt | awk '{print $1 " " $2 " " $3 " " $5 " " $6}' > $OUTFILE.txt
#cat $OUTFILE-temp2.txt | awk '{print $1 " " $2 " " $3 " " $5 " " $6}' | sed 's/\//\ /g' > $OUTFILE.txt

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
echo "Doing some basic subnetting..."
subnet $OUTFILE.txt | grep -v "^0" | awk '{print $2,$3,$4,$5,$6}' > $OUTFILE-subnets.txt
cat $OUTFILE-subnets.txt | sort | uniq -c | sort -n > $OUTFILE-subnets-count.txt
while read line
  do
   # Get the Subnetted Hit Count
   SHITCOUNT=$(echo $line | awk '{print $1}')
   if [ $SHITCOUNT -ge 5 ]
     then
       echo $line >> $OUTFILE-subnets-count2.txt
   fi
done < $OUTFILE-subnets-count.txt

echo "Sorting and removing lines with high port numbers..."
cat $OUTFILE-subnets-count2.txt | sort | uniq > $OUTFILE-subnets-sort-uniq.txt
cat $OUTFILE-subnets-sort-uniq.txt | grep -vE '\.0[[:blank:]][123456][[:digit:]][[:digit:]][[:digit:]][[:digit:]]$' > $OUTFILE-subnets-sort-uniq-nohigh.txt
cat $OUTFILE-subnets-sort-uniq-nohigh.txt | grep -vE '\.0[[:blank:]][456789][[:digit:]][[:digit:]][[:digit:]]$' > $OUTFILE-subnets-sort-uniq-nohigh2.txt
echo "Done."
