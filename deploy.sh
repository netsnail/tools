_p=xxxx ; cd /data/www ;

echo '<meta charset="utf8"><meta http-equiv="refresh" content="5" /><center><br/><h3>请稍等，系统升级中...</h3>' >/data/nginx/html/upgrade.htm ;
sleep 10 ; sudo /data/bin/tomcat 0 stop ;

tar -jcf backup/$_p-$(date +'%Y%m%d%H%M').tar.bz2 $_p ;
test -d /tmp/$_p && rm -rf /tmp/$_p ;
test -d $_p  && mv $_p /tmp ;
unzip -qo $_p.zip -d . ;
cp -Rf config/$_p/* $_p/ ;

sudo /data/bin/tomcat 0 start ; sleep 30 ;
rm -f /data/nginx/html/upgrade.htm ;
