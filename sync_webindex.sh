#!/bin/bash

_url='http://movies.xxx.com/'
_dir='/mnt/movies/'

get_purl() {
  _n=1
  curl $_url 2>/dev/null |sed -n 's/<a href="\(.*\)">\(.*\)<\/a>/\1 \2/p' |awk '{print $3"\t"$1}' |sort -t '-' -k3 -k2M -nk1 |awk '{print $2}' |while read i; do
    if [ $1 -eq $((_n++)) ]; then
      echo "$_url$i"
    fi
  done
}

list_durl() {
  curl $1 2>/dev/null |grep -i -E ".mkv\"|.rmvb\"|.mp4\"" |sed -n 's/<a href="\(.*\)">[^:]*...\(.*\)/\1\2/p'
}

download() {
  curl $1 2>/dev/null |grep -i -E ".mkv\"|.rmvb\"|.mp4\"" |sed -n 's/<a href="\(.*\)">.*/\1/p' |while read f; do
    _dfile="$1$f"
    echo downloading \"$_dfile\" ...
    lftp -c "pget -O $_dir -n10 \"$_dfile\""
  done
}

list() {
  _n=10 ; test -z "$1" || _n=$1
  curl $_url 2>/dev/null |sed -n 's/<a href="\(.*\)">\(.*\)<\/a>/\1 \2/p' |awk '{print $3"\t"$1"\t"$2}' |sort -t '-'  -k3 -k2M -nk1 |awk '{print NR"\t"$3}' |tail -$_n
}

delete_purl() {
  _n=1
  curl $_url 2>/dev/null |sed -n 's/<a href="\(.*\)">\(.*\)<\/a>/\1 \2/p' |awk '{print $3"\t"$1"\t"$2}' |sort -t '-' -k3 -k2M -nk1 |awk '{print $3}' |while read i; do
    if [ $1 -eq $((_n++)) ]; then
      _t="${i/%..&gt;/*}"
      _t="${_t//$/\\$}"
      _t="${_t//&amp;/\\&}"
      _t="${_t//(/\\(}"
      _t="${_t//)/\\)}"
      _t="${_t//[/\\[}"
      _t="${_t//]/\\]}"
      echo $_t
    fi
  done
}

case "$1" in
  l)
    list $2
  ;; 
  lr)
    test -z $2 && exit -1
    _purl=`get_purl $2`
    list_durl "$_purl"
  ;;
  d)
    test -z $2 && exit -2
    _purl=`get_purl $2`
    download "$_purl"
  ;;
  ll)
    ls -tr1 $_dir |awk '{print NR"\t"$0}'
  ;; 
  dl)
    test -z $2 && exit -3
    ls -tr1 $_dir |awk 'NR=="'$2'"{print "rm -fv \"'$_dir'"$0"\""}' |sh
  ;;
  dr)
    test -z $2 && exit -4
    _file=`delete_purl $2`
    echo delete $_file
    if [[ "$3" == "y" ]]; then
	echo "ssh -p22 tiger@netsnail.com rm -rfv \"/home/tiger/Movies/$_file\"" |sh
    fi
  ;;
  *)
    echo -e "Usage: $0 [options]"
    echo -e " l  \t list url resources"
    echo -e " lr \t list remote directory"
    echo -e " d  \t download destination"
    echo -e " ll \t list local directory"
    echo -e " dl \t delete local destination"
    echo -e " dr \t delete remote destination"
  ;;
esac

