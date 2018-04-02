# This script checks some configs and tries to overwrite some items if required
# These configs are checked:
# /etc/default/iptables.conf: Check if port 22 is disabled, if so, enable port 22 and port 80
#  /HCBv2/etc/qmf_release.xml: Check if defaultEntry is wrong in hcb_web node, if so, change to /HCBv2/www and disable whitelist

#!/bin/sh

SSH_COMMENTED=`egrep "#-A .* --dport 22 .*" /etc/default/iptables.conf`

if [ "$SSH_COMMENTED" ]
then
        echo "SSH was commented, enabling it and restarting iptable"
        # Replace commented line and make backup of iptables file
        cp /etc/default/iptables.conf /etc/default/iptables.conf.bak
        sed -i "s/\(#\)\(-A.*--dport 22 .*\)/\2/g" /etc/default/iptables.conf
        sed -i "s/\(#\)\(-A.*--dport 80 .*\)/\2/g" /etc/default/iptables.conf
        # Restart iptables
        /etc/init.d/iptables restart
fi

HCB_WEB_DISABLED=`egrep "<defaultEntry>/hdrv_zwave/</defaultEntry>" /HCBv2/etc/qmf_release.xml`

if [ "$HCB_WEB_DISABLED" ]
then
        echo "HCB web disabled, enabling it and killing lighthttpd"
        # Replace commented line and make backup of iptables file
        cp /HCBv2/etc/qmf_release.xml /HCBv2/etc/qmf_release.xml.backup
	sed -i "s/<defaultEntry>\/hdrv_zwave\/<\/defaultEntry>/<defaultEntry>\/HCBv2\/www\/<\/defaultEntry>/g" /HCBv2/etc/qmf_release.xml
	sed -i "s/<enforceWhitelist>1<\/enforceWhitelist>/<enforceWhitelist>0<\/enforceWhitelist>/g" /HCBv2/etc/qmf_release.xml

        # Kill current lighthttpd process, the inittab will restart it automatically
	kill $(ps | grep -i lighttpd.conf | head -n 1 | awk '{print $1}')
fi
