#!/usr/bin/env bash

LOCAL_USER=$1
SERVER=$2
SERVER_USER=$3
SERVER_PASSWORD=$4

apt install davfs2
usermod -aG davfs2 $LOCAL_USER
mkdir /home/$LOCAL_USER/Documents/Notes
mkdir /home/$LOCAL_USER/.davfs2

# fill davfs2-secrets
cat << EOF > /home/$LOCAL_USER/.davfs2/secrets
https://$SERVER:1443/ $SERVER_USER $SERVER_PASSWORD
EOF
chmod 600 /home/$LOCAL_USER/.davfs2/secrets
chown $LOCAL_USER:$LOCAL_USER /home/$LOCAL_USER/.davfs2/secrets

# fill davfs2-conf
cat << EOF >> /home/$LOCAL_USER/.davfs2/davfs2.conf
[/home/$LOCAL_USER/Documents/Notes]
use_locks       0
trust_ca_cert   notes.crt
EOF

# add an entry to fstab
cat << EOF >> /etc/fstab
https://$SERVER:1443/ /home/$LOCAL_USER/Documents/Notes davfs rw,user,uid=$LOCAL_USER,noauto 0 0
EOF

systemctl daemon-reload
