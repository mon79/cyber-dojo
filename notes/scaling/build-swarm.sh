#!/bin/bash

# Script used in early investigation of using docker-swarm
# to scale cyber-dojo.
# Important this is run as the user who will run the
# docker run command, probably cyber-dojo

if [ $# -ne 2 ]; then
  echo "use: scale [digital-ocean-access-token]"
  exit 1
else
  digitalOceanAccessToken=$2
fi

swarmToken=`docker run --rm swarm create`
echo swarm-token $swarmToken created
echo $swarmToken > docker-swarm.token

# - - - - - - - - - - - - - - - - - - - - - - -

docker-machine create \
   --driver digitalocean \
   --digitalocean-access-token=$digitalOceanAccessToken \
   --digitalocean-region=lon1 \
   --digitalocean-size=1gb \
   --swarm \
   --swarm-master \
   --swarm-discovery token://$swarmToken \
   cyber-dojo-docker-swarm-master

if [ $? -ne 0 ]; then
  echo "FAILED:$ docker-machine create ... cyber-dojo-docker-swarm-master"
  exit 2
else
  echo "OK:$ docker-machine create ... cyber-dojo-docker-swarm-master"
fi

# - - - - - - - - - - - - - - - - - - - - - - -

docker-machine create \
   --driver digitalocean \
   --digitalocean-access-token=$digitalOceanAccessToken \
   --digitalocean-region=lon1 \
   --digitalocean-size=2gb \
   --swarm \
   --swarm-discovery token://$swarmToken \
   cyber-dojo-docker-swarm-node-00

if [ $? -ne 0 ]; then
  echo "FAILED:$ docker-machine create ... cyber-dojo-docker-swarm-node-00"
  docker-machine rm -f cyber-dojo-docker-swarm-node-00
  exit 3
else
  echo "OK:$ docker-machine create ... cyber-dojo-docker-swarm-node-00"
fi

# - - - - - - - - - - - - - - - - - - - - - - -

docker-machine create \
   --driver digitalocean \
   --digitalocean-access-token=$digitalOceanAccessToken \
   --digitalocean-region=lon1 \
   --digitalocean-size=2gb \
   --swarm \
   --swarm-discovery token://$swarmToken \
   cyber-dojo-docker-swarm-node-01

if [ $? -ne 0 ]; then
  echo "FAILED:$ docker-machine create ... cyber-dojo-docker-swarm-node-01"
  docker-machine rm -f cyber-dojo-docker-swarm-node-01 
  exit 4
else
  echo "OK:$ docker-machine create ... cyber-dojo-docker-swarm-node-01"
fi

# - - - - - - - - - - - - - - - - - - - - - - -

docker-machine ssh cyber-dojo-docker-swarm-node-00 'docker pull cyberdojo/gcc-4.8.1_assert'
docker-machine ssh cyber-dojo-docker-swarm-node-01 'docker pull cyberdojo/gcc-4.8.1_assert'
