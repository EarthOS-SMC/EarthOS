#!/bin/bash

# EarthOS build system
# 2021 - adazem009
cd "$(dirname $BASH_SOURCE)"
auto="$1"
if ! [ -d "./build" ]; then
	echo "Couldn't find the build directory! Did you run sync.sh?"
	echo "Aborting build."
	exit -3
fi
if ! [ -d "./parts" ]; then
	echo "Couldn't find the parts directory! Did you run sync.sh?"
	echo "Aborting build."
	exit -3
fi
echo "---------------------------"
echo "Looking for dependencies..."
if [ -d "./build/FSSC-Builder" ]; then
	echo "Found FSSC-Builder"
else
	echo "You're missing FSSC-Builder in your build directory! Please run sync.sh."
	exit -4
fi
if [ -d "./build/PowerSlash" ]; then
	echo "Found PowerSlash"
else
	echo "You're missing PowerSlash in your build directory! Please run sync.sh."
	exit -4
fi
if [ -d "./build/PowerSlash-userspace" ]; then
	echo "Found PowerSlash-userspace"
else
	echo "You're missing PowerSlash-userspace in your build directory! Please run sync.sh."
	exit -4
fi
echo "---------------------------"

rm -rf "./build/FSSC-Builder/content" && mkdir "./build/FSSC-Builder/content"
chmod +x ./setup.sh
source ./setup.sh
if [[ "$auto" = "1" ]]; then
	RED=''
	GREEN=''
	YELLOW=''
	NC=''
else
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	YELLOW='\033[1;33m'
	NC='\033[0m'
fi
if [ -f "./${proj}.fssc" ]; then
	rm "./${proj}.fssc"
fi
src=$(pwd)

# Remove .gitignore(s)
if [ -f "./content/earthos/boot/.gitignore" ]; then
	rm "./content/earthos/boot/.gitignore"
fi
if [ -f "./content/earthos/dev/.gitignore" ]; then
	rm "./content/earthos/dev/.gitignore"
fi
if [ -f "./content/earthos/sys/.gitignore" ]; then
	rm "./content/earthos/sys/.gitignore"
fi
if [ -f "./content/earthos/lib/system/users/.gitignore" ]; then
	rm "./content/earthos/lib/system/users/.gitignore"
fi

# Kernel-space
# MBR
echo "
===== BUILDING MBR =====
"
cd ./parts/mbr
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh "" "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build the MBR - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
rm ./build/FSSC-Builder/mbr
cp ./parts/mbr/image ./build/FSSC-Builder/mbr

# Little bootloader
echo "
===== BUILDING LITTLE BOOTLOADER =====
"
cd ./parts/lbl
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh "" "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build the bootloader - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
rm ./content/earthos/boot.smc
cp ./parts/lbl/image ./content/earthos/boot.smc

# KERNEL
echo "
===== BUILDING EARTHOS KERNEL =====
"
cd ./parts/kernel
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh "" "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build the kernel - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
if ! [ -f ./content/earthos/boot ]; then
	mkdir -p ./content/earthos/boot
fi
rm ./content/earthos/boot/ekrnl
cp ./parts/kernel/image ./content/earthos/boot/ekrnl

echo "=====
Kernel-space setup finished."

# User-space
# INIT
echo "
===== BUILDING INIT SYSTEM =====
"
cd ./parts/init
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh "" "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build the init system - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
if ! [ -f ./content/earthos/sbin ]; then
	mkdir -p ./content/earthos/sbin
fi
rm ./content/earthos/sbin/init
cp ./parts/init/image ./content/earthos/sbin/init

# USER-SETUP
echo "
===== BUILDING USER-SETUP SERVICE =====
"
cd ./parts/user-setup
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh usrsetup.pwsle  "" "$auto" && ./build.sh initcfg.pwsle "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build the service - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
if ! [ -f ./content/earthos/lib/system ]; then
	mkdir -p ./content/earthos/lib/system
fi
rm ./content/earthos/lib/system/usrsetup
rm ./content/earthos/lib/system/initcfg
cp ./parts/user-setup/usrsetup ./content/earthos/lib/system/usrsetup
cp ./parts/user-setup/initcfg ./content/earthos/lib/system/initcfg

# UI
echo "
===== BUILDING USER INTERFACE =====
"
cd ./parts/ui
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh "" "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build user interface - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
rm ./content/earthos/lib/system/ui
cp ./parts/ui/image ./content/earthos/lib/system/ui

# SHELL
echo "
===== BUILDING SHELL =====
"
cd ./parts/shell
echo 1 > reduce # Reduce output
if ! [ -d compiler ]; then
	chmod +x sync.sh
	dummy=`(./sync.sh) &> /dev/null` || {
	echo -e "${RED}Failed to sync the dependencies - process exited with code ${YELLOW}${?}${NC}"; echo; echo "Debug info: "; ./sync.sh; exit 1
	}
fi
./build.sh "" "" "$auto"
sv=$?
if ((sv != 0)); then
	echo -e "${RED}Failed to build shell - process exited with code ${YELLOW}${sv}${NC}"
	exit $sv
fi
cd "$src"
rm ./content/earthos/bin/shell
cp ./parts/shell/image ./content/earthos/bin/shell

