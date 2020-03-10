#!/bin/bash
workdir=/tmp/pxeboot
mkdir -p $workdir; cd $workdir; 
mkdir -p {iso,pxelinux.cfg}

url=http://mirrors.aliyun.com/centos/7/os/x86_64/images/pxeboot/
eth=enp0s31f6
iso=~/Downloads/CentOS-7-x86_64-Everything-1810.iso
iso=~/Downloads/CentOS-7-x86_64-DVD-1908.iso
myip=192.168.1.10
subnet=192.168.1

echo Mount iso and starting http server...
mount $iso $workdir/iso
bin/httpd 8000 &

wget $url/vmlinuz
wget $url/initrd.img
wget http://mirrors.aliyun.com/debian/dists/stable/main/installer-amd64/current/images/netboot/pxelinux.0
wget http://mirrors.aliyun.com/debian/dists/stable/main/installer-amd64/current/images/netboot/debian-installer/amd64/boot-screens/ldlinux.c32

echo "default linux
 label linux
  kernel vmlinuz
  append initrd=initrd.img method=http://$myip:8000/iso devfs=nomount ks=http://$myip:8000/ks.cfg
" >pxelinux.cfg/default

echo Setting up iptables...
iptables -t nat -F
iptables -t nat -A POSTROUTING -j MASQUERADE

echo Starting DHCP+TFTP server...
dnsmasq --interface=$eth \
  --dhcp-range=$subnet.100,$subnet.199,255.255.255.0,1h \
  --dhcp-match=bios,option:client-arch,0 \
  --dhcp-match=efi_x64,option:client-arch,7 \
  --dhcp-match=efi_x64,option:client-arch,9 \
  --dhcp-boot=tag:bios,pxelinux.0 \
  --dhcp-boot=tag:efi_x64,efi/bootx64.efi \
  --pxe-service=tag:bios,x86PC,"Install Linux",pxelinux \
  --pxe-service=tag:efi_x64,x86-64_EFI,"Install Linux EFI",efi/grubx64.efi \
  --enable-tftp --tftp-root=$workdir/ --no-daemon
