# Grobersumo Quake Live Server Configuration

This project contains server configuration files for the Grobersume Quake Live servers:

* `iffa`: instagib free for all
* `wffa`: free for all with CA weapons at spawn

## Quake Live Dedicated Server Installation under Ubuntu Linux

Requirements:

* [**steamcmd** is installed](https://help.skysilk.com/support/solutions/articles/9000181921-how-to-install-and-use-steamcmd-on-ubuntu-linux) and accessible to user `steam` under `/home/steam/.steam/steamcmd` 
* Requirements which can be installed via apt-get:

  `sudo apt-get -y install python3 redis-server git build-essential`

Given these requirements, the actual dedicated server (along with minqlx extensions) can be installed by executing the following command as a sudo-capable user:

    sh install_qlds.sh

## Linux Services

We use [systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html) to control server (re)start and shutdown.

The systemd units use the shell scripts `launch_<server_name>.sh` to start the servers. 

We create a systemd unit for each server:
  * `/etc/systemd/system/ql-instagib.service` for the `iffa` server
  * `/etc/systemd/system/ql-allweapons.service` for the `wffa` server

These are the contents of the former,

    [Unit]
    Description=Quake Live Instagib
    After=syslog.target
    
    [Service]
    ExecStart="/home/steam/.quakelive/launch_iffa.sh" <zmq_stats_password>
    User=steam
    Group=steam
    Restart=on-failure
    RestartSec=5s
    KillMode=mixed
    
    [Install]
    WantedBy=multi-user.target

where the password needs to be set for stats to end up on qlstats.

After a unit file has been created, we can enable and start the service as follows:

    sudo systemctl enable ql-instagib
    sudo systemctl start ql-instagib

### Convenience Scripts

* `restart_iffa.sh`, `restart_wffa.sh` to restart the servers
* `stop_all.sh` to stop all servers

## Quake Live Server Configuration

Our configuration system factors out configuration that is common to all servers in the file `server.base.cfg`.

Settings specific to a server are to be set in `<server name>/baseq3/server.additional.cfg` and may override settings already defined in the base configuration.

The actual server configuration file `<server name>/baseq3/server.cfg` is automatically created by running:

    python make_server_cfg.py <server name>

This command usually does not need to be executed explicitly, as it is done automatically whenever the services are (re)started. Do not edit the auto-generated file.

## Workshop Items

Workshop items can be added by their ids (GET parameter `id`in Steam URL) by adding one line per id to `workshop.base.txt`. 

Any identifiers added there will automatically be written to each `server.cfg` as well as the respective `workshop.txt` file when running `make_server_cfg.py` (automatically done at server startup).

To try out new maps, simply add the desired workshop items and temporarily disable `qlx_enforceMappool` in `server.base.cfg` to be able to start maps not within the map pool.

## Map Pool

The common map pool for all servers is defined in `mappool.base.cfg`. It defines all the maps on rotation and furthermore restricts the maps one can call a vote for (or start manually via the console). To disable pool enforcement, set `qlx_enforceMappool`to 0.

The script `make_mappool_cfg.py` generates the `mappool.txt` file for a server (called automatically on server startup).
