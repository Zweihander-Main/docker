# 

> 

## Notes



## Instructions
```
```


#### Sample configuration with [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy)

Assuming a container with the `VIRTUAL_HOST` variable set to `tellico.virtual.host.com`:

1.   On a machine with `apache2-utils` installed, run `htpasswd -c tellico.virtual.host.com username` and pick a password.

2.   Copy the `tellico.virtual.host.com` file generated to the `/path/to/htpasswd` directory.

3.   Run:
```
docker run -d -p 80:80 -p 443:443 \
    -v /path/to/htpasswd:/etc/nginx/htpasswd \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    jwilder/nginx-proxy
```

## Links

-   [GitHub]()
-   [Docker Hub]()

## Dev notes:
- Github Action creates build with Docker tag based on Git semver tag

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[MIT](./LICENSE)
