# EarthOS

Operating system that can be booted in a Scratch project! (SMC Computer)

This repository contains a repo manifest used to sync all the other repositories.

## Sync
If you haven't installed repo before, use these commands:
```
mkdir -p ~/bin
echo export PATH=\$PATH:\$HOME/bin >> ~/.bashrc
source ~/.bashrc
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+rx ~/bin/repo
```
Create a directory for the EarthOS source tree:
```
mkdir EarthOS && cd EarthOS
```
Install repo in the directory:
```
repo init -u https://github.com/EarthOS-SMC/EarthOS.git -b dev
```
To sync the repositories:
```
repo sync
```

## Build
These 2 commands can be used to build EarthOS. It'll take a few seconds:
```
. build/envsetup.sh
make
```
You'll find an `EarthOS.fssc` file in the `out` directory.
