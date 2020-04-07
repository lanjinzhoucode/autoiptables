#!/bin/bash

while :;do
#测试脚本运行时间1
##echo time1=$(date +%s)
now_all_connect_ip=$(netstat -ntu | awk 'NR>2{print $5}'| awk -F":" '{print $1}'|sort -n |awk  '{ip[$1]++} END{for(i in ip) {print i}}')
#echo ${now_all_connect_ip}   abc=$i
#iptables -L  OUTPUT -n > ./OUTPUT_info 
echo ${now_all_connect_ip} | xargs -n1 > ./now_all_connect_ip

###处理黑名单代码,检查iptables里面有没有黑名单里面的ip,如果有就忽略,没有就写入黑名单数据
for b  in  $(cat ./ip_blacklist);do
    tab_ip=$(iptables -L OUTPUT  -n | grep $b)
    if [ "${tab_ip}" == "" ]; then
    iptables -A OUTPUT -d $b  -j DROP
    fi
done 

###去重代码块,黑名单出现多个同样的ip 或者其他意外情况出现iptables出现重复的条目,只保留一条,多余的删除
for d in $(iptables -L OUTPUT  -n | awk  'NR>2 {print $5}');do
   tab_ip_1=$(cat ./ip_blacklist | grep $d)
   grep_tab_white=$( cat ./ip_whitelist | grep -Fx $d)
   tab_ip_2=$(iptables -L OUTPUT  -n | grep $d | awk 'NR>1')
#   tab_ip_22=$(iptables -L OUTPUT  -n | grep $d)
   if [ "$tab_ip_2" != "" ];then
   iptables -D OUTPUT -d $d  -j DROP
   fi
#判断tab表ip是否是否在白名单里面如果在就干掉 
   if [ "${grep_tab_white}" !=  ""  ];then
   iptables -D OUTPUT -d $d  -j DROP
   fi
  
done 

# 删除存在白名单的tab表
#for g in $(cat ./ip_whitelist);do
#iptables -D OUTPUT -d $g  -j DROP
#done


## 设置清理all_ip_info 和iptables表的超时时间 单位小时
settime=100
for e  in $(cat ./all_ip_info);do
  date_now=$(date +%s)
  date_history=$(echo $e | awk -F"_" '{print $NF }')
  settime_change=$(expr $settime \* 3600)
  mytime=$(expr ${date_now} - ${date_history} - ${settime_change}) 
  mycllean=$(echo $e | awk -F"_" '{ print $1 }'|awk -F'"' '{print $4}')
  grep_black_ip_1=$( cat ./ip_blacklist| grep -Fx ${mycllean})
  tab_ip_3=$(iptables -L OUTPUT  -n | grep ${mycllean})
  [ "${grep_black_ip_1}" == "" ] && [ ${mytime} -gt  0 ] && sed -i  "/$mycllean/d" ./all_ip_info && [ "${tab_ip_3}" != "" ] &&  iptables -D OUTPUT -d ${mycllean}  -j DROP
done


######################################################################################################
# 下面这个for循环是更新 all_ip_info 和history_all_ip_info数据 
#######################################################################################################
for i  in  $now_all_connect_ip;do
##判断当前目录下all_ip_info是否有该ip的信息如果没有就写进all_ip_info 
#   echo $now_all_connect_ip
   aaip=$( cat ./all_ip_info | awk -F"_" '{ print $1 }'|awk -F'"' '{print $4}'| grep -Fx $i)
#    echo 1
   bbip=$( cat ./history_all_ip_info | awk -F"_" '{ print $1 }'|awk -F'"' '{print $4}'| grep -Fx $i)
#    echo 2
##判断当前目录下all_ip_info是否有该ip的信息如果没有就写进all_ip_info
    if [ "$bbip" == "" ]; then
