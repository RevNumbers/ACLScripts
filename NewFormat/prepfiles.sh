#!/bin/bash
#grep 'ASA-6-302013' VAL-CISCO-5525-P1 | awk '{print $8,$13,$16}' | awk -F":" '{print $1,$2,$3}' | awk -F"/" '{print $1,$2,$3" tcp"}' > VAL-CISCO-5525-P1-inout
#grep 'ASA-6-302015' VAL-CISCO-5525-P1 | awk '{print $8,$13,$16}' | awk -F":" '{print $1,$2,$3}' | awk -F"/" '{print $1,$2,$3" udp"}' >> VAL-CISCO-5525-P1-inout

grep ^outbound VAL-CISCO-5525-P1-inout > VAL-CISCO-5525-P1-outbound
grep ^inbound VAL-CISCO-5525-P1-inout > VAL-CISCO-5525-P1-inbound

sort VAL-CISCO-5525-P1-outbound -o VAL-CISCO-5525-P1-outbound-sorted
sort VAL-CISCO-5525-P1-inbound -o VAL-CISCO-5525-P1-inbound-sorted

uniq VAL-CISCO-5525-P1-outbound-sorted VAL-CISCO-5525-P1-outbound-sorted-uniq
uniq VAL-CISCO-5525-P1-inbound-sorted VAL-CISCO-5525-P1-inbound-sorted-uniq
