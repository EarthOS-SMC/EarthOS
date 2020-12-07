### You can add your own dependencies here ###
# Example: git clone --single-branch --branch <branch> <URL to your repository> <path>
# $SRC is the PowerSlash-Builder source tree path.
SRC="$(dirname $BASH_SOURCE)"
if [ -d "${SRC}/build" ]; then
  rm -rf "${SRC}/build"
fi
mkdir "${SRC}/build"

# Required dependencies - do NOT remove them!
git clone https://github.com/adazem009/PowerSlash "$SRC/PowerSlash"
git clone https://github.com/adazem009/FSSC-Builder "$SRC/FSSC-Builder"
rm "$SRC/build/FSSC-Builder/project.conf"
rm -rf "$SRC/build/FSSC-Builder/config"
rm -rf "$SRC/build/FSSC-Builder/content"
cp $SRC/project.conf "$SRC/build/FSSC-Builder/project.conf"
cp -r $SRC/config "$SRC/build/FSSC-Builder/config"
mkdir "$SRC/build/FSSC-Builder/content"

# Custom dependencies
# EarthOS kernel
if [ -d "${SRC}/content/earthos/kernel" ]; then
	rm -rf "${SRC}/content/earthos/kernel"
fi
git clone https://github.com/EarthOS-kernel "${SRC}/content/earthos/kernel"
rm "$SRC/content/earthos/kernel/LICENSE"
rm "$SRC/content/earthos/kernel/README.md"
# EarthOS installer
if [ -d "${SRC}/content/earthos/install" ]; then
	rm -rf "${SRC}/content/earthos/install"
fi
git clone https://github.com/EarthOS-installer "${SRC}/content/earthos/install"
rm "$SRC/content/earthos/install/LICENSE"
rm "$SRC/content/earthos/install/README.md"
# EarthOS bootloader (EBL)
if [ -d "${SRC}/content/earthos/ebl" ]; then
	rm -rf "${SRC}/content/earthos/ebl"
fi
git clone https://github.com/EBL "${SRC}/content/earthos/ebl"
rm -rf "$SRC/content/earthos/ebl/.git"
rm "$SRC/content/earthos/ebl/LICENSE"
rm "$SRC/content/earthos/ebl/README.md"
