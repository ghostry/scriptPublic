#!/bin/bash
#
# 将当前目录下的所有文件名全部转换为小写. 
#
list_alldir(){
    for file in $1/*
    do
  fname=`basename "$file"` 
  n=`echo "$fname" | tr A-Z a-z`  # 将名字修改为小写. 
	#echo "$1/$fname   $1/$n"
  if [ "$fname" != "$n" ]       # 只对那些文件名不是小写的文件进行重命名. 
  then
	echo "raname $1/$fname to $1/$n"
    mv "$1/$fname" "$1/$n"
  fi
	if [ "$n" == "thumbs.db" ];then
echo "rm -f $1/$n";
rm "$1/$n";
fi
    if [ -d "$file" ]; then
    #echo $file
    list_alldir "$file"    #在这里递归调用
    fi
    done
    }
if [ $# -gt 0 ]
    then
    list_alldir "$1"
    else
    list_alldir "."
    fi
