#!/bin/bash
./make_server_cfg.py iffa
/home/steam/.steam/steamcmd/steamapps/common/qlds/run_server_x64_minqlx.sh \
+set fs_homepath /home/steam/.quakelive/iffa \
+set zmq_stats_password "$1"

