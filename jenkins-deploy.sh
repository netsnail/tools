host="172.16.96.136"
port="22"
login="www"
password="******"
package="ROOT.war"

cmd=`cat<<!
cd /data/www
tar -cf "backup/ROOT-$(date +'%s')-tar" ROOT
sudo /data/bin/tomcat 0 stop
rm -rf ROOT
mv -v /tmp/ROOT.war .
mkdir -pv ROOT; cd ROOT; /data/jdk7/bin/jar -xf ../ROOT.war 
sudo /data/bin/tomcat 0 restart
!`

scopy="scp -P$port /tmp/$package $login@$host:/tmp/$package"
sconn="ssh -p$port $login@$host"
_in="/tmp/empty.in.$RANDOM"
_out="/tmp/empty.out.$RANDOM"
_log="/tmp/empty.log.$RANDOM"
_timeout=20

# scp
empty -f -L $_log -i $_in -o $_out $scopy
[ $? = 0 ] || { echo "Cannot start empty scp"; exit 1; }
empty -w -v -i $_out -o $_in -t $_timeout assword: "$password\n"
sleep 1; cat $_log; echo >$_log

# ssh
empty -f -L $_log -i $_in -o $_out $sconn
[ $? = 0 ] || { echo "Cannot start empty ssh"; exit 2; }
empty -w -v -i $_out -o $_in -t $_timeout assword: "$password\n"
empty -s -o $_in "$cmd\n"
empty -s -o $_in "exit\n"
sleep 1; cat $_log; rm -f $_log;
