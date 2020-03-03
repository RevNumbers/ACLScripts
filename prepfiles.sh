#!/bin/bash

# Original commands that only grab "real" Src/Dst, not useful for outbound
#grep 'ASA-6-302013' VAL-CISCO-5525-P1 | awk '{print $8,$13,$16}' | awk -F":" '{print $1,$2,$3}' | awk -F"/" '{print $1,$2,$3" tcp"}' > VAL-CISCO-5525-P1-inout
#grep 'ASA-6-302015' VAL-CISCO-5525-P1 | awk '{print $8,$13,$16}' | awk -F":" '{print $1,$2,$3}' | awk -F"/" '{print $1,$2,$3" udp"}' >> VAL-CISCO-5525-P1-inout

# Had to modify slightly to use the NAT'd Src/Dst for inbound traffic
# This grabs both real and NAT'd colums, then we filter it out a little later
grep 'ASA-6-302013' VAL-CISCO-5525-P1 | awk '{print $8,$13,$14,$16,$17}' | awk -F":" '{print $1,$2,$3}' | awk -F"/" '{print $1,$2,$3,$4,$5" tcp"}' | sed 's/[(]//g' | sed 's/[)]//g' > VAL-CISCO-5525-P1-inout
grep 'ASA-6-302015' VAL-CISCO-5525-P1 | awk '{print $8,$13,$14,$16,$17}' | awk -F":" '{print $1,$2,$3}' | awk -F"/" '{print $1,$2,$3,$4,$5" tcp"}' | sed 's/[(]//g' | sed 's/[)]//g' >> VAL-CISCO-5525-P1-inout


# Put outbound and inbound in their own files
# Also only use "real" Src/Dst for outbound
# Use NAT'd Src/Dst for inbound
grep ^outbound VAL-CISCO-5525-P1-inout | awk '{print $1,$2,$3,$4,$7,$8,$9,$12}' > VAL-CISCO-5525-P1-outbound
grep ^inbound VAL-CISCO-5525-P1-inout | awk '{print $1,$2,$5,$6,$7,$10,$11,$12}' > VAL-CISCO-5525-P1-inbound

# Sort it all
sort VAL-CISCO-5525-P1-outbound -o VAL-CISCO-5525-P1-outbound-sorted
sort VAL-CISCO-5525-P1-inbound -o VAL-CISCO-5525-P1-inbound-sorted

# Make sure it's uniq
uniq VAL-CISCO-5525-P1-outbound-sorted VAL-CISCO-5525-P1-outbound-sorted-uniq
uniq VAL-CISCO-5525-P1-inbound-sorted VAL-CISCO-5525-P1-inbound-sorted-uniq
