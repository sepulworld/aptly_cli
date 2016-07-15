FROM ubuntu:trusty

EXPOSE 8080

RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list; \
apt-key adv --keyserver keys.gnupg.net --recv-keys 2A194991; \
apt-get update; \
apt-get install aptly curl xz-utils bzip2 gnupg wget graphviz -y --force-yes; \
wget --quiet http://mirror.as24220.net/pub/ubuntu-archive/pool/main/z/zeitgeist/zeitgeist_0.9.0-1_all.deb -O /tmp/zeitgeist_0.9.0-1_all.deb; \
wget --quiet http://mirror.as24220.net/pub/ubuntu-archive/pool/main/z/zsh/zsh_5.1.1-1ubuntu1_i386.deb -O /tmp/zsh_5.1.1-1ubuntu1_i386.deb

ADD ./fixtures/aptly.conf /etc/aptly.conf

RUN aptly repo create testrepo
RUN aptly repo create testrepo20
RUN aptly repo add testrepo /tmp/zeitgeist_0.9.0-1_all.deb
RUN aptly repo add testrepo20 /tmp/zsh_5.1.1-1ubuntu1_i386.deb

CMD /usr/bin/aptly api serve
