#!/bin/bash
# base on systemrescuecd

set -x

# create snapshot
btrfs subvolume delete   -c       myrescuer_
btrfs subvolume snapshot myrescuer myrescuer_

# create initram.xz
rm -rf  /tmp/__initram
xz -d < initram.igz.origin |cpio -idm -D        /tmp/__initram
sed -i 's@# 4@/sbin/modprobe -v aufs\n    # 4@' /tmp/__initram/init
cp -pr  myrescuer/squashfs-root/lib/modules     /tmp/__initram/lib/
./gen_initramfs_list.sh -o initram.xz           /tmp/__initram

# clean files
rm -rf  /tmp/__locale
cp -pr  myrescuer_/squashfs-root/usr/share/locale       /tmp/__locale/
rm -r   myrescuer_/squashfs-root/usr/share/locale/*
mv      /tmp/__locale/locale.alias      myrescuer_/squashfs-root/usr/share/locale/
mv      /tmp/__locale/zh_CN             myrescuer_/squashfs-root/usr/share/locale/
echo >  myrescuer_/squashfs-root/root/.bash_history
rm -r   myrescuer_/squashfs-root/usr/share/doc
rm -r   myrescuer_/squashfs-root/usr/portage
rm -r   myrescuer_/squashfs-root/usr/src
rm -r   myrescuer_/squashfs-root/var/db/pkg/*
rm -r   myrescuer_/squashfs-root/var/cache/*
rm -r   myrescuer_/squashfs-root/var/tmp/*
rm -r   myrescuer_/squashfs-root/var/log/*
rm -f   myrescuer_/squashfs-root/boot/*.*
rm -rf  myrescuer_/squashfs-root/tmp/*

# create sysrcd.dat
mksquashfs myrescuer_/squashfs-root sysrcd.dat          -noappend -comp xz
