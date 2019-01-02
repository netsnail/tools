#!/bin/bash

i=0
Xdialog --title "番茄个数 $i" --center --yesno  '开始工作吗？' 8 40
while test 0 -eq $?; do
    sleep 25m
    Xdialog --title "番茄个数 $i" --center --msgbox  '休息一会吧!' 8 40
	sleep 5m
	i=$((i+1))
	test 0 -eq $((i % 4)) && sleep 20m
	Xdialog --title "番茄个数 $i" --center --yesno  '继续工作吗？' 8 40
done
