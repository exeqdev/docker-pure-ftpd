#!/bin/bash

#get external IP for passive
dig +short myip.opendns.com @resolver1.opendns.com | tee /etc/pure-ftpd/conf/ForcePassiveIP

#get flags from configuration wrapper
PURE_FTPD_FLAGS="$(/usr/sbin/pure-ftpd-wrapper -s)"
PURE_FTPD_FLAGS=${PURE_FTPD_FLAGS}


# start rsyslog
if [[ "$PURE_FTPD_FLAGS" == *" -d "* ]] || [[ "$PURE_FTPD_FLAGS" == *"--verboselog"* ]]
then
    echo "Start rsyslogd"
    rsyslogd
fi


# process options custom
PUREOPTS="0146ABDEGHKMNRWXZbdeijorswxz8:9:C:D:I:J:L:O:P:Q:S:T:U:V:Y:a:c:f:k:m:n:p:q:t:u:y:"
while getopts ${PUREOPTS} FLAG ${PURE_FTPD_FLAGS} ; do
  case $FLAG in
    l)   #regenerate pdb files from passwd if exists
      if [[ "$OPTARG" =~ ^puredb:.*pdb$ ]];then
         pdb=${OPTARG#puredb:}
         passwd=${pdb/%.pdb/.passwd}
         if [[ -e "${passwd}" }}; then
           /usr/bin/pure-pw mkdb ${pdb} -f ${passwd}
         fi         
      fi
      ;;
  esac
done

# let users know what flags we've ended with (useful for debug)
echo "Starting Pure-FTPd:"
echo "  pure-ftpd $PURE_FTPD_FLAGS"

# start pureftpd
exec /usr/sbin/pure-ftpd $PURE_FTPD_FLAGS 
