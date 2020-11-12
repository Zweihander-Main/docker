# Tellico Web

> A central instance of [Tellico](https://tellico-project.org/), accessible on any device

The purpose of this is to have a single source of truth for the collections of a single user accessible across all devices, regardless of operating system. If you're looking for a lean Tellico image accessible through your local X server or a multi-user setup, this isn't for you.

## Notes

-   This includes one volume at `/data` -- Tellico settings will automatically save here and it's recommended you save collections & external scripts in this folder as well.
-   noVNC is running on port 8080.
-   Image is pulling the Tellico binary from [Debian testing](https://packages.debian.org/testing/source/tellico)
-   Help does not work, the documentation can be found [here](https://docs.kde.org/trunk5/en/extragear-office/tellico/)
-   This is a HEAVY image as Tellico requires the KDE desktop environment.
-   [Ratpoison](https://www.nongnu.org/ratpoison/) is used as the window manager and [noVNC](https://novnc.com/info.html) as the web client. This allows the Tellico application to remain fullscreen and resize with your browser window.
-   **Security is your problem.** This image does not include any authentication so if this is accessible on a network, you will likely want to setup some kind of reverse proxy with authentication. See the sample configuration for nginx-proxy below.


## Instructions
```
docker run -d --name=tellico --publish=8080:8080 -v /path/to/tellico/data:/data zweizs/docker-tellico-web
```

Head on over to `http://localhost:8080/`, hit 'Connect', and enjoy.

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

-   [GitHub](https://github.com/Zweihander-Main/docker-tellico-web)
-   [Docker Hub](https://hub.docker.com/r/zweizs/docker-tellico-web)

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[MIT](./LICENSE)