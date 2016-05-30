#!/bin/bash

_user="www"
_jdk_url="http://172.16.96.119/jdk7.tar.xz"
_tomcat_url="http://172.16.96.119/tomcat0.tar.xz"

_t="/tmp/$RANDOM"; mkdir -v $_t || exit 1

cd $_t
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/_tomcat"
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/tomcat"
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/limits.conf"
wget -k "https://raw.githubusercontent.com/netsnail/tools/master/install/my.sh"

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

echo "$_user ALL=(ALL) NOPASSWD: /data/bin/tomcat" >> /etc/sudoers
wget $_jdk_url -O /tmp/jdk.tar.xz && tar -xvf /tmp/jdk.tar.xz -C /data
wget $_tomcat_url -O /tmp/tomcat.tar.xz && tar -xvf /tmp/tomcat.tar.xz -C /data && \
chown -R $_user.root /data/tomcat* && chown -R www-data.www-data /data/tomcat*/{logs,work,temp}

mkdir /data/www && chown $_user.$_user /data/www

echo "complete!"



