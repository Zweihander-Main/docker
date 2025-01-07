# Tellico Web

> A central instance of [Tellico](https://tellico-project.org/), accessible on any device

The purpose of this is to have a single source of truth for the collections of a single user accessible across all devices, regardless of operating system.

This allows you to access Tellico through a browser window. If you're looking for a _lean_ Tellico image accessible through your local X server or a multi-user setup, this isn't for you.

## Notes

- This includes one volume at `/data` -- Tellico settings will automatically save here and it's recommended you save collections & external scripts to this folder as well.
- Image based on the excellent work by [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui). Extra environment variables and configuration can be found there.
- noVNC (web browser client) is running on port 8080.
- Image is Alpine based and directly building Tellico rather than relying on a package.
- Help does not work, the documentation can be found [here](https://docs.kde.org/stable5/en/tellico/tellico/)
- If the client doesn't default to automatically sizing the application to your browser window, try setting `DISPLAY_WIDTH` and `DISPLAY_HEIGHT` closer to the dimensions you're accessing it with.
- This is a HEAVY image as Tellico requires large chunks of the KDE environment.
- When using a reverse proxy, make sure it's capable of handling websockets correctly. See [here](https://github.com/traefik/traefik/issues/11405) for an example of a Traefik issue that would cause connection errors. 
- **Security is your problem.** This image does not include any authentication so if this is accessible on a network, you will likely want to setup some kind of reverse proxy with authentication. See the sample configuration for nginx-proxy below.

## Instructions

```
docker run -d --name=tellico --publish=8080:8080 -v /path/to/tellico/data:/data zweizs/docker-tellico-web
```

Head on over to `http://localhost:8080/`, hit 'Connect', and enjoy.

### Environment variables

| Variable           | Default Value |
| ------------------ | ------------- |
| USER_ID            | 1000          |
| GROUP_ID           | 1000          |
| KEEP_APP_RUNNING   | 1             |
| DARK_MODE          | 0             |
| WEB_LISTENING_PORT | 8080          |
| ENABLE_CJK_FONT    | 1             |
| DISPLAY_WIDTH      | 1920          |
| DISPLAY_HEIGHT     | 1080          |

### Sample configuration with Traefik

```yaml
labels:
  traefik.http.services.tellico.loadbalancer.server.port: "8080"
```

This would allow connecting to Tellico through your main entrypoint (normally port 80/443).

### Sample configuration with [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy)

_This has not been tested_

Assuming a container with the `VIRTUAL_HOST` variable set to `tellico.virtual.host.com`:

1.  On a machine with `apache2-utils` installed, run `htpasswd -c tellico.virtual.host.com username` and pick a password.

2.  Copy the `tellico.virtual.host.com` file generated to the `/path/to/htpasswd` directory.

3.  Run:

```
docker run -d -p 80:80 -p 443:443 \
    -v /path/to/htpasswd:/etc/nginx/htpasswd \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    jwilder/nginx-proxy
```

## Links

- [GitHub](https://github.com/Zweihander-Main/docker/tree/master/tellico-web)
- [Docker Hub](https://hub.docker.com/r/zweizs/docker-tellico-web)

## Dev notes:

- Github Action creates build with Docker tag based on tag format: `tellico/v3.4.6`
- When no tag present, Action creates release with date

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[MIT](../LICENSE)
