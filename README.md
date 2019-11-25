# ACLScripts
### Step 1
`filterlog-all.sh <original unfiltered unsorted syslog file>`  
This filters the log and create a bunch of other files, one of which we care about:

### Step 2
import the `<DeviceName>-filtered-forExcelImport.txt` file into Excel  
Once imported, use Excel to sort by inside/outside, then by tcp/udp, then by port  
That should be Column1, Column2, then Column7.

### Step 3
copy the sorted data into a file (on this box) named `<DeviceName>-fromExcel.txt`  
Make sure there is no blank line at the end of the file.

### Step 4
`create_OBJs.sh <DeviceName>-fromExcel.txt`  
That will create all the objects/object-groups needed for the ACLs.

### Step 5
copy the previous ACL list to `existingACL.txt`  

The `createACL.sh` script will search this file for existing ACL entries and only  
print new entries.  The object entries will remain, so we can add to them.

### Step 6
`createACL.sh`  
the above scripts outputs to the screen all of the objects, and the lines to add to the ACLs.  

this can be redirected to a file to make it easier:  
`createACL.sh > full_acl_output.txt`
