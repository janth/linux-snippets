#!/bin/bash

echo curl -s icanhazip.com
curl -s icanhazip.com

echo wget -q -O - icanhazip.com
wget -q -O - icanhazip.com

# https://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-a-shell-script
# https://raw.githubusercontent.com/rsp/scripts/master/externalip-benchmark

# https://www.iplocation.net/find-ip-address

set -x
dig @resolver1.opendns.com ANY myip.opendns.com +short
dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short
dig @ns1.google.com TXT o-o.myaddr.l.google.com +short
