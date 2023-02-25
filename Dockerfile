# Set alpine version
ARG ALPINE_VERSION=3.15.7

# Build
FROM alpine:${ALPINE_VERSION}

ENV ADMINER_VERSION=4.8.1
ENV ADMINER_FLAVOUR=-en

WORKDIR /server

RUN	addgroup -S adminer && \
    adduser -S -G adminer adminer && \
    chown -R adminer:adminer /server && \
    apk add --no-cache \
      curl \
      php7 \
      php7-opcache \
      php7-pdo \
      php7-pdo_mysql \
      php7-pdo_odbc \
      php7-pdo_pgsql \
      php7-pdo_sqlite \
      php7-session && \
    curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}${ADMINER_FLAVOUR}.php -o index.php && \
    apk del curl && \
    rm -rf /var/cache/apk/*

EXPOSE 8080

CMD /usr/bin/php \
    -d upload_max_filesize=2048M \
    -d post_max_size=2048M \
    -S 0.0.0.0:8080 \
    -t /server
