#!/bin/bash

MONIT_PASSWD=$(openssl rand -base64 6)
echo MONIT_PASSWORD=${MONIT_PASSWD}

groupadd monit
sed -e "s/__MONIT_PASSWD__/$MONIT_PASSWD/" -i /etc/monit/conf.d/enable_monit_webserver

sed -e 's/\(session.*pam_loginuid.so\)/\# \1/' -i /etc/pam.d/sshd

if [ "${CACHE_ANY}" == 'true' ]
then
  sed -e 's/^#\([cache\|http_access allow].*to_archive_mirrors$\)/\1/' -i /etc/squid-deb-proxy/squid-deb-proxy.conf
fi

echo ${EXTRA_MIRROR_DSTDOMAIN} | tr ' ' '\n' >> /etc/squid-deb-proxy/mirror-dstdomain.acl.d/10-default
echo ${ALLOWED_NETWORKS} | tr ' ' '\n' >> /etc/squid-deb-proxy/allowed-networks-src.acl.d/10-default
echo ${PKG_BLACKLIST} | tr ' ' '\n' >> /etc/squid-deb-proxy/pkg-blacklist.d/10-default

/usr/bin/monit -I -g monit -v
