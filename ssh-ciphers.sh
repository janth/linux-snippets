#!/usr/bin/bash

sudo sshd -T | grep -i ciph
exit

#  463  sslscan --no-failed localhost:22
#  sudo sslscan --no-failed localhost:22
#  nmap --script ssl-enum-ciphers -p 22 localhost

# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')

echo Obtaining cipher list from $(openssl version).

for cipher in ${ciphers[@]} ; do
  #echo "echo -n | openssl s_client -cipher \"$cipher\" -connect $SERVER" ; echo
  echo -n Testing $cipher...
  result=$(echo -n | openssl s_client -cipher "$cipher" -connect $SERVER 2>&1)
  if [[ "$result" =~ ":error:" ]] ; then
    error=$(echo -n $result | cut -d':' -f6)
    echo NO \($error\)
  else
    if [[ "$result" =~ "Cipher is ${cipher}" || "$result" =~ "Cipher    :" ]] ; then
      echo YES
    else
      echo UNKNOWN RESPONSE
      echo $result
    fi
  fi
  sleep $DELAY
done
