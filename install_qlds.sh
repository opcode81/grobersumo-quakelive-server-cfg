#!/bin/sh
ROOT=`pwd`
STEAMCMD_DIR="/home/steam/.steam/steamcmd"
QLDS_SUBDIR="steamapps/common/qlds"

QLDS_DIR="${STEAMCMD_DIR}/${QLDS_SUBDIR}"
echo "QLDS_DIR=$QLDS_DIR"

# run the following section (until EOF) as user 'steam'
sudo -u steam bash << EOF
whoami

# Quake Live Dedicated Server installation
echo "Installing Quake Live Dedicated Server via steamcmd"
cd $STEAMCMD_DIR
./steamcmd.sh +login anonymous +force_install_dir ./${QLDS_SUBDIR}/ +app_update 349090 +quit 

# minqlx installation
# see: https://github.com/MinoMino/minqlx
cd /tmp
rm -rf ./minqlx
echo "Cloning minqlx"
git clone https://github.com/MinoMino/minqlx.git
cd minqlx
echo "Running make"
make
echo "Copying minqlx binaries"
echo cp bin/* ${QLDS_DIR}/
cp bin/* ${QLDS_DIR}/
# minqlx plugin installation
cd $QLDS_DIR
echo "Removing temporary plugins folder"
rm -rf minqlx-plugins
echo "Cloning plugins"
git clone https://github.com/MinoMino/minqlx-plugins.git
cd minqlx-plugins
# add our additional minqlx plugins
echo "Copying additional plugins"
cp ${ROOT}/minqlx-plugins/* .

EOF
# now running as original caller (no longer as steam)

whoami

# install Python 3 dependencies
echo "Installing Python dependencies"
cd $QLDS_DIR
sudo python3 -m pip install -r minqlx-plugins/requirements.txt


