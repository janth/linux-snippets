#!/bin/bash

cat << X

python -c 'import crypt,getpass; print crypt.crypt(getpass.getpass())'

perl -le 'print "Password:"; `stty -echo`; chomp($passphrase=<STDIN>); `stty echo`; @chars = ("a".."z", "A".."Z", 0..9, ".", "/"); $salt .= $chars[rand @chars] for 1..16; print crypt($passphrase, "\$6\$$salt");'

perl -le '@chars = ("a".."z", "A".."Z", 0..9, ".", "/"); $salt .= $chars[rand @chars] for 1..16; print crypt($passphrase, "\$6\$$salt");'

https://hash.online-convert.com/sha512-generator


Format:
\$ID\$SALT\$ENCRYPTED

Hash Type    	ID    Hash Length
MD5    		\$1    22 characters
SHA-256    	\$5    43 characters
SHA-512    	\$6    86 characters

X
