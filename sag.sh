#!/bin/bash

## script_name=${0##*/}                               # Basename, or drop /path/to/file
## script=${script_name%%.*}                          # Drop .ext.a.b
## script_path=${0%/*}                                # Dirname, or only /path/to
## script_path=$( [[ -d ${script_path} ]] && cd ${script_path} ; pwd)             # Absolute path
## script_path_name="${script_path}/${script_name}"   # Full path and full filename to $0
## absolute_script_path_name=$( /bin/readlink --canonicalize ${script_path}/${script_name})   # Full absolute path and filename to $0
## absolute_script_path=${absolute_script_path_name%/*}                 # Dirname, or only /path/to, now absolute
## script_basedir=${script_path%/*}                   # basedir, if script_path is .../bin/

host=$( hostname -s)
safile="$HOME/.ssh-agent.$host"
rm -v $HOME/.ssh-agent.*
echo $safile
ssh-agent > $safile
source $safile
ssh-add $HOME/.ssh/{id_{rsa{,-sintef,-engen},ed25519},ovmlab,vagrant}
ssh-add -l
