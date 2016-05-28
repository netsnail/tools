#!/bin/bash
# base on systemrescuecd

set -x
cd /root

# create snapshot
btrfs subvolume delete   -c       mygentoo_
btrfs subvolume snapshot mygentoo mygentoo_

# create initram.xz
rm -rf /tmp/__initram
xz -d < initram.igz.origin |cpio -idm -D /tmp/__initram
sed -i 's@# 4@/sbin/modprobe -v aufs\n    # 4@' /tmp/__initram/init
cp -pr mygentoo/squashfs-root/lib/modules /tmp/__initram/lib/
./gen_initramfs_list.sh -o initram.xz /tmp/__initram

# clean files
rm -rf  /tmp/__locale
cp -pr  mygentoo_/squashfs-root/usr/share/locale /tmp/__locale/
rm -r   mygentoo_/squashfs-root/usr/share/locale/*
mv      /tmp/__locale/locale.alias      mygentoo_/squashfs-root/usr/share/locale/
mv      /tmp/__locale/zh_CN             mygentoo_/squashfs-root/usr/share/locale/
echo >  mygentoo_/squashfs-root/root/.bash_history
rm -r   mygentoo_/squashfs-root/usr/share/doc
rm -r   mygentoo_/squashfs-root/usr/portage
rm -r   mygentoo_/squashfs-root/usr/src

# create sysrcd.dat
mksquashfs mygentoo_/squashfs-root sysrcd.dat -noappend -comp xz
