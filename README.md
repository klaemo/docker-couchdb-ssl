Dockerized CouchDB with stud SSL terminator
===

Version: `CouchDB 1.5.0` and `stud 0.3`

## Run

Available in the docker index as [klaemo/couchdb-ssl](https://index.docker.io/u/klaemo/couchdb-ssl/)
based on [klaemo/couchdb](https://index.docker.io/u/klaemo/couchdb/)

__Note:__ Out of the box bogus self-signed certificates are being used (see `generate-pem`).
You should replace them with your real pem file (see below).

```bash
[sudo] docker pull klaemo/couchdb-ssl

# expose it to the world on port 6984
[sudo] docker run -d -p 6984:6984 -name couchdb klaemo/couchdb-ssl

curl -k https://localhost:6984
```

## Features

* exposes couchdb on port `5984` (http) and `6984`(https) of the container
* runs everything as non-root user (security ftw!)
* keeps couchdb and stud running with `mon` (reliability ftw!)

## Build your own

You can use `klaemo/couchdb-ssl` as the base image for your own couchdb instance.
You might want to provide your own version of the following files:

* `local.ini` for CouchDB
* `stud.conf` for stud
* `stud.pem` is the (you guessed it) pem file.

Example Dockerfile:
```
FROM klaemo/couchdb-ssl

ADD local.ini /usr/local/etc/couchdb/
ADD stud.conf /usr/local/etc/stud/
ADD stud.pem /usr/local/etc/stud/
```

and then build and run it

```
[sudo] docker build -rm -t you/awesome-couchdb .
[sudo] docker run -d -p 5984:5984 -p 6984:6984 you/awesome-couchdb
```

et voilá you have your own CouchDB instance with SSL support on port 6984.

## Credits

* thanks @dscape for [this article](https://medium.com/code-adventures/35c45ce2a814)
