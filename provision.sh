#!/bin/sh -e

### setup packages
mkdir -p /usr/local/etc/pkg/repos
echo "FreeBSD: { enabled: no  }" > /usr/local/etc/pkg/repos/FreeBSD.conf
cp /etc/pkg/FreeBSD.conf /usr/local/etc/pkg/repos/latest.conf
sed -i "" 's/quarterly/latest/' /usr/local/etc/pkg/repos/latest.conf
sed -i "" 's/FreeBSD:/latest:/' /usr/local/etc/pkg/repos/latest.conf
pkg upgrade -y
pkg install -y pot git

### zfs
zpool create zroot nvd0

### pot
echo "POT_EXTIF=vtnet0" > /usr/local/etc/pot/pot.conf
ifconfig vtnet0 -lro
pot init
git clone https://github.com/pizzamig/pot.git
cd pot/etc/pot
ln -s /usr/local/etc/pot/pot.conf
cd ../../tests/CI/
sed -i "" 's/^STACKS.*/STACKS="ipv4"/' run.sh
