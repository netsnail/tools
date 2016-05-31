#!/bin/bash
# "\033[<L>;<C>H"  其中<L>代表此处应该是一个数字，表示坐标行, C为纵坐标, 定位光>标
# "\033[<N>A"      以当前光标为参照，上移N行, 水平方向不动
# "\033[<N>B"      同上，下移
# "\033[<N>C"      同上，右移
# "\033[<N>D"      同上，左移
# "\033[2J"        清屏
# "\e[0,31mXXXXX\e[m" 红色

if [ -f "$1" ]; then

        /usr/bin/iconv -f gbk -t utf-8 "$1" > /tmp/tmp_iconv 2> /tmp/error_msg

        if [ $? -ne 0 ]; then
                echo -ne " \e[0;32mCONV\e[m $1\t"
                echo -e "\e[0;31m"`cat /tmp/error_msg`"\e[m"
        else
                cp /tmp/tmp_iconv "$1"
                echo -en " \e[0;32mCONV\e[m $1""\033[80D"
                echo -e "\033[72C"[ "\e[0;33m"OK"\e[m" ]"\033[72D"
        fi
fi
