#!/bin/bash
find -type f|while read name;do 
#name=$1;
ext=$(echo "$name"|awk -F '.' '{print $NF}');
newname=$(exif -m $name|grep Date|grep Original|awk '{gsub(":","-",$5);gsub(":","",$6); printf("%s_%s",$5,$6)}');
echo "mv $name to $newname.$ext ";
mv $name $newname.$ext;
done
