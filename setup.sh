#!/bin/bash

# setup.sh
# This script adds the build date to /etc/release
#
# Project name
proj="EarthOS"

# Release
release="2.1.0-rc" # EarthOS version

echo "$proj" > ./content/earthos/etc/release
echo "$release" >> ./content/earthos/etc/release
echo "${release}-$(date -u +"%m-%d-%Y-%H-%M")" >> ./content/earthos/etc/release
