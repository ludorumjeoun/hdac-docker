#!/bin/bash

NAME="$1"
if [ -z "$NAME" ]; then
    NAME="friday";
fi

docker build --tag=hdac-friday-node:1.0 .
docker run -d --name=$NAME hdac-friday-node:1.0
docker exec -it $NAME /bin/bash
