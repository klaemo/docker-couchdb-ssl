# Dockerized CouchDB with nginx SSL terminator

Make your CouchDB a straight A SSL student!

**NOTE**: This image uses [nginx](http://nginx.org/) to provide the SSL/TLS endpoint.  CouchDB's SSL features are unused.

Version: `CouchDB 1.6.1` and `nginx 1.9.9`.

## Run

Available in the docker index as [klaemo/couchdb-ssl](https://index.docker.io/u/klaemo/couchdb-ssl/)
based on [klaemo/couchdb](https://index.docker.io/u/klaemo/couchdb/)

__Note:__ Out of the box bogus self-signed certificates are being used.
You should replace them with your real files (see below).

```bash
$ [sudo] docker pull klaemo/couchdb-ssl:latest

# expose it to the world on port 6984
$ [sudo] docker run -d -p 6984:6984 --name couchdb klaemo/couchdb-ssl

$ curl -k https://localhost:6984
```

## Features

* exposes couchdb on port `6984` (https) of the container
* runs everything as non-root user (security ftw!)
* nginx is configured with a list of preferable cipher suites (more security win!!11)

Your CouchDB will get a __straight A__ on the [SSL Labs Server Test](https://www.ssllabs.com/ssltest/)!

## Build your own

You can use `klaemo/couchdb-ssl` as the base image for your own couchdb instance.
You might want to provide your own version of the following files:

* `local.ini` for CouchDB.
* `nginx.conf` for nginx configuration.
* `server.crt` for nginx configuration (certificate).
* `server.key` for nginx configuration (private key).
* `dhparams.pem` for nginx configuration (diffie-helman parameters).
* `chain.pem` for nginx configuration (all three above combined).

Example Dockerfile:

```bash
FROM klaemo/couchdb-ssl

COPY local.ini /usr/local/etc/couchdb/
COPY nginx.conf /etc/nginx/
COPY server.crt /etc/nginx/certs/
COPY server.key /etc/nginx/certs/
COPY dhparams.pem /etc/nginx/certs/
COPY chain.pem /etc/nginx/certs/
```

and then build and run it

```bash
$ [sudo] docker build -t you/awesome-couchdb .
$ [sudo] docker run -d -p 5984:5984 -p 6984:6984 you/awesome-couchdb
```

et voilá you have your own CouchDB instance with SSL support on port 6984.

### Generate self-signed certificate

[Heroku - Creating a Self-Signed SSL Certificate](https://devcenter.heroku.com/articles/ssl-certificate-self)

```bash
$ openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
$ openssl rsa -passin pass:x -in server.pass.key -out server.key
writing RSA key
$ rm server.pass.key
$ openssl req -new -key server.key -out server.csr
...
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
...
A challenge password []:
...
$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
Signature ok
subject=/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd/CN=localhost
Getting Private key
```

### Generate strong Diffie-Helman parameters

```bash
$ openssl dhparam -out dhparams.pem 2048
```

**NOTE**: For higher key size negotiation, you may wish to create a 4096 bit dhparams file.  Just change the number above.

### Concatenate to chain.pem

The `chain.pem` file contains your SSL key, certificates and DH parameters.

Specifically, the following information:
* The server's private key
* The server's certificate (signing its private key)
* (Optionally) Intermediate certificates
* (Optionally, recommended) DH parameters

To create the PEM file, use something similar to the following:

```sh
$ cat server.key server.crt [intermediate_cert1.pem ...] dhparams.pem > chain.pem
```

## Credits

* thanks @dscape for [this article](https://medium.com/code-adventures/35c45ce2a814)
* [hynek.me](https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/)
* [mozilla](https://wiki.mozilla.org/Security/Server_Side_TLS) for the resources on SSL/TLS configuration

## Contributors

* [Mirco Zeiss](https://github.com/zemirco)
