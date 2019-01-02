#!/bin/bash

i=0
Xdialog --title "第 $i 个番茄" --center --yesno  '开始工作吗？' 8 40
while test 0 -eq $?; do
  sleep 25m
  i=$((i+1))
  Xdialog --title "第 $i 个番茄" --center --msgbox  '休息一会吧!' 8 40
  sleep 5m
  test 0 -eq $((i % 4)) && sleep 20m
  Xdialog --title "第 $i 个番茄" --center --yesno  '继续工作吗？' 8 40
done
