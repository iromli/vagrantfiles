#!/bin/bash

# create a swarm manager node
docker-machine create \
    --driver digitalocean \
    --digitalocean-access-token $(cat token.txt) \
    --digitalocean-region sgp1 \
    --digitalocean-size 4gb \
    --digitalocean-image ubuntu-14-04-x64 \
    --engine-insecure-registry=https://registry.gluu.org:5000 \
    dk-master

# initialize swarm manager
docker-machine ssh dk-master docker swarm init --advertise-addr $(docker-machine ip dk-master)

# cert to connect to registry.gluu.org
docker-machine ssh dk-master mkdir -p /etc/docker/certs.d/registry.gluu.org:5000
docker-machine scp ca.crt dk-master:/etc/docker/certs.d/registry.gluu.org:5000/ca.crt

# event monitoring
docker-machine ssh dk-master apt-get install -y python-pip
docker-machine ssh dk-master pip install docker-py
docker-machine scp dkevents.py dk-master:/root/dkevents.py

# create overlay network in swarm
docker-machine ssh dk-master \
    docker network create \
        --driver overlay \
        --subnet 10.0.9.0/24 \
        --opt encrypted \
        gluu-server

# create swarm worker(s)
for wrk in 1; do
    # create a swarm worker node
    docker-machine create \
        --driver digitalocean \
        --digitalocean-access-token $(cat token.txt) \
        --digitalocean-region sgp1 \
        --digitalocean-size 4gb \
        --digitalocean-image ubuntu-14-04-x64 \
        --engine-insecure-registry=https://registry.gluu.org:5000 \
        dk-worker-${wrk}

    # join to existing swarm cluster as a worker
    docker-machine ssh dk-worker-${wrk} \
        docker swarm join \
            --token $(docker-machine ssh dk-master docker swarm join-token --quiet worker) \
            $(docker-machine ip dk-master):2377

    # cert to connect to registry.gluu.org
    docker-machine ssh dk-worker-${wrk} mkdir -p /etc/docker/certs.d/registry.gluu.org:5000
    docker-machine scp ca.crt dk-worker-${wrk}:/etc/docker/certs.d/registry.gluu.org:5000/ca.crt
done
