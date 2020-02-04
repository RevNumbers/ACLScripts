#!/bin/bash

# This script looks at the log entries for "outbound" traffic
# "outbound" in this case is from the inside to the outside

# Example filtered log input:
#
# outbound     outside     10.24.11.35     135     inside     10.105.104.10     52149
#    ^            ^             ^           ^        ^              ^             ^
# direction    dst_int       dst_ip     dst_port   src_int        src_ip       src_port


