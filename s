#!/bin/bash

_url='http://v.netsnail.com/'
_dir='/mnt/movies/'

download() {
  _n=1
  curl $_url 2>/dev/null |sed -n 's/<a href="\(.*\)">\(.*\)<\/a>/\1 \2/p' |awk '{print $3"\t"$1}' |sort -t '-' -k3 -k2M -nk1 |awk '{print $2}' |while read i; do
    if [ $1 -eq $((_n++)) ]; then
      curl $_url$i 2>/dev/null |grep -i -E ".mkv\"|.rmvb\"|.mp4\"" |sed -n 's/<a href="\(.*\)">.*/\1/p' |while read f; do
        _res="$_url$i$f"
        echo downloading $_res ...
        lftp -c "pget -O $_dir -n10 \"$_res\""
      done
    fi
  done
}

list() {
  _n=10 ; test -z "$1" || _n=$1
  curl $_url 2>/dev/null |sed -n 's/<a href="\(.*\)">\(.*\)<\/a>/\1 \2/p' |awk '{print $3"\t"$1"\t"$2}' |sort -t '-'  -k3 -k2M -nk1 |awk '{print NR"\t"$3}' |tail -$_n
}

case "$1" in
  l)
    list $2
  ;;
  ll)
    ls -tr1 $_dir |awk '{print NR"\t"$1}'
  ;;
  d)
    download $2
  ;;
  dd)
    ls -tr1 $_dir |awk 'NR=="'$2'"{print "rm -fv \"'$_dir'"$1"\""}' |sh
  ;;
esac
