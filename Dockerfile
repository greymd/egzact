FROM phusion/baseimage:latest
MAINTAINER Yamada, Yasuhiro <yamadagrep@gmail.com>
ENV DEBFULLNAME="Yamada, Yasuhiro" DEBEMAIL=yamadagrep@gmail.com DEBIAN_FRONTEND=noninteractive

RUN curl --retry 3 -sfSLO https://github.com/greymd/egzact/releases/download/v2.0.0/egzact-2.0.0.deb && \
    curl --retry 3 -sfSLO https://github.com/egison/egison-package-builder/releases/download/4.0.0/egison-4.0.0.x86_64.deb

RUN dpkg -i egzact-2.0.0.deb && \
    dpkg -i egison-4.0.0.x86_64.deb

RUN rm -f egzact-2.0.0.deb && \
    rm -f egison-4.0.0.x86_64.deb && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
