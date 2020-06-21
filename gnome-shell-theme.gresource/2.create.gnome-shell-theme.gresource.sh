#!/bin/bash
# https://raw.githubusercontent.com/GNOME/gnome-shell/master/data/gnome-shell-theme.gresource.xml
tmpfile="/tmp/gnome-shell-theme.gresource.xml"
cd gnome-shell-theme
touch ${tmpfile}
echo '<?xml version="1.0" encoding="UTF-8"?>'>${tmpfile}
echo '<gresources>'>>${tmpfile}
echo '  <gresource prefix="/org/gnome/shell/theme">'>>${tmpfile}
for i in `find -type f`; do
    filename=${i:2}
    echo "    <file>${filename}</file>">>${tmpfile}
done
echo '  </gresource>'>>${tmpfile}
echo '</gresources>'>>${tmpfile}
mv ${tmpfile} gnome-shell-theme.gresource.xml
glib-compile-resources gnome-shell-theme.gresource.xml
mv gnome-shell-theme.gresource.xml ../
mv gnome-shell-theme.gresource ../
