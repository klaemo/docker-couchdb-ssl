FROM klaemo/couchdb:latest

MAINTAINER Clemens Stolle klaemo@fastmail.fm

RUN apt-get update && apt-get install -y openssl make curl libev4 libssl-dev libev-dev \
  && mkdir /usr/src/stud && cd /usr/src/stud \
  && curl -sSL# https://github.com/bumptech/stud/archive/master.tar.gz | tar zx --strip 1 \
  && make && make install \
  && rm -r /usr/src/stud \
  && apt-get purge binutils make cpp gcc libssl-dev libev-dev -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* 

ADD stud.conf /usr/local/etc/stud/
ADD generate-pem /root/
ADD entrypoint-stud.sh /
ADD stud-config /opt/

RUN /root/generate-pem
RUN /opt/stud-config

EXPOSE 6984
ENTRYPOINT ["/entrypoint-stud.sh"]

