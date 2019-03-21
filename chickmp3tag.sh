#!/bin/bash
#mp3标签编码转gbk
find . -iname "*.mp3" -execdir mid3iconv -e GBK {} \;