###获取IP地信息如果没有获取到就一直循环去获取直道获取到了为止      
       while :;do
       tem_info_a=$(curl -s  --connect-timeout 2  -m 5  http://ip.taobao.com/service/getIpInfo.php?ip=$i)
       [ "${tem_info_a}" !=  "" ] && break
       done
    echo $( echo ${tem_info_a} | awk -F"," '{print $2 "\t" $3 "\t" $6 }'| awk -F"{"  '{print $2}'|awk  '{print $1 "_" $2 "_"$3}')_$(date "+%Y-%m-%d-%H:%M:%S")_$(date +%s) >> ./history_all_ip_info
#    echo ${tem_info_a}
    sleep 1 
    fi
##判断当前目录下history_all_ip_info是否有该ip的信息如果没有就写进history_all_ip_info
    if [ "$aaip" == "" ]; then  
###获取IP地信息如果没有获取到就一直循环去获取直道获取到了为止
       while :;do
       tem_info_b=$(curl  -s --connect-timeout 2  -m 5  http://ip.taobao.com/service/getIpInfo.php?ip=$i)
       [ "${tem_info_b}" !=  "" ] && break
       done
    echo $(echo $tem_info_b | awk -F"," '{print $2 "\t" $3 "\t" $6 }'| awk -F"{"  '{print $2}'|awk  '{print $1 "_" $2 "_"$3}')_$(date "+%Y-%m-%d-%H:%M:%S")_$(date +%s) >> ./all_ip_info
#    echo $tem_info_b
    sleep 1
    fi
done

###############################################################################################



for a  in $(cat ./all_ip_info)
    do
     mynumber=${#a}
#     echo  mynumber=${mynumber}
#     echo $a

##过滤出所有满足条件需要增加到iptables表的数据 aip为存放提取ip的变量 bip为存放iptables存在相应IP的条目
     aip=$(echo $a | awk -F"_" '{ print $1 }'|awk -F'"' '{print $4}')
     bip=$(iptables -L OUTPUT  -n | grep $aip)
#     echo bip=$bip
     country=$(echo $a |awk -F"_" '{ print $2}'|awk -F'"' '{print $4}')
#     echo country=$country
     city=$(echo $a  |awk -F"_" '{ print $3}'|awk -F'"' '{print $4}')
#     echo city=$city
     grep_ip_blacklist=$(cat ./ip_blacklist | grep -Fx ${aip})
     grep_country=$( cat ./allow_address | awk '{print $1}'| grep -Fx  ${country})
#     echo grep_country=$grep_country
     grep_city=$( cat  ./allow_address | awk '{print $2}'| grep -Fx  ${city})
#     echo grep_city=$grep_city
#     grep_black_ip=$( cat ./ip_blacklist| grep -Fx ${aip})
     grep_country_1=$( cat ./allow_address | awk '{print $1}' | grep -Fx  \* )
     grep_city_1=$(  cat ./allow_address | awk '{print $2}' | grep -Fx  \* )
     grep_white_ip=$( cat ./ip_whitelist | grep -Fx ${aip})

## 如果字符串长度小于70个就删除该条
 [ ${mynumber} -lt 70 ]  &&   sed -i  "/$a/d" ./all_ip_info
## 处理国家和城市带*号流程代码
 if [ "$bip" != "" ] ; then
     
     if [ "${grep_country_1}" != "" ] && [ "${grep_ip_blacklist}" == "" ]; then
#     echo 1
     iptables -D OUTPUT -d ${aip}  -j DROP
     fi
     
     if  [ "$grep_country" != "" ] && [ "${grep_country_1}" == "" ] && [ "${grep_city_1}" != "" ] && [ "${grep_ip_blacklist}" == "" ]; then
      echo 2
     iptables -D OUTPUT -d ${aip}  -j DROP
     fi

 fi

 if [ "$bip" == "" ] && [ "${grep_country_1}" == "" ] && [ "${grep_city_1}" != "" ] && [ "${grep_country}" == "" ] && [ "${grep_white_ip}" == "" ]; then
      iptables -A OUTPUT -d ${aip}  -j DROP
 fi


##  [ ! -s ./ip_whitelist ] && echo ip_whitelist为空

###判断所有iptables是否有该条信息如果有就跳过没有则进行下一个选择 国家和城市都没有*的处理代码 
if [ "${grep_country_1}" == "" ] && [  "${grep_city_1}" == "" ] && [ "${grep_ip_blacklist}" == "" ] && [ "${grep_white_ip}" == "" ];then   
   if [ "$bip" == "" ] ; then
#                      echo 4
###判断过滤出来的ip的国家是在白名单里面如果在就跳过，没有则进行下一个选择  
                      
     if [ "${grep_country}" != "" ] ; then
         if [ "${grep_city}" == "" ]; then
           iptables -A OUTPUT -d ${aip}  -j DROP
         fi
         else
         iptables -A OUTPUT -d ${aip}  -j DROP
         fi
        
      else
      if [ "$grep_country" != "" ] && [ "${grep_city}" != "" ]; then
      iptables -D OUTPUT -d ${aip}  -j DROP
      fi
   fi
fi
done

###删除all_ip_info,和ip_blacklist都没有的iptables却存在的条目
for f in $(iptables -L OUTPUT  -n | awk  'NR>2 {print $5}');do
#     echo $f
   tab_ip_blacklist=$( cat ./ip_blacklist | grep -Fx $f)
   tab_ip_all_ip=$( cat ./all_ip_info | awk -F"_" '{ print $1 }'| awk -F'"' '{print $4}'| grep -Fx $f)
   if [ "$tab_ip_blacklist" == "" ]   && [ "$tab_ip_all_ip" == "" ];then
#    echo ok
   iptables -D OUTPUT -d $f  -j DROP
   fi
done


all_time=1
clean=$(cat ./files_tatus | grep my_history_all_ip_info)
if [ "${clean}" !=  ""  ];then
clean1_time=$(cat ./files_tatus | awk -F"=" '{print $2}')
now_time=$(date +%s)
change_time=$(expr ${now_time} - ${clean1_time})
#echo $change_clean1_time
change_now_time=$(expr ${change_time} / 3600  )
#echo $change_now_time
#echo ${all_time}
     if [ ${change_now_time} -ge  ${all_time} ];then
     for h in $(cat ./history_all_ip_info);do
     mynumber1=${#h}
#     echo $h
#     echo $mynumber1
     [ ${mynumber1} -lt 70 ]  &&   sed -i  "/$h/d" ./history_all_ip_info
     done
     echo my_history_all_ip_info=$(date +%s) > ./files_tatus
     fi

else
#echo 没有信息
echo my_history_all_ip_info=$(expr $(date +%s) - 3600 ) > ./files_tatus
fi


#测试脚本运行时间2
##echo time2=$(date +%s)
##最层循环
sleep 5
done


