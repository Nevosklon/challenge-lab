#!/usr/bin/env bash
# IF this was done properly 
# would only rebuild nessary images
# while having at least one
# proxy, backend running at all time
# while shutting other service
#
# We use this instead of 
# [WatchTower](https://github.com/containrrr/watchtower)
# since watchtower
# - doesnt backup
# - I dont like giving access underlying unix domain socket and
# somewhat negates some of benefits of containers
# 
COMMIT_DIGEST="${$(head -c 200 /dev/urandom | sha1sum)::6}"
CURRENT_DATE="$(date +%F)"
uuid_gen(){
  TYPE=$1
  echo "$TYPE:${CURRENT_DATE:-Date}-${COMMIT_DIGEST:-Digest}"
}
docker_backup() {
  IMAGE=$1
  SAVE=$2
  docker commit $IMAGE $SAVE
  docker save -o "/network_file_storage/backup/${BACKEND}.tar" $BACKEND 
}

BACKEND=$(uuid_gen 'backend')
REVERSEPROXY=$(uuid_gen 'reverseproxy')
REDIS=$(uuid_gen 'redis')

mkdir -p /network_file_storage/backup
docker_backup Backend $BACKEND
docker_backup ReverseProxy $REVERSEPROXY
docker_backup commit redis $REDIS

# TODO much effort to sort out what container to be running 
# lgtm
docker-compose build --pull && \
docker-compose up 
