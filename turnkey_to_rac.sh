#!/bin/bash

if [ -z "$1" ]; then
  echo "Specify image name. Example: turnkey.to.RAC openvpn"
  exit
fi

source openrc

wget http://mirror.turnkeylinux.org/turnkeylinux/images/openstack/turnkey-${1}-13.0-wheezy-amd64-openstack.tar.gz
tar -zxvf turnkey-${1}-13.0-wheezy-amd64-openstack.tar.gz
cd turnkey-${1}-13.0-wheezy-amd64
ramid=$( glance image-create --container-format ari --disk-format ari --name ${1}_initrd < turnkey-${1}-13.0-wheezy-amd64-initrd | grep id | awk {'print $4'} )
kernid=$( glance image-create --container-format aki --disk-format aki --name ${1}_kernel < turnkey-${1}-13.0-wheezy-amd64-kernel | grep id | awk {'print $4'} )
glance image-create --container-format ami --disk-format ami --name ${1}_img --property kernel_id=${kernid} --property ramdisk_id=${ramid} < turnkey-${1}-13.0-wheezy-amd64.img
cd ..
nova boot --flavor m1.micro --image ${1}_img --key-name blogpost --security-groups default my${1}
