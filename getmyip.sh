#!/bin/bash

cat << X

dig +short myip.opendns.com @resolver1.opendns.com

wget -qO- http://ipecho.net/plain | xargs echo
wget -qO - icanhazip.com

curl ifconfig.co
curl ifconfig.me
curl icanhazip.com

curl --disable ipinfo.io/json
{
  "ip": "86.183.80.65",
  "hostname": "host86-183-80-65.range86-183.btcentralplus.com",
  "city": "Croydon",
  "region": "England",
  "country": "GB",
  "loc": "51.3776,-0.0496",
  "postal": "CR0",
  "org": "AS2856 British Telecommunications PLC"

X
