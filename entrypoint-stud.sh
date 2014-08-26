#!/bin/bash
set -e;

chown _stud: /usr/local/etc/stud/stud.pem
chown _stud: /var/run/stud
chown -R _stud: /usr/local/var/run/stud /usr/local/etc/stud
chmod 0770 /usr/local/var/run/stud

chmod 664 /usr/local/etc/stud/*.conf
chmod 600 /usr/local/etc/stud/stud.pem

gosu _stud stud --daemon --config /usr/local/etc/stud/stud.conf

/entrypoint.sh couchdb