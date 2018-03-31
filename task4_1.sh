#!/bin/bash

LANG=C.UTF-8

OUTPUT_FILE_NAME="task4_1.out"
OLD_PWD=`pwd`

SCRIPT_NAME=$0
PATH_BEGIN="${SCRIPT_NAME:0:1}"
if [ "$PATH_BEGIN" == "/" ]; then
	PATH_WRK=`dirname $SCRIPT_NAME`
else
	PATH_A="`pwd`"
	PATH_B=`dirname "$SCRIPT_NAME" | sed 's/^\.\///g' | sed 's/\.$//g'`
	PATH_WRK="$PATH_A/$PATH_B"
fi
# Output file 
OUTPUT_FILE="$PATH_WRK/$OUTPUT_FILE_NAME"
echo -n > ${OUTPUT_FILE}

# --- Hardware ---
echo "--- Hardware ---" >> ${OUTPUT_FILE}
# CPU
echo -n "CPU: " >> ${OUTPUT_FILE}
echo -ne `lscpu | grep "Model name" | sed 's/^.*:[[:space:]]*//g'`"\n" >> ${OUTPUT_FILE}
# RAM
echo -n "RAM: " >> ${OUTPUT_FILE}
echo -ne `cat /proc/meminfo | grep MemTotal: | sed 's/^.*:[[:space:]]*//g'`"\n" >> ${OUTPUT_FILE}
# MB = dmidecode
echo -n "Motherboard: " >> ${OUTPUT_FILE}
echo -ne `sudo dmidecode --type baseboard | grep "Manufacturer:" | sed 's/^.*:[[:space:]]*//g'`" / " >> ${OUTPUT_FILE}
echo -ne `sudo dmidecode --type baseboard | grep "Product Name:" | sed 's/^.*:[[:space:]]*//g'`" / " >> ${OUTPUT_FILE}
echo -ne `sudo dmidecode --type baseboard | grep "Version:" | sed 's/^.*:[[:space:]]*//g'`"\n" >> ${OUTPUT_FILE}
# System serial = dmidecode
echo -n "System Serial Number: " >> ${OUTPUT_FILE}
echo -ne `sudo dmidecode -s system-serial-number`"\n" >> ${OUTPUT_FILE}
# --- System ---
echo "--- System ---" >> ${OUTPUT_FILE}
# OS Distribution
echo -n "OS Distribution: " >> ${OUTPUT_FILE}
echo -ne `lsb_release -d | grep "Description:" | sed 's/^.*:[[:space:]]*//g'`"\n" >> ${OUTPUT_FILE}
# Kernel version
echo -n "Kernel version: " >> ${OUTPUT_FILE}
echo -ne `uname --kernel-release`"\n" >> ${OUTPUT_FILE}
# Installation date
echo -n "Installation date: " >> ${OUTPUT_FILE}
echo -ne `sudo dumpe2fs $(mount | grep 'on \/ ' | awk '{print $1}') 2>&1 | grep 'Filesystem created:' | awk '{print $4,$5,$7}'`"\n" >> ${OUTPUT_FILE}
# Hostname
echo -n "Hostname: " >> ${OUTPUT_FILE}
echo -ne `hostname -f`"\n" >> ${OUTPUT_FILE}
# Uptime
echo -ne "Uptime: `uptime -p | sed 's/up //g'`\n" >> ${OUTPUT_FILE}
# Processes running
echo -n "Processes running: " >> ${OUTPUT_FILE}
echo -ne $((`ps -auxh | wc -l`))"\n" >> ${OUTPUT_FILE}
# User logged in
echo -n "User logged in: " >> ${OUTPUT_FILE}
echo -ne $((`w -h | wc -l`))"\n" >> ${OUTPUT_FILE}
# --- Network ---
echo "--- Network ---" >> ${OUTPUT_FILE}
# Get name interfaces
INT_NAME=`cat /proc/net/dev | awk -F : '{if (NR>2) print $1}' | sort`
for i in $INT_NAME ; do 
	IP_AND_MASK_4=`ip address show ${i} | grep "inet " | awk '{print $2}' | tr '\n' ' '`
	IP_AND_MASK_4=`echo $IP_AND_MASK_4 | sed 's/\ /,\ /g'`
	if [[ $IP_AND_MASK_4 = "" ]]; then IP_AND_MASK_4="-" ; fi
	echo -e "$i: $IP_AND_MASK_4" >> ${OUTPUT_FILE};
done
