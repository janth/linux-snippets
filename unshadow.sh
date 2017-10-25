#!/bin/bash

sudo bash -c 'join -t: <(sort -t: -k1,1 /etc/shadow) <(sort -t: -k1,1 /etc/passwd)' | cut -d: -f1,2,11- 
