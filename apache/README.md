docker-moodle-apache-dev
=============

This repo contains a Dockerfile for creating web frontend image for Moodle
development environment. This frontend image provides Apache with PHP libraries
required for Moodle as well as clamav service. The actual Moodle code needs to
be mounted as host directory data volume. This approach allows developer
working with the code locally, but serving content via Docker container.

See the main repo
[README.md](https://github.com/lucisgit/docker-moodle-dev) for details how
to use Compose to simplify dev environment setup and containers running.

## Database

It is assumed that you have container for the database within the same Docker
bridge network, so that web frontend can access it. For PostgreSQL I suggest
using [official image](https://hub.docker.com/_/postgres/).

## Installation

Using automated builds of the image from Dockerhub is preferable method of
installation.

Debian stable (also can be requested by 'latest' and no tag):
```bash
docker pull lucisgit/docker-moodle-apache-dev:stable
```

Debian Jessie:
```bash
docker pull lucisgit/docker-moodle-apache-dev:jessie
```

Debian Jessie with Unoconv package (provides any docs conversion to PDF):
```bash
docker pull lucisgit/docker-moodle-cron-dev:jessie-unoconv
```

Alternatively, you may build image locally:

```bash
$ git clone https://github.com/lucisgit/docker-moodle-dev.git
$ cd docker-moodle-dev/apache/stable
$ docker build --rm -t lucisgit/docker-moodle-apache-dev .
```

## Using contrainer instance

In a very simple scenario you just need to create container instance and mount
your local Moodle directory (`/home/user/git/moodle` in example below) into the
container at `/var/www/moodle`:

```bash
docker run --name dev-moodle-fe -p 80:80 -v /home/user/git/moodle:/var/www/moodle -d lucisgit/docker-moodle-apache-dev
```

The above command will start the container with mounted host directory
`/home/user/git/moodle` at `/var/www/moodle` in the container and map port 80
on the container to port 80 on the host.

## Moodle config.php

Your Moodle config.php should contain at least:

* Database host and credentials pointing to exising database container.
* `$CFG->dataroot  = '/srv/moodledata';`
* `$CFG->wwwroot   = 'http://localhost';`

## Moodle data persistance

You may wish to store Moodle data directory content oustide container, so that
it will not be destroyed on container re-creation. In order to do that, wou may use host
directory as data volume mounted at `/srv/moodledata` in the container:

```bash
docker run --name dev-moodle-fe -p 80:80 -v /home/user/git/moodle:/var/www/moodle -v /home/user/moodledata:/srv/moodledata -d lucisgit/docker-moodle-apache-dev
```

Alternatively, create [Docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/) and use it in the container instance:

```bash
docker volume create --name moodledatavolume
docker run --name dev-moodle-fe -p 80:80 -v /home/user/git/moodle:/var/www/moodle -v moodledatavolume:/srv/moodledata -d lucisgit/docker-moodle-apache-dev
```

## Using SSL

The image supports serving content by https using bundled "snakeoil" key. In
order to use it, you need to expose port 443 to the host and amend Moodle
config.php accordingly:

```bash
docker run --name dev-moodle-fe -p 443:443 -v /home/user/git/moodle:/var/www/moodle -d lucisgit/docker-moodle-apache-dev
```
> **Note:** To expose both ports 80 and 443 and map them to same ports or the host, just use `-P` paramenter instead of specifying port mapping.

Your config.php should now use `$CFG->wwwroot = 'https://localhost';`.

## Clamav

The image provides Clamav service running in the container. Bu default it
starts freshclam daemon that is updating virus databases automatically in the regular
intervals and clamd daemon itself. You may disable Clamav service entirely by
passing environment variable `DISABLE_CLAMAV=true`, e.g.

```bash
docker run --name dev-moodle-fe -p 80:80 -e DISABLE_CLAMAV=true -v /home/user/git/moodle:/var/www/moodle -v moodledatavolume:/srv/moodledata -d lucisgit/docker-moodle-apache-dev
```
There is an alternative option to disable Clamd only (but keep freshclam
running) by using `DISABLE_CLAMD=true` environment variable respectively. This
is usful for limited memory systems when you do not want to start clamd and use
`/usr/bin/clamscan` for scanning instead.

To initate virus scanning in command-line mode, use `/usr/bin/clamdscan`
binary or `/usr/bin/clamscan` if clamd is disabled in your setup. For
running scan using unix socket use `/var/run/clamav/clamd.ctl` socket path.
Notice, that `clamav` user is in `www-data` group, so no further permission
changes needed for "unix socket" mode use.

## Acessing Moodle container

Just enter http://localhost or https://localhost in your browser depending on
your settings.
