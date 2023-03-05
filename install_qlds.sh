#!/bin/sh
STEAMCMD="/usr/games/steamcmd"
ROOT=`pwd`
STEAM_DIR="/home/steam/Steam"
QLDS_SUBDIR="steamapps/common/qlds"

QLDS_DIR="${STEAM_DIR}/${QLDS_SUBDIR}"
echo "QLDS_DIR=$QLDS_DIR"

# Quake Live Dedicated Server installation
echo "Installing Quake Live Dedicated Server via steamcmd"
cd $STEAM_DIR

# run the following section (until EOF) as user 'steam'
sudo -u steam bash << EOF
whoami

$STEAMCMD +force_install_dir $QLDS_DIR/ +login anonymous +app_update 349090 +quit
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


