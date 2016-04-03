FROM debian:jessie

EXPOSE 8080

RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list; \
apt-key adv --keyserver keys.gnupg.net --recv-keys 2A194991; \
apt-get update; \
apt-get install aptly curl bzip2 gnupg wget graphviz -y --force-yes; \
wget --quiet http://mirror.as24220.net/pub/ubuntu-archive/pool/main/z/zeitgeist/zeitgeist_0.9.0-1_all.deb -O /tmp/zeitgeist_0.9.0-1_all.deb

ADD ./test/fixtures/aptly.conf /etc/aptly.conf

RUN aptly repo create testrepo
RUN aptly repo add testrepo /tmp/zeitgeist_0.9.0-1_all.deb

CMD /usr/bin/aptly api serve
