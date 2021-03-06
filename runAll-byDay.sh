#!/bin/bash
for i in *
  do
    cd $i
	echo "Running scripts against logs for $(date +"%B %d, %Y" -d $(echo $i | cut -c 35-))"
	echo "Running prepfiles.sh in $PWD"
	./prepfiles.sh
	echo "Running outbound_filter in $PWD"
	./outbound_filter-nosubnet.sh VAL-CISCO-5525-P1-outbound-sorted-uniq
	echo "Running inbound_filter in $PWD"
	./inbound_filter-nosubnet.sh VAL-CISCO-5525-P1-inbound-sorted-uniq
	echo "Running find_objects_outbound.sh in $PWD"
	./find_objects_outbound.sh outbound_traffic-sorted-uniq.txt
	echo "Running find_objects_inbound.sh in $PWD"
	./find_objects_inbound.sh inbound_traffic-sorted-uniq.txt
        echo "Finished parsing logs for $(date +"%B %d, %Y" -d $(echo $i | cut -c 35-))"
	echo
	cd ..
done
