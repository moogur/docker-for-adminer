# Set global environment
ARG ALPINE_VERSION=3.15.7
ARG ADMINER_VERSION=4.8.1
ARG ADMINER_FLAVOUR="-en"

# Build
FROM alpine:${ALPINE_VERSION}

WORKDIR /var/adminer

RUN	addgroup -S adminer && \
    adduser -S -G adminer adminer && \
    chown -R adminer:adminer /var/adminer && \
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
    curl -L https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}${ADMINER_FLAVOUR}.php -o adminer.php && \
    apk del curl && \
    rm -rf /var/cache/apk/*

EXPOSE 8080

CMD /usr/bin/php \
    -d upload_max_filesize=2048M \
    -d post_max_size=2048M \
    -S 0.0.0.0:8080 \
    -t /var/adminer
