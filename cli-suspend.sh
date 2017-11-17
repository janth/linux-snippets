#!/bin/bash

cat << X
# https://askubuntu.com/questions/1792/how-can-i-suspend-hibernate-from-command-line

sudo systemctl suspend
sudo systemctl hibernate

sudo pmi action suspend
sudo pmi action hibernate

qdbus...
dbus...

X
