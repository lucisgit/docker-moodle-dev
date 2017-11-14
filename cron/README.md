docker-moodle-cron-dev
=============

Dockerfile for creating backend image running cron
service for Moodle development. The image is a part of Moodle dev
environment and supposed to be used together with
[docker-moodle-apache-dev](https://github.com/lucisgit/docker-moodle-dev/tree/master/apache)
image, that provides web frontend. See the main repo
[README.md](https://github.com/lucisgit/docker-moodle-dev) for details how
to use Compose to simplify dev environment setup and containers running.

## Installation

Using automated builds of the image from Dockerhub is preferable method of
installation.

Debian stable (also can be requested by 'latest' and no tag):
```bash
docker pull lucisgit/docker-moodle-cron-dev:stable
```

Debian Jessie:
```bash
docker pull lucisgit/docker-moodle-cron-dev:jessie
```

Debian Jessie with Unoconv package (provides any docs conversion to PDF):
```bash
docker pull lucisgit/docker-moodle-cron-dev:jessie-unoconv
```

Alternatively, you may build image locally:

```bash
$ git clone https://github.com/lucisgit/docker-moodle-dev.git
$ cd docker-moodle-dev/cron/stable
$ docker build --rm -t lucisgit/docker-moodle-cron-dev .
```

## Using contrainer instance

It is assumed that Moodle is configured and database already exits as the
part of `docker-moodle-apache-dev` image requirments.

You need to mount the same Moodle data directory that
`docker-moodle-apache-dev` is using. The easiest way to do that is using
one of the data persistence methods described in `docker-moodle-apache-dev`
readme file, and mount it to this container in a similar way.

For example, if you have a volume called `moodledatavolume`, the container
running command will be:

```bash
docker run --name dev-moodle-cron -v /home/user/git/moodle:/var/www/moodle -v moodledatavolume:/srv/moodledata -d lucisgit/docker-moodle-cron-dev
```
