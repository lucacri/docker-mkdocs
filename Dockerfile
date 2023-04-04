FROM python:3-alpine3.17

LABEL maintainer="lucacri@gmail.com"
COPY files/start.sh /start.sh
COPY files/build.sh /build.sh
COPY files/serve.sh /serve.sh
COPY files/my-entrypoint.d /my-entrypoint.d/

RUN  mkdir -p /my-entrypoint.d/ && \
    chmod +x /start.sh && \
    chmod +x /build.sh && \
    chmod +x /serve.sh && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.17/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.17/main" >> /etc/apk/repositories && \
    apk upgrade --update-cache && \
    apk update && \
    apk add --no-cache bash\
    python3 \
    pkgconfig \
    git \
    gcc \
    openldap \
    libcurl \
    python3-dev \
    gpgme-dev \
    libc-dev \
    py3-pip \
    bash && \
    pip install --upgrade pip && \
    pip3 install mkdocs && \
    rm -rf /var/cache/apk/* && \
    mkdir /docs && \
    mkdir /site

ONBUILD ADD . /docs
ONBUILD RUN bash /build.sh


