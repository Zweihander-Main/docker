FROM php:8.2-cli-alpine
COPY bin/index.php /data/index.php
WORKDIR /data
EXPOSE 8080
CMD [ "php", "-S", "0.0.0.0:8080" ]
