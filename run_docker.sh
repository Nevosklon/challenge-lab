#!/usr/bin/env bash
cd /home/ec2-user/webserver/

# only start docker if /network_file_storage is mounted
mount -l | grep 'on /network_file_storage/ type nfs' && \
  /usr/local/bin/docker-compose start
