#!/bin/bash

_t=/tmp/$RANDOM; mkdir -v $_t || exit 1

wget -O$_t -k "https://raw.githubusercontent.com/netsnail/tools/master/install/_tomcat"
wget -O$_t -k "https://raw.githubusercontent.com/netsnail/tools/master/install/tomcat"
wget -O$_t -k "https://raw.githubusercontent.com/netsnail/tools/master/install/limits.conf"
wget -O$_t -k "https://raw.githubusercontent.com/netsnail/tools/master/install/my.sh"

mkdir -pv /data/bin/ || exit 2

cp -iv $_t/_tomcat 	/data/bin/
cp -iv $_t/tomcat 	/data/bin/
cp -iv $_t/limits.conf 	/etc/security/
cp -iv $_t/my.sh 	/etc/profile.d/

chmod 755 /etc/profile.d/my.sh
chmod 644 /etc/security/limits.conf
chmod 755 /data/bin/_tomcat
chmod 755 /data/bin/tomcat

rm -fv $_t/* && rmdir -v $_t

echo "`whoami` ALL=(ALL) NOPASSWD: /data/bin/tomcat" >> /etc/sudoers
