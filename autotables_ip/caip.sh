#!/bin/bash
ip=""
#netstat -ntu | awk 'NR>2{print $5}'| awk -F":" '{print $1}'|sort -n |awk  '{ip[$1]++} END{for(i in ip) {print i}}'
#curl http://www.cip.cc/$ip
#url http://ip.taobao.com/service/getIpInfo.php?ip=$ip
#/caip.sh | awk -F"," '{print $3}'|awk -F"\"" '{print $4}'
#curl http://ip.taobao.com/service/getIpInfo.php?ip=$ip | awk -F"," '{print $3}'|awk -F"\"" '{print $4}'
echo $ip
# curl http://ip.taobao.com/service/getIpInfo.php?ip=139.9.89.77 | awk -F"," '{print $2 "\t" $3 "\t"$6 }'| awk -F"\{"  '{print $2}'
# echo $(curl http://ip.taobao.com/service/getIpInfo.php?ip=139.9.89.77) $(date "+%Y-%m-%d %H:%M:%S")
