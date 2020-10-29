# X-Road REST and SOAP adapters

Toolset for deploying the [X-Road REST Adapter Service](https://github.com/nordic-institute/REST-adapter-service) and [xroad-universal-soap](https://github.com/nanndoj/xroad-universal-soap) proxy in tandem, as a [system service](https://en.wikipedia.org/wiki/Systemd) with [Docker Compose](https://docs.docker.com/compose/).

Related discussion in the [X-Road Community](https://x-road.global/join-the-x-road-community) can be found [here](https://jointxroad.slack.com/archives/CA66FG50T/p1568646102000400?thread_ts=1568197829.006100&cid=CA66FG50T) and [here](https://jointxroad.slack.com/archives/CDBRLMZNW/p1603813289036700?thread_ts=1602609405.030800&cid=CDBRLMZNW).

## Obtaining the metapackage

On the host Linux machine, issue:
```
git clone https://github.com/bthj/xroad-rest-soap-adapters.git

cd xroad-rest-soap-adapters/
```


## Docker installation

### Ubuntu

```
./install-docker-ubuntu.sh
```

### Red Hat

```
./install-docker-red-hat.sh
```

## Deploy REST and SOAP adapters as a system service with Docker Compose

```
./deploy-adapter-services-with-docker-compose.sh
```

## Configure the REST adapter service

### Client subsystem

To have the REST adapter service communicate with the correct client X-Road subsystem, and point correctly at its Security Server, edit the file:

```
/etc/rest-adapter-service/consumer-gateway.properties
```

Set the `id.client` property so it points to the desired client subsystem:

For instance, if the corresponding Security Server, in the instance `IS-DEV`, has a subsystem with configuration details like so:
- *Member Class*:  GOV
- *Member Code*:  10000
- *Subsystem Code*:  island-is-client

Then the property would be configured like:
```
id.client=IS-DEV.GOV.10000.island-is-client
```

### Security Server URL

By default the `ss.url` property in `/etc/rest-adapter-service/consumer-gateway.properties` is set to `http://172.17.0.1`, where the IP `172.17.0.1` points to the machine hosting the Docker container, in which the service is running.  It could be better to refer to the host name `host.docker.internal`, but that is not possible in current stable releases of Docker (19.03.13) for Linux.

If the Security Server is not listening for HTTP connections on port 80, but for instance on port 8080, which is the default when the [Security Server is installed on Red Hat](https://github.com/nordic-institute/X-Road/blob/master/doc/Manuals/ig-ss_x-road_v6_security_server_installation_guide_for_rhel.md), the URL to the Security Server hosting the client subsystem can be set like so:
```
ss.url=http://172.17.0.1:8080
```

### Loading configuration changes

To load changes to the configuration, the REST adapter service can be restarted with the command:
```
sudo systemctl restart docker-compose@xroad-rest-soap-adapters
```

The status of the REST and SOAP adapters Docker Compose system service can be viewed by issuing:
```
sudo systemctl list-units docker-compose@xroad-rest-soap-adapters.service
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

### Building and publishing Docker images

Example commands to build a Docker image for one of the services and push it to Docker Hub - issued from within the corresponding project:
```
docker build -t xroad-universal-soap .   
docker images
docker tag <tag> bthj/xroad-universal-soap
docker push bthj/xroad-universal-soap
```
Information pages for the built images are at:
- https://hub.docker.com/r/bthj/xroad-universal-soap
- https://hub.docker.com/r/bthj/xroad-rest-adapter-service

### Calling the REST adapter service to a SOAP service via the universal proxy

Following are example URLs calling the REST adapter service configured for one Security Server, where an example SOAP service is configured at another Security Server (COM/10002/Origo-Protected):


- REST call:  
http://localhost:6080/rest-adapter-service/Consumer/IS-DEV.COM.10002.Origo-Protected.NumberToWords/?ubiNum=2021&X-XRd-NamespaceSerialize=http://www.dataaccess.com/webservicesserver/&X-XRd-NamespacePrefixSerialize=web&Accept=application/json

  - Corresponding SOAP service defintion:  
  https://www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL  

    - Added to the Security Server via the SOAP proxy using the URL:
  https://localhost:5443/www.dataaccess.com/webservicesserver/NumberConversion.wso?WSDL


- REST call:  
http://localhost:6080/rest-adapter-service/Consumer/IS-DEV.COM.10002.Origo-Protected.FindPerson/?id=1&X-XRd-NamespaceSerialize=http://tempuri.org&X-XRd-NamespacePrefixSerialize=tem&Accept=application/json

  - Corresponding SOAP service defintion:
  https://www.crcind.com/csp/samples/SOAP.Demo.CLS?WSDL

    - Added to the Security Server via the SOAP proxy using the URL:
  https://localhost:5443/www.crcind.com/csp/samples/SOAP.Demo.CLS?WSDL
