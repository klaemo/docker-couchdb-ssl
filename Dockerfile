FROM klaemo/couchdb

MAINTAINER Clemens Stolle klaemo@fastmail.fm

RUN apt-get update && apt-get install -y curl libev4 libssl-dev libev-dev
RUN (mkdir /tmp/stud && cd /tmp/stud && curl -L# https://github.com/bumptech/stud/archive/master.tar.gz | tar zx --strip 1 && make && make install && rm -rf /tmp/stud)

# cleanup
RUN apt-get remove -y curl && \
 apt-get autoremove -y && apt-get clean -y && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD stud.conf /usr/local/etc/stud/
ADD generate-pem /root/
ADD start /opt/
ADD stud-config /opt/

RUN ./root/generate-pem
RUN ./opt/stud-config

EXPOSE 6984
CMD ["/opt/start"]

