# X-Road REST and SOAP adapters

Kind of a metapackage for the [X-Road REST Adapter Service](https://github.com/nordic-institute/REST-adapter-service) and [xroad-universal-soap](https://github.com/nanndoj/xroad-universal-soap) ([fork](https://github.com/bthj/xroad-universal-soap)) projects.  It helps with installing [Docker](https://en.wikipedia.org/wiki/Docker_(software)) and deploying a [Docker Compose](https://docs.docker.com/compose/) configuration as a system service.

## Docker installation

### Ubuntu

```
./install-docker-ubuntu.sh
```

### Red Hat

TODO

## Deploy REST and SOAP adapters as a system service with Docker Compose

```
./deploy-adapter-services-with-docker-compose.sh
```

## Logs

System service logs can be viewed with:
```
logs/system-view-xroad-rest-soap-adapters.sh
```
or
```
logs/system-tail-xroad-rest-soap-adapters.sh
```

The REST adapter application logs can be viewed with:
```
logs/xroad-rest-adapter.sh
```

And the SOAP adapter application logs:
```
logs/xroad-soap-adapter.sh
```

## Appendix

Example commands to build a Docker image for one of the services and push it to Docker Hub - issued from within the corresponding project:
```
docker build -t xroad-universal-soap .   
docker images
docker tag <tag> bthj/xroad-universal-soap
docker push bthj/xroad-universal-soap
```
Information pages for the built images are at:
- https://hub.docker.com/repository/docker/bthj/xroad-universal-soap
- https://hub.docker.com/repository/docker/bthj/xroad-rest-adapter-service
