FROM ubuntu:14.04

MAINTAINER Manel Martinez <manel@nixelsolutions.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install curl apt-transport-https supervisor

RUN curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add -
RUN echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0" >> /etc/apt/sources.list.d/varnish-cache.list

RUN apt-get update && \
    apt-get -y install varnish

ENV BACKEND_SERVERS **ChangeMe**
ENV BACKEND_PORT 80
ENV MAX_CACHE_SIZE 256M
ENV HTTP_PORT 80

ENV DEBUG 0

EXPOSE ${HTTP_PORT}

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /usr/local/bin
ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh
ADD ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./etc/varnish/default.vlc /etc/varnish/template.vlc

CMD ["/usr/local/bin/run.sh"]
