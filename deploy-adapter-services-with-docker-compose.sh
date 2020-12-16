#!/bin/bash
SCRIPTS_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPTS_DIR" ]]; then SCRIPTS_DIR="$PWD"; fi

echo "Copying REST adaptor service configuration"
sudo cp -n -R $SCRIPTS_DIR/properties/rest-adapter-service /etc/

# generate a keypair for the soap adapter container to reference, via environment variables (in docker-compose)
sudo mkdir -p /etc/xroad-soap-adapter
sudo openssl req -nodes -new -x509 -days 7300 \
  -keyout  /etc/xroad-soap-adapter/xroad-soap-adapter.key \
  -out /etc/xroad-soap-adapter/xroad-soap-adapter.crt \
  -subj "/C=ST/O=Local/CN=localhost"

# based on https://gist.github.com/mosquito/b23e1c1e5723a7fd9e6568e5cf91180f :

echo "Deploying Docker Compose SystemD service configuration"
sudo cp docker-compose@.service /etc/systemd/system/

echo "Deploying xroad-rest-soap-adapters Docker Compose configuration for SystemD services"
sudo mkdir -p /etc/docker/compose/xroad-rest-soap-adapters
sudo cp -n $SCRIPTS_DIR/docker-compose.yaml /etc/docker/compose/xroad-rest-soap-adapters/

echo "Starting docker-compose@xroad-rest-soap-adapters as a system service"
sudo systemctl start docker-compose@xroad-rest-soap-adapters

echo "Waiting 5 seconds for docker-compose@xroad-rest-soap-adapters to start"
sleep 5

echo "Listing X-Road system services:"
sudo systemctl list-units "*xroad*"
