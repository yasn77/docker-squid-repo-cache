docker-squid-repo-cache
=======================

Docker image of squid-deb-proxy (also for RPM)

    OS Base : Ubuntu 14.04
    Exposed Ports : 8000 2812
    Cache dir : /var/cache/squid-deb-proxy (Exported Volume)

Environment Variables
---------------------
    CACHE_ANY
        Should any request be cached. Default true

Services
--------

  * squid-deb-proxy
  * Monit

This is a general purpose deb and rpm caching proxy. I use it mainly for Vagrant and Docker caching.
It's basically a slightly modified squid-deb-proxy, to support RPM. Since the intention is to run it
locally on my development machines and not expose it to the network, the default behaviour will cache all requests.
To change the default, set environment variable `CACHE_ANY` to anything other than `true`:

  `docker run -d -P -e CACHE_ANY=false <CONTAINER_ID>`

The container also supports the following environemt variables:

  * `EXTRA_MIRROR_DSTDOMAIN` : A space separated list of domains to cache. This is only useful if
    `CACHE_ANY` is false
  * `ALLOWED_NETWORKS` : Space seperated networks that are allowed to use the cache. It is unlikely you will need to 
    change this, as Docker NATs all requests.
  * `PKG_BLACKLIST` : Space seperated list of packages that will not be cached.

Monit is used to control the start up and management of the Squid proxy. You can access the monit webserver
by exposing port 2812 on the Docker host. The user name is `monit` and password can be found by running:

    docker logs <CONTAINER_ID> 2>/dev/null | grep MONIT_PASSWORD

