#!/bin/bash

# This script looks at the log entries for "inbound" traffic
# "inbound" in this case is from the outside to the inside

# Example filtered log input:
#
# inbound     outside     172.21.5.169     62572     inside     10.105.104.147     389
#    ^           ^             ^             ^          ^             ^             ^
# direction   src_int       src_ip       src_port    dst_int       dst_ip        dst_port
#


