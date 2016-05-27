#!/bin/bash
# base on systemrescuecd

set -x
cd /root

btrfs subvolume delete   -c       mygentoo_
btrfs subvolume snapshot mygentoo mygentoo_

# 创建initram.igz
xz -d < initram.igz.origin |cpio -idm -D /tmp/myinitram
sed -i 's@# 4@/sbin/modprobe -v aufs\n    # 4@' /tmp/myinitram/init
cp -pr mygentoo/squashfs-root/lib/modules /tmp/myinitram/lib/
./gen_initramfs_list.sh -o initram.igz /tmp/myinitram
rm -r /tmp/myinitram

# 创建sysrcd.dat
rm -r mygentoo_/squashfs-root/usr/portage
rm -r mygentoo_/squashfs-root/usr/src/*
mksquashfs mygentoo_/squashfs-root sysrcd.dat -noappend
