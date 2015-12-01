#!/bin/sh

case $USER in
root|www-data) ulimit -SHn 65536;;
esac

export PATH=$HOME/bin:/data/bin:$PATH
