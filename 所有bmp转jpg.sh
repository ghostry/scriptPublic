#!/bin/bash
find |grep ".bmp$"|while read name ; do   convert "$name" "${name%???}jpg";rm "$name";done
