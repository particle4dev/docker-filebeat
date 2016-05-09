FROM ubuntu:14.04
MAINTAINER cityme <particle4dev@gmail.com>

# Update repositories lists and install required tools and libraries
RUN apt-get update; apt-get upgrade -y; apt-get clean
RUN apt-get install -y wget curl git tree vim htop strace build-essential libpcre3 libpcre3-dev libstdc++6-4.7-dev libssl-dev

ENV FILEBEAT_VERSION 1.0.1
ENV FILEBEAT_SHA1 e64858982da59721f4cb42c720faa3fff6ed937d

ADD https://download.elastic.co/beats/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64.tar.gz /tmp/filebeat.tar.gz

RUN echo "${FILEBEAT_SHA1}  /tmp/filebeat.tar.gz" > /tmp/filebeat.sha1 && \
    sha1sum -c /tmp/filebeat.sha1 && \
    mkdir -p /usr/src/filebeat && \
    mkdir -p /etc/filebeat && \
    tar zxvf /tmp/filebeat.tar.gz -C /usr/src/filebeat && \
    cp /usr/src/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64/filebeat /bin && \
    cp /usr/src/filebeat/filebeat-${FILEBEAT_VERSION}-x86_64/filebeat.yml /etc/filebeat && \
    rm -rf /tmp/filebeat.tar.gz /tmp/filebeat.sha1

ENTRYPOINT ["/bin/filebeat", "-e", "-v", "-c", "/etc/filebeat/filebeat.yml"]
