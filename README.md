Dockerized CouchDB with stud SSL terminator
===

Make your CouchDB a straight A SSL student!

**NOTE**: This image uses [Stud](https://github.com/bumptech/stud) to provide the SSL/TLS endpoint.  CouchDB's SSL features are unused.

Version: `CouchDB 1.6.0` and `stud 0.3`

## Run

Available in the docker index as [klaemo/couchdb-ssl](https://index.docker.io/u/klaemo/couchdb-ssl/)
based on [klaemo/couchdb](https://index.docker.io/u/klaemo/couchdb/)

__Note:__ Out of the box bogus self-signed certificates are being used (see `generate-pem`).
You should replace them with your real pem file (see below).

```bash
[sudo] docker pull klaemo/couchdb-ssl:latest

# expose it to the world on port 6984
[sudo] docker run -d -p 6984:6984 --name couchdb klaemo/couchdb-ssl

curl -k https://localhost:6984
```

## Features

* exposes couchdb on port `6984`(https) of the container
* runs everything as non-root user (security ftw!)
* stud is configured with a list of preferable cipher suites (more security win!!11)

Your CouchDB will get a __straight A__ on the [SSL Labs Server Test](https://www.ssllabs.com/ssltest/)!

## Build your own

You can use `klaemo/couchdb-ssl` as the base image for your own couchdb instance.
You might want to provide your own version of the following files:

* `local.ini` for CouchDB.
* `stud.conf` for Stud configuration.
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
[sudo] docker build -t you/awesome-couchdb .
[sudo] docker run -d -p 5984:5984 -p 6984:6984 you/awesome-couchdb
```

et voilá you have your own CouchDB instance with SSL support on port 6984.

### stud.pem format
The `stud.pem` file contains your SSL key, certificates and DH parameters.

Specifically, the following information:
* The server's private key
* The server's certificate (signing its private key)
* (Optionally) Intermediate certificates
* (Optionally, recommended) DH parameters

If you don't provide one, an automatically generated file will be used, containing a self-signed certificate.

To create the PEM file, something similar to the following:
```sh
cat server_key.pem server_cert.pem [intermediate_cert1.pem ...] > stud.pem
```

To append some DH parameters:
```sh
openssl dhparam -rand - 1024 >> stud.pem
```

## Credits

* thanks @dscape for [this article](https://medium.com/code-adventures/35c45ce2a814)
* [hynek.me](https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/) and [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS) for the resources on SSL/TLS configuration
