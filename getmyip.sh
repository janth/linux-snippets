#!/bin/bash

cat << X

dig +short myip.opendns.com @resolver1.opendns.com

wget -qO- http://ipecho.net/plain | xargs echo
wget -qO - icanhazip.com

curl ifconfig.co
curl ifconfig.me
curl icanhazip.com

X
