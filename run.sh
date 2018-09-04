#!/bin/bash

#get external IP for passive
dig +short myip.opendns.com @resolver1.opendns.com | tee /etc/pure-ftpd/conf/ForcePassiveIP
#echo localhost | tee /etc/pure-ftpd/conf/ForcePassiveIP

#get flags from configuration wrapper
PURE_FTPD_FLAGS="$(/usr/sbin/pure-ftpd-wrapper -s)"

# let users know what flags we've ended with (useful for debug)
echo "Starting Pure-FTPd:"
echo "  pure-ftpd $PURE_FTPD_FLAGS"

# start pureftpd
rsyslogd
exec /usr/sbin/pure-ftpd $PURE_FTPD_FLAGS -d -d
