FROM jwilder/nginx-proxy:alpine
MAINTAINER Zweihänder

COPY uploadsize-nginx-nextcloud-proxy.conf /etc/nginx/conf.d/uploadsize.conf

RUN echo "stream {" >> /etc/nginx/nginx.conf && \
    echo "    include /etc/nginx/conf.d/*.stream;" >> /etc/nginx/nginx.conf && \
    echo "}" >> /etc/nginx/nginx.conf
