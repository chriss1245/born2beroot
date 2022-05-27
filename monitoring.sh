#!/bin/bash
wall $'#Architecture: ' `hostnamectl | grep "Operating System" | cut -d ' ' -f5- ` `awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'` `arch` \
$'\n#CPU physical: '`cat /proc/cpuinfo | grep processor | wc -l` \
$'\n#vCPU:  '`cat /proc/cpuinfo | grep processor | wc -l` \
$'\n'`free -th --mega | grep Total | awk '{print("#Memory Usage:", $3, "/", $2)}'` \
$'\n'`df -BM --total -x tmpfs | grep total | awk '{print("#Disk Usage:", $3, "/", $2)}'` \
$'\n'`top -bn1 | grep load | awk '{printf "#CPU Load: %.3f\n", $(NF-2)}'` \
$'\n#Last boot: ' `who -b | awk '{print $3" "$4" "$5}'` \
$'\n#LVM use: ' `lsblk |grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"} }'` \
$'\n#Connection TCP:' `netstat -an | grep ESTABLISHED |  wc -l`\
$'\n#User log: ' `who | cut -d " " -f 1 | sort -u | wc -l` \
$'\n#Network: IP ' `hostname -I`"("`ip a | grep link/ether | awk '{print $2}'`")" \
$'\n#Sudo:  ' `cat /var/log/auth.log |grep sudo | wc -l`

