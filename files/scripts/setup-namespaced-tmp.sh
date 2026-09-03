
# Setup polyinstanced /tmp
mkdir -m 000 /tmp-inst
mkdir -m 000 /var/tmp/tmp-inst

chcon --reference /tmp /tmp-inst
chcon --reference /var/tmp /var/tmp/tmp-inst

cat /usr/share/ublue-os/namespaces/temp-namespace.conf >> /etc/security/namespace.conf