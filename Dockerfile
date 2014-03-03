FROM klaemo/couchdb

MAINTAINER Clemens Stolle klaemo@fastmail.fm

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl libev4 libssl-dev libev-dev
RUN (mkdir /tmp/stud && cd /tmp/stud && curl -L# https://github.com/bumptech/stud/archive/master.tar.gz | tar zx --strip 1 && make && make install && rm -rf /tmp/stud)

ADD stud.conf /usr/local/etc/stud/
ADD generate-pem /root/
ADD start /opt/
ADD stud-config /opt/

RUN ./root/generate-pem
RUN ./opt/stud-config

EXPOSE 6984
CMD ["/opt/start"]

