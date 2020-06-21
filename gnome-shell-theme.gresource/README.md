# 修改Ubuntu 20.04 登陆界面

该脚本工具会从 `Yaru` 主题复制出一个新主题 `mytheme` 并安装使用

1. cd到当前目录,执行`./1.extractgst.sh`
2. 在`gnome-shell-theme`目录中进行一些修改,比如修改背景,`gdm3.css`中的`#lockDialogGroup{...}`修改为`#lockDialogGroup{background-color:rgba(27,106,203,0.3);background-image:url('background.png');background-position:center;background-repeat:no-repeat;background-size:cover;background-attachment:fixed;}`,并且放置`background.png`到`gnome-shell-theme`
3. 执行`2.create.gnome-shell-theme.gresource.sh`
4. 执行`3.install.sh`,查看是否选中了 `/usr/share/gnome-shell/theme/mytheme/gnome-shell-theme.gresource`,如果选中,直接回车,没选中手动选下.
