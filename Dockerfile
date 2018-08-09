FROM lucacri/alpine-base:3.7.1

LABEL maintainer="lucacri@gmail.com"

RUN apk upgrade --update-cache && \
    apk update && \
    apk add bash python3 && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip install --upgrade pip && \
    pip3 install mkdocs && \
    rm -rf /var/cache/apk/* && \
    mkdir /docs && \
    mkdir /site

ADD build.sh /build.sh

ONBUILD ADD . /docs
ONBUILD RUN bash /build.sh


