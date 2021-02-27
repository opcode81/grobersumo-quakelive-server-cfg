#!/bin/bash
python3.6 /home/fhammer/quakelive/make_server_cfg.py wffa
python3.6 /home/fhammer/quakelive/make_mappool_txt.py wffa
/home/steam/.steam/steamcmd/steamapps/common/qlds/run_server_x64_minqlx.sh \
+set fs_homepath /home/steam/.quakelive/wffa \
+set zmq_stats_password "$1"

