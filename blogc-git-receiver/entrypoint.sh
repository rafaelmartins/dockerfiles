#!/bin/sh

set -eo pipefail


PUID=${PUID:-911}
PGID=${PGID:-911}

groupmod -o -g "$PGID" blogc
usermod -o -u "$PUID" blogc

ssh-keygen -A

mkdir -p /home/blogc/.ssh
chown -R blogc:blogc /home/blogc
chmod -R 755 /home/blogc
chmod 700 /home/blogc/.ssh/
if [ -e /home/blogc/.ssh/authorized_keys ]; then
    chmod 600 /home/blogc/.ssh/authorized_keys
else
    echo "WARNING: No SSH authorized_keys found for blogc"
fi

exec "$@"
