# Anki Sync Server

> Dockerized builtin Anki Sync Server (2.1.57+)

## Tested

| Platform  | Version    | Release |
| --------- | ---------- | ------- |
| Linux     | 2.1.57-qt6 | 2.1.57  |
| AnkiDroid | 2.15.6     | 2.1.57  |

## Instructions

Reference [the Anki manual on the builtin sync server](https://docs.ankiweb.net/sync-server.html) for details on environment variables, adding multiple users, ect.

Security is your problem: this normally runs on an unencrypted port 8080. Setting up a reverse proxy with HTTPS is recommended. Sample configs below.

Set the `Self-hosted sync server` option under `Preferences -> Syncing` on Desktop. For AnkiDroid, use the same URL (with trailing slash) for the main sync URL and add `/msync/` for the media URL (check the above documentation, this may change in the future). Make sure you set the protocol (`http://`) whenever you enter this address.

### One-liner

```shell
docker run --name anki-sync-server -p 8080:8080 zweizs/anki-sync-server:latest
```

### Volumes

`/data` in the container is used as a volume. If you change `SYNC_BASE`, you'll need to make sure to add a volume at the newly specified location.

### Environment variables

| Variable               | Default Value   |
| ---------------------- | --------------- |
| `SYNC_USER1`           | `user:password` |
| `SYNC_BASE`            | `/data`         |
| `SYNC_HOST`            | `0.0.0.0`       |
| `SYNC_PORT`            | `8080`          |
| `MAX_SYNC_UPLOAD_MEGS` | `100`           |
| `VENV_ROOT`            | `/data`         |

### Sample configuration with Traefik

```yaml
labels:
  traefik.http.services.anki.loadbalancer.server.port: "8080"
```

This would allow connecting to the Anki server through your main entrypoint (normally port 80/443).

### Sample configuration with [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy)

_This has not been tested_

Set `VIRTUAL_PORT` environment variable to 8080.

If it doesn't work, it's possible it needs HTTP 1.0 support (as the older community Anki sync servers did) in which case try placing the following in `/etc/nginx/proxy.conf`:

```nginx
# HTTP 1.0 support
proxy_http_version 1.0;
proxy_buffering off;
proxy_set_header Host $http_host;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $proxy_connection;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $proxy_x_forwarded_proto;
proxy_set_header X-Forwarded-Ssl $proxy_x_forwarded_ssl;
proxy_set_header X-Forwarded-Port $proxy_x_forwarded_port;
proxy_set_header X-Forwarded-Path $request_uri;

# Mitigate httpoxy attack
proxy_set_header Proxy "";
```

## Links

- [GitHub](https://github.com/Zweihander-Main/docker/tree/master/anki-sync-server)
- [Docker Hub](https://hub.docker.com/r/zweizs/anki-sync-server)

## Dev notes:

- Github Action creates build with Docker tag based on tag format: `anki-sync-server/v2.1.57`
- When no tag present, Action creates release with date

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[Anki](https://github.com/ankitects/anki) is licensed under [GPLv3](https://github.com/ankitects/anki/blob/main/LICENSE)

This repo is [MIT](../LICENSE)
