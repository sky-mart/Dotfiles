#!/usr/bin/env sh

mkdir /tmp/docs && \
    sshfs ftpvlad@h3007161.stratoserver.net:/home/ftpvlad /tmp/docs && \
    restic backup -r ~/backups/docs -e "\.*" /tmp/docs && \
    fusermount -u /tmp/docs
