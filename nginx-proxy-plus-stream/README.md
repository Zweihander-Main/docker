# Nginx-proxy plus stream support

[jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy) plus very basic support for the [stream module](https://nginx.org/en/docs/stream/ngx_stream_core_module.html).

Also includes increase of max upload size to 10G, particularly useful for Nextcloud installations.

### Example configuration

```
docker run -d \
--name nginx-proxy \
-v /var/run/docker.sock:/tmp/docker.sock:ro \
-v /etc/nginx/conf.d:/etc/nginx/conf.d \
-p 11112:11112/tcp \
-p 443:443/tcp \
-p 80:80/tcp \
 zweizs/docker-nginx-proxy-plus-stream
 ```

Any config files added to /etc/nginx/conf.d ending in `.stream` will be picked up.

Example config for ZNC with the Let's Encrypt companion app:

 `/etc/nginx/conf.d/znc.example.com.stream`
 ```
 upstream znc {
        server 172.20.0.3:11111;
}

server {
        listen 11112 ssl;

        ssl_session_timeout 5m;
        ssl_session_tickets off;
        ssl_certificate /etc/nginx/certs/znc.example.com.crt;
        ssl_certificate_key /etc/nginx/certs/znc.example.com.key;
        ssl_dhparam /etc/nginx/certs/znc.example.com.pem;
        ssl_trusted_certificate /etc/nginx/certs/znc.example.com.pem;

        proxy_pass znc;
}
```

This would allow you to connect to an SSL ZNC IRC port at znc.example.com:11112 which talked to a non-SSL ZNC IRC port internally located at 172.20.0.3:11111. ZNC should then be configured with two ports: 11111 without SSL for IRC and a second port without SSL for the HTTP interface. Set the second port as the VIRTUAL_PORT for the normal nginx-proxy behaviour to pick it up and proxy it.



## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[MIT](./LICENSE)

