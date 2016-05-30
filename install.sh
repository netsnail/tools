#!/bin/bash

set -x

_user="www"
_jdk_url="http://172.16.96.119/jdk7.tar.xz"
_tomcat_url="http://172.16.96.119/tomcat0.tar.xz"
_install_dir="/data"

_t="/tmp/$RANDOM"; mkdir -v $_t || exit 1;

cd $_t
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/_tomcat" 2>/dev/null
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/tomcat" 2>/dev/null
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/limits.conf" 2>/dev/null
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/my.sh" 2>/dev/null

mkdir -pv $_install_dir/bin/ || exit 2;

cp -iv $_t/_tomcat      $_install_dir/bin/
cp -iv $_t/tomcat       $_install_dir/bin/
cp -iv $_t/limits.conf  /etc/security/
cp -iv $_t/my.sh        /etc/profile.d/

chmod 755 /etc/profile.d/my.sh
chmod 644 /etc/security/limits.conf
chmod 755 $_install_dir/bin/_tomcat
chmod 755 $_install_dir/bin/tomcat

rm -fv $_t/* && rmdir -v $_t

echo "$_user ALL=(ALL) NOPASSWD: $_install_dir/bin/tomcat" >> /etc/sudoers
wget $_jdk_url -O /tmp/jdk.tar.xz 2>/dev/null || { echo "downloading jdk failed!"; exit 3; }
tar -xf /tmp/jdk.tar.xz -C $_install_dir
wget $_tomcat_url -O /tmp/tomcat.tar.xz 2>/dev/null || { echo "downloading tomcat failed!"; exit 4; }
tar -xf /tmp/tomcat.tar.xz -C $_install_dir
chown -R www-data.www-data $_install_dir/tomcat*
chown $_user $_install_dir/tomcat*/conf
chown $_user $_install_dir/tomcat*/conf/server.xml
chmod g+rx $_install_dir/tomcat*/conf
chmod g+r $_install_dir/tomcat*/conf/server.xml
mkdir $_install_dir/www && chown $_user.root $_install_dir/www

echo -e "\ncomplete :)"
