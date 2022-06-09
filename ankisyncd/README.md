# Docker-ankisyncd

> Dockerized ankisyncd, targeting more recent releases of Anki/AnkiDroid

Uses [ankicommunity/anki-sync-server](https://github.com/ankicommunity/anki-sync-server) codebase.

## Tested

| Platform  | Version | Release | Download                                                                          |
| --------- | ------- | ------- | --------------------------------------------------------------------------------- |
| Linux     | 2.1.49  | v2.3.0  | [Mega](https://mega.nz/file/gxsSDRjC#PsQiO3FGka_dMIeHOBOrnYejZiRrH4W5KXkKBjsOb9c) |
| AnkiDroid | 2.15.6  | v2.3.0  | [Mega](https://mega.nz/file/55lHFBDQ#ZH0okHe_rknOnuudQ0JmcfC51jhoDGdH6CJysIMG1Is) |

## Instructions

Follow instructions from ['Setting up Anki'](https://github.com/ankicommunity/anki-sync-server#setting-up-anki) for setting up AnkiDroid and desktop versions.

### Initial setup

Enter container:

```shell
$ docker exec -it anki /bin/bash
```

and execute:

```shell
$ cp ./ankisyncd_cli/ankisynctl.py .
$ python ./ankisyncctl.py adduser <username>
```

Copy step can be skipped if [issue/128](https://github.com/ankicommunity/anki-sync-server/issues/128) is resolved.

### Sample configuration with Traefik (does not work with v2.3.0 and prior releases)

```yaml
labels:
  traefik.http.services.anki.loadbalancer.server.port: "27701"
```

This would allow connecting to the anki server through your main entrypoint (normal port 80/443).

### Sample configuration with [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy)

Set `VIRTUAL_PORT` environment variable to 27701.

For v2.3.0 and prior, place the following in `/etc/nginx/proxy.conf`:

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

### Env variables

| Variable                    | Default Value               |
| --------------------------- | --------------------------- |
| `ANKISYNCD_HOST`            | `0.0.0.0`                   |
| `ANKISYNCD_PORT`            | `27701`                     |
| `ANKISYNCD_DATA_ROOT`       | `/srv/ankisyncd`            |
| `ANKISYNCD_BASE_URL`        | `/sync/`                    |
| `ANKISYNCD_BASE_MEDIA_URL`  | `/msync/`                   |
| `ANKISYNCD_AUTH_DB_PATH`    | `/srv/ankisyncd/auth.db`    |
| `ANKISYNCD_SESSION_DB_PATH` | `/srv/ankisyncd/session.db` |

### Notes on usage:

- If you have a large media collection, focus on syncing it first (it may take a few tries)
- Don't use other/multiple addons for syncing

## Links

- [GitHub](https://github.com/Zweihander-Main/docker-ankisyncd)
- [Docker Hub](https://hub.docker.com/r/zweizs/docker-ankisyncd)

## Dev notes:

- Github Action creates build with Docker tag based on Git semver tag
- When no tag present, Action creates release with date
- Action checks original repo default branch for new commits daily and creates new releases when a new commit has been found

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[ankicommunity/anki-sync-server](https://github.com/ankicommunity/anki-sync-server) is licensed under [GPLv3](https://github.com/ankicommunity/anki-sync-server/blob/develop/COPYING)

This repo is [MIT](./LICENSE)
