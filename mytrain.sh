#!/bin/bash

open() {
  _str=${1//\"/}
  #chrome "https://kyfw.12306.cn/otn/login/init"
  chrome "https://kyfw.12306.cn/otn/leftTicket/submitOrderRequest?tour_flag=dc&purpose_codes=ADULT&secretStr=$_str"
  chrome "https://kyfw.12306.cn/otn/confirmPassenger/initDc"
}
ok() {
  mpg123 ~/Musics/Aqua\ -\ Around\ The\ World.mp3
}
query() {
  _date=$1
  _from=$2
  _to=$3
  _num=$4
  res=$(curl -k -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36" "https://kyfw.12306.cn/otn/leftTicket/queryA?leftTicketDTO.train_date=$_date&leftTicketDTO.from_station=$_from&leftTicketDTO.to_station=$_to&purpose_codes=ADULT" 2>/dev/null | jq ".data[$_num]|{NO_:.queryLeftNewDTO.station_train_code,from:.queryLeftNewDTO.from_station_name,to:.queryLeftNewDTO.to_station_name,yw:.queryLeftNewDTO.yw_num,rw:.queryLeftNewDTO.rw_num,start_time:.queryLeftNewDTO.start_time,arrive_time:.queryLeftNewDTO.arrive_time,secretStr:.secretStr}")
  echo $res |jq '.'
  test -z "$res" && return
  _sstr=$(echo $res |jq -e 'select((.yw != "无" and .yw != "--" and .yw !="null") or (.rw != "无" and .rw != "--" and .rw != "null")) |.secretStr')
  if test "$?" -eq "0"; then
    open $_sstr
    ok
  fi
  sleep .3
}

_date=2016-12-30
_dest=BJP

if true
then

# k105,1303 商丘
query $_date $_dest SQF "-1,-2"
# k105 亳州
query $_date $_dest BZH -1
# 1303 民权
query $_date $_dest MQF -1
# k105 阜阳
query $_date $_dest FYH -1
# 1303 开封
query $_date $_dest KFF -1
# 1303 郑州
query $_date $_dest ZZF -1

else

# k148,1488 商丘
query $_date SQF $_dest "-1,-2,-3"
# k148 亳州
query $_date BZH $_dest -1
# 1488 民权
query $_date MQF $_dest -1
# k148 阜阳
query $_date FYH $_dest -2
# 1488 开封
query $_date KFF $_dest -1
# 1488 郑州
query $_date ZZF $_dest -6

fi
