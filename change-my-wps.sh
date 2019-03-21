#!/bin/bash
#输入法设置
istrue=$(grep 'export XIM="fcitx"' /usr/bin/wpp)
if [ ! -n "$istrue" ]; then
        sudo sed -i '/\#\!\/bin\/bash/a\export XIM="fcitx"\nexport XIM_PROGRAM="fcitx"\nexport XMODIFIERS="@im=fcitx"\nexport GTK_IM_MODULE="fcitx"\nexport QT_IM_MODULE="fcitx"' /usr/bin/wpp
fi
istrue=$(grep 'export XIM="fcitx"' /usr/bin/wps)
if [ ! -n "$istrue" ]; then
        sudo sed -i '/\#\!\/bin\/bash/a\export XIM="fcitx"\nexport XIM_PROGRAM="fcitx"\nexport XMODIFIERS="@im=fcitx"\nexport GTK_IM_MODULE="fcitx"\nexport QT_IM_MODULE="fcitx"' /usr/bin/wps
fi
istrue=$(grep 'export XIM="fcitx"' /usr/bin/et)
if [ ! -n "$istrue" ]; then
        sudo sed -i '/\#\!\/bin\/bash/a\export XIM="fcitx"\nexport XIM_PROGRAM="fcitx"\nexport XMODIFIERS="@im=fcitx"\nexport GTK_IM_MODULE="fcitx"\nexport QT_IM_MODULE="fcitx"' /usr/bin/et
fi
