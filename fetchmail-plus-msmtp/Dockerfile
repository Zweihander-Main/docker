FROM cguenther/docker-fetchmail:latest

### Install Application
RUN apk --no-cache add ca-certificates msmtp su-exec \
    && rm -rf /var/cache/apk/*
