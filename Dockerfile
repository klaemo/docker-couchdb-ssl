FROM klaemo/couchdb:debian

MAINTAINER Clemens Stolle klaemo@fastmail.fm

RUN apt-get update && apt-get install -y openssl curl libev4 libssl-dev libev-dev
RUN mkdir /usr/src/stud && \
  cd /usr/src/stud && \
  curl -kL# https://github.com/bumptech/stud/archive/master.tar.gz | tar zx --strip 1 && \
  make && make install && \
  rm -r /usr/src/stud

# cleanup
RUN apt-get purge binutils cpp cpp-4.7 gcc gcc-4.7 libssl-dev libev-dev -y && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* 

ADD stud.conf /usr/local/etc/stud/
ADD generate-pem /root/
ADD entrypoint-stud.sh /
ADD stud-config /opt/

RUN /root/generate-pem
RUN /opt/stud-config

EXPOSE 6984
ENTRYPOINT ["/entrypoint-stud.sh"]

