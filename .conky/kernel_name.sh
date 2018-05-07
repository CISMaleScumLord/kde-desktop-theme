#! /bin/bash
#

KERNEL=`uname -r | cut -d '-' -f1 | cut -d'.' -f1,2`
BASE_URL="https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/plain/Makefile?h=linux-"

if [ ! -f ./$KERNEL ]
then
	wget -O ./$KERNEL $BASE_URL$KERNEL".y"
fi

name=`grep NAME $KERNEL | cut -c 8-`

echo $name
exit
