#!/usr/bin/env bash

set -e # exit on any failure

moonc .
sudo docker build -t guard13007/tangentfox-com:testing .
sudo docker push guard13007/tangentfox-com:testing
./test.sh
