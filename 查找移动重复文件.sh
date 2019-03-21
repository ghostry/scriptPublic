#!/bin/bash
#从$1移动重复文件到$2
fdupes -fr $1 | xargs -I '{}' mv '{}' $2
