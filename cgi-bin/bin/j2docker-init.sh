#!/bin/sh

# reduce selinux
setenforce 0

# wait for docker service to be up before opening firewall ports

SERVICECHK=$(systemctl is-active docker)
while [[ "${SERVICECHK}" != "active" ]]
do
	sleep 1
	SERVICECHK=$(systemctl is-active docker)
done
unset SERVICECHK

. /var/www/cgi-bin/bin/config.sh
. /var/www/cgi-bin/bin/networking.sh
. /var/www/cgi-bin/tmp/globals
[[ "$SCRIPTSDIR" == "" ]] && SCRIPTSDIR=/mnt/hgfs && write_global SCRIPTSDIR
[[ "$OUTDIR" == "" ]] && OUTDIR=$(ls -al /mnt/hgfs|grep -e "^d"|grep -v -e "\.$"|head -1|rev|cut -d " " -f1|rev) && write_global OUTDIR
# get username and pass
if [[ -f /tmp/creds.sh ]]
then
        . /tmp/creds.sh
	write_global J2USER
	write_global J2PASS
fi

