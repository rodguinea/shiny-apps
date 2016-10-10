Dockerized Shiny App
=======================

This is the Dockerized Shiny App that runs on  [thetech.com](thetech.com)

This Dockerfile is based on Debian "testing" and r-base image.

The image is forked from shiny-wordcloud on [Docker Hub](https://registry.hub.docker.com/u/flaviobarros/shiny-wordcloud/).

## Usage:

To run this Shiny App locally:

```sh
docker run --rm -p 80:3838 [name of docker image]
```

and it will be available at http://127.0.0.1/ or http://localhost

You can run the container at other ports. It can happen that there is some service running at PORT 80, as Apache or Nginx.
To run the app at PORT 3838 for example, you can use:

```sh
docker run --rm -p 3838:3838 [name of docker image]
```

## Deployment on The Tech website:

* Build a docker image on the tech server with :

```sh
docker build -t yourname/yourappname .
```

* Run the image with


```sh
docker run --rm -p 3838:3838 yourname/yourappname
```

#### Entering the container (for debugging):

```sh
docker ps
```

| CONTAINER ID    |    IMAGE  | COMMAND    |    CREATED       |   STATUS | PORTS    |   NAMES
| ---- | ----- | -------- | -------- | -------- | ------- | ------
| 8f67f0af8a8a    |    thetech/shiny-testing    | "/usr/bin/shiny-serve"  | 14 minutes ago  |    Up 14 minutes   |    0.0.0.0:3838->3838/tcp

* Grab the container ID and run to pop a shell:

```
docker exec -it [container-id] bash
```


## Building a Shiny App:

After developing your Shiny App, you will need two files for deployment: ui.R and server.R. Then
place the files in a new folder `appname` in this repo, and add a line to `Dockerfile` like

```
COPY /appname/ /srv/shiny-server/appname/
```

You must rebuild and rerun the docker image (see [Deployment](##Deployment on The Tech website:)). Then, you can access the app at `thetech.com:3838/appname`.

## Deploy with a docker based PaaS

If you have a PaaS with Dockerfiles support, like [Deis](http://deis.io/) or [Dokku](https://github.com/progrium/dokku), you can git push this image. I just wrote a post with further instructions: [Git pushing Shiny Apps with docker and dokku](https://www.rmining.net/2015/05/11/git-pushing-shiny-apps-with-docker-dokku/)