# Remaining files
echo "
===== COMPILING REMAINING USER-SPACE FILES ===
"

rm ./build/FSSC-Builder/config/attributes.list && cp ./config/attributes.list ./build/FSSC-Builder/config/
parts=()
while IFS= read -r line; do
	if [[ "$line" != "./content" ]]; then
 		parts+=( "$line" )
 	fi
done < <( find ./content -maxdepth 1 -type d -print )
i1=0
while ((i1 < $((${#parts[@]})))); do
	i1="$(($i1+1))"
	echo "Compiling files on partition ${parts[$((i1-1))]}"
	mkdir "./build/FSSC-Builder/${parts[$((i1-1))]}"
	cd "./${parts[$((i1-1))]}"
	dirs=()
	while IFS= read -r line; do
	 	dirs+=( "$line" )
	done < <( find . -type d -print )
	i4=0
	while ((i4 < ${#dirs[@]})); do
		i4="$(($i4+1))"
		temp1=( $( ls -a "${dirs[$((i4-1))]}") )
		partfiles=()
		i3=0
		while ((i3 < ${#temp1[@]})); do
			i3="$(($i3+1))"
			if [[ "${temp1[$((i3-1))]}" != "." ]] && [[ "${temp1[$((i3-1))]}" != ".." ]]; then
				partfiles[${#partfiles[@]}]="${temp1[$((i3-1))]}"
			fi
		done
		i5=0
		while ((i5 < ${#partfiles[@]})); do
			i5="$(($i5+1))"
			if [ -d "${partfiles[$((i5-1))]}" ]; then
				mkdir "../../build/FSSC-Builder/${parts[$((i1-1))]}/${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}"
			else
				SOURCE_FILE="${partfiles[$((i5-1))]}"
				EXT=""
				i2=0
				while ((i2 < ${#SOURCE_FILE})); do
					i2="$(($i2+1))"
					if [[ "${SOURCE_FILE:$(($i2-1)):1}" = "." ]]; then
						NAME="$EXT"
						EXT=""
					else
						EXT="${EXT}${SOURCE_FILE:$(($i2-1)):1}"
					fi
				done
				if [[ "$EXT" = "$SOURCE_FILE" ]]; then
					NAME="$EXT"
					EXT=""
				fi
				if [[ "$EXT" = "pwsl" ]] || [[ "$EXT" = "PWSL" ]] || [[ "$EXT" = "pwsle" ]] || [[ "$EXT" = "PWSLE" ]]; then
					echo "Compiling file ${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}"
					cp "${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}" ../../build/PowerSlash-userspace/
					oldcd=$(pwd)
					cd ../../build/PowerSlash-userspace
					chmod +x ./compile.sh
					./compile.sh "${partfiles[$((i5-1))]}" 1 "" "$auto"
					exit=$?
					if ((exit != 0)); then
						echo -e "${RED}Failed to compile ${dirs[$((i4-1))]}/${partfiles[$((i5-1))]} - process exited with code ${YELLOW}${exit}${NC}"
						exit $exit
					fi
					rm "${partfiles[$((i5-1))]}"
					cd "$oldcd"
					SOURCE_FILE="${partfiles[$((i5-1))]}"
					EXT=""
					i2=0
					while ((i2 < ${#SOURCE_FILE})); do
						i2="$(($i2+1))"
						if [[ "${SOURCE_FILE:$(($i2-1)):1}" = "." ]]; then
							NAME="$EXT"
							EXT=""
						else
							EXT="${EXT}${SOURCE_FILE:$(($i2-1)):1}"
						fi
					done
					if [[ "$EXT" = "$SOURCE_FILE" ]]; then
						NAME="$EXT"
						EXT=""
					fi
					if [[ "$EXT" = "pwsle" ]] || [[ "$EXT" = "PWSLE" ]]; then
						mv "../../build/PowerSlash-userspace/output/$NAME" "../../build/FSSC-Builder/${parts[$((i1-1))]}/${dirs[$((i4-1))]}/$NAME"
					else
						mv "../../build/PowerSlash-userspace/output/${NAME}.smc" "../../build/FSSC-Builder/${parts[$((i1-1))]}/${dirs[$((i4-1))]}/${NAME}.smc"
					fi
				else
					echo "Copying file ${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}"
					if [[ -d "${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}" ]]; then
						mkdir -p "../../build/FSSC-Builder/${parts[$((i1-1))]}/${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}"
					else
						cp "${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}" "../../build/FSSC-Builder/${parts[$((i1-1))]}/${dirs[$((i4-1))]}/${partfiles[$((i5-1))]}"
					fi
				fi
			fi
		done
	done
	cd "$src"
done
echo "
===== BUILDING FILESYSTEMS =====
"
cd ./build/FSSC-Builder
chmod +x ./build.sh
./build.sh "$auto"
ec=$?
if (($ec != 0)); then
	echo -e "${RED}Failed to build PC code - process exited with code ${YELLOW}$ec${NC}"
	exit $ec
fi
mv ./output.fssc "${src}/${proj}.fssc"
cd "$src"
echo "Done!"
echo "The output was saved in ${proj}.fssc"
