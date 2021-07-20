#!/bin/bash
ZMQ_STATS_PW=`cat zmq_stats_password.txt`
python3 /home/fhammer/quakelive/make_server_cfg.py $1
python3 /home/fhammer/quakelive/make_mappool_txt.py $1
/home/steam/.steam/steamcmd/steamapps/common/qlds/run_server_x64_minqlx.sh \
+set fs_homepath /home/steam/.quakelive/$1 \
+set zmq_stats_password "${ZMQ_STATS_PW}"
