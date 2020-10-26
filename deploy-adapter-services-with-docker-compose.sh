#!/bin/bash
SCRIPTS_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$SCRIPTS_DIR" ]]; then SCRIPTS_DIR="$PWD"; fi

sudo cp -R $SCRIPTS_DIR/properties/rest-adapter-service /etc/

# based on https://gist.github.com/mosquito/b23e1c1e5723a7fd9e6568e5cf91180f :

sudo cp docker-compose@.service /etc/systemd/system/

sudo mkdir -p /etc/docker/compose/xroad-rest-soap-adapters

sudo cp $SCRIPTS_DIR/docker-compose.yaml /etc/docker/compose/xroad-rest-soap-adapters/

sudo systemctl start docker-compose@xroad-rest-soap-adapters

sleep 5

sudo systemctl list-units "*xroad*"
