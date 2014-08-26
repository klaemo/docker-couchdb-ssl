#!/bin/bash

chmod 664 /usr/local/etc/stud/*.conf
chmod 600 /usr/local/etc/stud/stud.pem

gosu _stud stud --daemon --config /usr/local/etc/stud/stud.conf

/entrypoint.sh couchdb