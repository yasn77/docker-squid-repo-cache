FROM ubuntu:14.04
MAINTAINER Yasser Nabi "yassersaleemi@gmail.com"
ENV CACHE_ANY true
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 2812 8000
VOLUME ["/var/cache/squid-deb-proxy"]

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
        apt-get update && \
        apt-get -y install \
            monit \
            squid-deb-proxy

ADD ./monit.d/ /etc/monit/conf.d/
ADD ./start.sh /start.sh
ADD ./additional_mirror_dstdomain.acl /etc/squid-deb-proxy/mirror-dstdomain.acl.d/99-additional_mirror_dstdomain

# Cache RPM
RUN echo 'refresh_pattern rpm$   129600 100% 129600' >> \ 
      /etc/squid-deb-proxy/squid-deb-proxy.conf

ENTRYPOINT ["/bin/bash", "/start.sh"]
