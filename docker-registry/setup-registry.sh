#!/usr/bin/env bash

if [[ -z $(docker ps | grep registry) ]]; then
    docker run -d -p 5000:5000 --name registry registry:2
fi

if [[ -z $(docker ps | grep docker-auth) ]]; then
    docker run -d -p 5001:5001 --name docker-auth cesanta/docker_auth
fi
