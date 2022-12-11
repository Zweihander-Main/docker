# Android Connectivity Check

> Simple server that returns a 204, for use with the WiFi connectivity check for Android

If you're running a stripped down form of Android (ex Lineage), you may be disappointed to find that your device still 'phones home' to Google whenever it joins a WiFi network. It specifically looks for a `204` response code from `https://connectivitycheck.gstatic.com/generate_204`. This docker image generates a similar response and can be set as the connectivity check URL:

```
settings put global captive_portal_http_url "http://yoursite.com/"
settings put global captive_portal_https_url "https://yoursite.com/"
```

## Instructions

```
docker run -d --name=android-connectivity-check --publish=80:8080 zweizs/android-connectivity-check
```

Combine with Traefik or reverse proxy of your choice for best results.

## Links

- [GitHub](https://github.com/Zweihander-Main/docker/tree/master/android-connectivity-check)
- [Docker Hub](https://hub.docker.com/r/zweizs/android-connectivity-check)

## Dev notes:

- Github Action creates build with Docker tag based on Git semver tag

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[MIT](../LICENSE)
