#!/bin/bash

# setup.sh
# Project specific code goes here
#
# Project name
proj="EarthOS"

# Custom code
release="2.0.1" # EarthOS version
echo "/boot/entry.conf" > ./content/earthos/ebl/entries.list

# Server apps
echo "SMC SSH - remote shell control" > ./content/earthos/install/apps_server.list

# GUI apps
: #nothing yet

echo "${release}-$(date +"%m-%d-%Y-%H-%M")" > ./content/earthos/build.txt
echo "$release" >> ./content/earthos/build.txt
