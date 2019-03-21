#!/bin/bash
#删除.svn文件夹
find . -type d -iname '.svn' -exec rm -rf {} \;
