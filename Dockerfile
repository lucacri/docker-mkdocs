FROM lucacri/alpine-base:3.13

LABEL maintainer="lucacri@gmail.com"

RUN apk upgrade --update-cache && \
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

ADD build.sh /build.sh
ADD serve.sh /serve.sh

RUN chmod 777 /serve.sh

ONBUILD ADD . /docs
ONBUILD RUN bash /build.sh


