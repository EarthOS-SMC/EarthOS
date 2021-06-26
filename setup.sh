#!/bin/bash

# setup.sh
# This script adds the build date to /etc/release
#
# Project name
proj="EarthOS"

# Release
release="2.1.0-wip-rc5" # EarthOS version
build_date=$(date -u +"%m-%d-%Y-%H-%M")
build_type="UNOFFICIAL"
echo "$proj" > ./content/earthos/etc/release
echo "$release" >> ./content/earthos/etc/release
echo "${release}-${build_date}" >> ./content/earthos/etc/release
echo $build_type >> ./content/earthos/etc/release
