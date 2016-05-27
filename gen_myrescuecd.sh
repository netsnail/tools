#!/bin/bash
# base on systemrescuecd

set -x
cd /root

btrfs subvolume delete   -c       mygentoo_
btrfs subvolume snapshot mygentoo mygentoo_

xz -d < initram.igz.origin |cpio -idm -D /tmp/__initram
sed -i 's@# 4@/sbin/modprobe -v aufs\n    # 4@' /tmp/__initram/init
cp -pr mygentoo/squashfs-root/lib/modules /tmp/__initram/lib/
./gen_initramfs_list.sh -o initram.xz /tmp/__initram 
rm -r /tmp/__initram

rm -r mygentoo_/squashfs-root/usr/portage
rm -r mygentoo_/squashfs-root/usr/src/*
mksquashfs mygentoo_/squashfs-root sysrcd.dat -noappend -comp xz
