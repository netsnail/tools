#!/bin/sh
NAME=$1
VERSION=0.1
EMAIL=root@mail.com
test -z $NAME && NAME=main

test -d src && [ ! -e Makefile.am ] && {
  echo create Makefile.am
  echo "SUBDIRS=src" > Makefile.am
  cat Makefile.am
}
test -e src/Makefile.am || {
  echo create src/Makefile.am
  echo "bin_PROGRAMS = ${NAME}" >> src/Makefile.am
  echo "${NAME}_SOURCES = `cd src; find . -name '*.c' |xargs`" >> src/Makefile.am
  cat src/Makefile.am
}
test -d src || exit
autoscan
mv configure.scan configure.in
sed -i "s/AC_INIT(/AC_INIT([${NAME}], [${VERSION}], [${EMAIL}])\n#AC_INIT(/" configure.in
sed -i "s/AC_CONFIG_SRCDIR/\nAM_INIT_AUTOMAKE\nAC_CONFIG_SRCDIR/" configure.in
aclocal
autoheader
touch NEWS README AUTHORS ChangeLog
automake -a
autoconf
