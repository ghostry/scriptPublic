#!/bin/bash
find . -iname "*.mp3" -execdir mid3iconv -e GBK {} \; 
