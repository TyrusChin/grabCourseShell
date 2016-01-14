#!/bin/bash
# read -p "student number:" username
# stty -echo
# read -p "password:" password
# stty echo

if [ ! -d "./mypwd" ];then
    mkdir mypwd
    chmod 777 mypwd
fi

if [ ! "$1" ]||[ ! -f "$1" ]
then
    echo "param need for mypwd filename"
    exit 
fi

username=`head -n1 $1`
password=`tail -n1 $1`

file_name=$username"_"`date +%s`

# mkdir if not found
if [ ! -d "./cookie_file" ];then
    mkdir cookie_file
    chmod 777 cookie_file
fi
if [ ! -d "./course_json" ];then
    mkdir course_json
    chmod 777 course_json
fi
if [ ! -d "./log" ];then
    mkdir log
    chmod 777 log
fi

curl -c "./cookie_file/"$file_name".txt" -d "USERNAME=$username&PASSWORD=$password" http://jxgl.gdufs.edu.cn/jsxsd/xk/LoginToXkLdap
curl -b "./cookie_file/"$file_name".txt" "http://jxgl.gdufs.edu.cn/jsxsd/xsxk/xsxk_index?jx0502zbid=425DF1EBE9644E6297C4D54B3EAD7A93"
# curl -b "./cookie_file/"$file_name".txt" http://jxgl.gdufs.edu.cn/jsxsd/xsxkkc/xsxkXxxk > "./course_json/"$file_name".txt"

# sed -i 's/\r//g' "./course_json/"$file_name".txt" # 过滤^M

# python JsonProcess.py -i "./course_json/"$file_name".txt" -o "./course_json/"$file_name"_dump.txt"

echo "请选择需要选的课程编号："

# ruanjiangongcheng3 特别版
sed 's/20152016[0-9]*//g' "./ruanjiangongcheng3_dump.txt"

read line
declare -a cn

t=0
for i in $line
do
temp=`awk '$1 ~ "^'$i'、" {print $2}' "./ruanjiangongcheng3_dump.txt"`
cn[$t]=$temp
t=$(($t+1))
done

(date +%s) >> "log/"$file_name".log"
while true ; do
for item in ${cn[@]};do
    echo -n $item
    (curl -s -b "./cookie_file/"$file_name".txt" "http://jxgl.gdufs.edu.cn/jsxsd/xsxkkc/xxxkOper?jx0404id="$item) | tee -a "log/"$file_name".log"
done
#python -c "import time;time.sleep(0.02)"  # 限速
done
