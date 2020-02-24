#!/bin/bash
sed -i 's/eq domain/eq 53/g' $1
sed -i 's/eq ftp/eq 21/g' $1
sed -i 's/eq https/eq 443/g' $1
sed -i 's/eq kerberos/750/g' $1
sed -i 's/eq ldap/eq 389/g' $1
sed -i 's/eq ldaps/eq 636/g' $1
sed -i 's/eq lpd/eq 515/g' $1
sed -i 's/eq netbios-ns/eq 137/g' $1
sed -i 's/eq netbios-dgm/eq 138/g' $1
sed -i 's/eq netbios-ssn/eq 139/g' $1
sed -i 's/eq ntp/eq 123/g' $1
sed -i 's/eq smtp/eq 25/g' $1
sed -i 's/eq snmp/eq 161/g' $1
sed -i 's/eq sqlnet/eq 1521/g' $1
sed -i 's/eq ssh/eq 22/g' $1
sed -i 's/eq syslog/eq 514/g' $1
sed -i 's/eq www/eq 80/g' $1

 
