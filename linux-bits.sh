#!/bin/bash

file --dereference /sbin/init | awk '{print $1, $3}'
#:echo "/sbin/init: $bits"

grep -q "flags.* lm " /proc/cpuinfo
if [[ $? -eq 0 ]] ; then
   echo "CPU is capable of 64-bits os (lm flag in /proc/cpuinfo)"
else
   echo "CPU is NOT capable of 64-bits os (no lm flag in /proc/cpuinfo)"
fi
