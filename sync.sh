### You can add your own dependencies here ###
# Example: git clone --single-branch --branch <branch> <URL to your repository> <path>
# $SRC is the PowerSlash-Builder source tree path.
SRC="$(dirname $BASH_SOURCE)"
if [ -d "${SRC}/build" ]; then
  rm -rf "${SRC}/build"
fi
mkdir "${SRC}/build"

# Required dependencies - do NOT remove them!
git clone https://github.com/adazem009/PowerSlash "$SRC/build/PowerSlash" &
git clone https://github.com/adazem009/FSSC-Builder "$SRC/build/FSSC-Builder" &

# Custom dependencies
if [ -d "${SRC}/parts" ]; then
  rm -rf "${SRC}/parts"
fi
mkdir "${SRC}/parts"
# PowerSlash userspace compiler
git clone https://github.com/EarthOS-SMC/PowerSlash-userspace "${SRC}/build/PowerSlash-userspace" &
# EarthOS MBR
git clone https://github.com/EarthOS-SMC/EarthOS-MBR "${SRC}/parts/mbr" &
# EarthOS little bootloader
git clone https://github.com/EarthOS-SMC/little-bootloader "${SRC}/parts/lbl" &
# EarthOS kernel
git clone https://github.com/EarthOS-SMC/EarthOS-kernel "${SRC}/parts/kernel" &
# EarthOS init system
git clone https://github.com/EarthOS-SMC/init "${SRC}/parts/init" &
# user-setup
git clone https://github.com/EarthOS-SMC/user-setup "${SRC}/parts/user-setup" &
# EarthOS installer
#if [ -d "${SRC}/content/earthos/install" ]; then
#	rm -rf "${SRC}/content/earthos/install"
#fi
#git clone https://github.com/adazem009/EarthOS-installer "${SRC}/content/earthos/install" &

wait

# Remove unneeded files
#rm "$SRC/content/earthos/install/LICENSE"
#rm "$SRC/content/earthos/install/README.md"
#rm -rf "$SRC/content/earthos/install/.git"
# Required dependencies
rm "$SRC/build/FSSC-Builder/project.conf"
rm -rf "$SRC/build/FSSC-Builder/config"
rm -rf "$SRC/build/FSSC-Builder/content"
cp $SRC/project.conf "$SRC/build/FSSC-Builder/project.conf"
cp -r $SRC/config "$SRC/build/FSSC-Builder/config"
mkdir "$SRC/build/FSSC-Builder/content"

# Auto chmod +x
chmod +x build.sh
