#!/bin/bash

# sysunconfig for rhel7

# https://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/
# see also /usr/bin/virt-sysprep (http://libguestfs.org/virt-sysprep.1.html), from libguestfs-tools-c
# repoquery --requires libguestfs-tools-c
# repoquery --list libguestfs-tools-c
# libguestfs-tools ?

if [ -z $1 ] ; then
  echo "Must specify new hostname (fqdn)"
  exit 1
fi

# TODO: Check for $1 fqdn, handle no domain?

# Switch to runlevel 1
/sbin/init 1

[[ ! -x /bin/package-cleanup ]] && yum -y install yum-utils
/bin/package-cleanup --oldkernels --count=1

# clean yum
/usr/bin/yum clean all

# clean logs
/usr/sbin/logrotate –f /etc/logrotate.conf
/bin/rm –f /var/log/*-???????? /var/log/*.gz /var/log/dmesg.old /var/log/anaconda 2>/dev/null
for log in /var/log/audit/audit.log /var/log/wtmp /var/log/lastlog /var/log/grubby ; do
   /bin/cat /dev/null > ${log}
done

# clean udev persistent device rules
/bin/rm -f /etc/udev/rules.d/70* /etc/udev/rules.d/*-persistent-*.rules 2>/dev/null

# clean tmp
/bin/rm –rf /tmp/* /var/tmp/*

# clear history
/bin/rm -f ~root/.bash_history
unset HISTFILE

# clean ~root
/bin/rm -rf ~root/.ssh/
/bin/rm -f ~root/anaconda-ks.cfg

# clean ssh hostkeys
/bin/rm -f /etc/ssh/ssh_host_*
#systemctl restart NetworkManager sshd rsyslog

# hostnamectl set-deploymentinfo | set-location | set-chassis stores info in /etc/machine-info
[ -r /etc/machine-info ] && rm /etc/machine-info

# Set hostname
/bin/hostnamectl set-hostname $1

# TODO: bootid
[ -r /etc/machine-id ] && rm /etc/machine-id
systemd-machine-id-setup
[ -r /etc/hostid ] && rm /etc/hostid
/sbin/genhostid # makes /etc/hostid

# Nic config
# for nic in $( ls /sys/class/net | grep -v lo ) ; do
for nic in enp0s3 enp0s8 ; do
  uuid=$( uuidgen ${nic} )
  mac=$( cat /sys/class/net/${nic}/address )
  perl -i -pe "s/^UUID.*$/UUID=$uuid/; s/^HWADDR=.*$/HWADDR=$mac/;" /etc/sysconfig/network-scripts/ifcfg-${nic}
  # /bin/sed -i ‘/^(HWADDR|UUID)=/d’ /etc/sysconfig/network-scripts/ifcfg-${nic}
done
#vim +/^IPADDR=.* /etc/sysconfig/network-scripts/ifcfg-enp0s8

# Clean puppet
if [[ -x /usr/bin/puppet ]] ; then
   ssldir=$( /usr/bin/puppet config print ssldir )
   rm -Rf $ssldir
   /usr/bin/puppet agent -t
fi

# TODO: zero disk(s)
# Zero out all free space, then use storage vMotion to re-thin the VM.
## 
## #!/bin/sh
## 
## # Determine the version of RHEL
## COND=`grep -i Taroon /etc/redhat-release`
## if [ "$COND" = "" ]; then
##         export PREFIX="/usr/sbin"
## else
##         export PREFIX="/sbin"
## fi
## 
## FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`
## 
## for i in $FileSystem
## do
##         echo $i
##         number=`df -B 512 $i | awk -F" " '{print $3}' | grep -v Used`
##         echo $number
##         percent=$(echo "scale=0; $number * 98 / 100" | bc )
##         echo $percent
##         dd count=`echo $percent` if=/dev/zero of=`echo $i`/zf
##         /bin/sync
##         sleep 15
##         rm -f $i/zf
## done
## 
## VolumeGroup=`$PREFIX/vgdisplay | grep Name | awk -F" " '{ print $3 }'`
## 
## for j in $VolumeGroup
## do
##         echo $j
##         $PREFIX/lvcreate -l `$PREFIX/vgdisplay $j | grep Free | awk -F" " '{ print $5 }'` -n zero $j
##         if [ -a /dev/$j/zero ]; then
##                 cat /dev/zero > /dev/$j/zero
##                 /bin/sync
##                 sleep 15
##                 $PREFIX/lvremove -f /dev/$j/zero
##         fi
## done
