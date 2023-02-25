# Set alpine version
ARG ALPINE_VERSION=3.16.4

# Build
FROM alpine:${ALPINE_VERSION}

ENV ADMINER_VERSION=4.8.1
ENV ADMINER_FLAVOUR=-en

WORKDIR /server

RUN	addgroup -S adminer && \
    adduser -S -G adminer adminer && \
    chown -R adminer:adminer /server && \
    echo '@community http://nl.alpinelinux.org/alpine/v3.14/community' >> /etc/apk/repositories && \
    apk add --no-cache \
      curl \
      php8@community \
      php8-session@community \
      php8-mysqli@community \
      php8-pgsql@community \
      php8-json@community \
      php8-pecl-mongodb@community \
    curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}${ADMINER_FLAVOUR}.php -o index.php && \
    ln -s /usr/bin/php8 /usr/bin/php && \
    apk del curl && \
    rm -rf /var/cache/apk/*

EXPOSE 8080

CMD /usr/bin/php \
    -d upload_max_filesize=2048M \
    -d post_max_size=2048M \
    -S 0.0.0.0:8080 \
    -t /server
