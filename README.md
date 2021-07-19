# Grobersumo Quake Live Server Configuration

This project contains server configuration files for the Grobersume Quake Live servers:

* `iffa`: instagib free for all
* `wffa`: free for all with CA weapons at spawn

Our scripts require Python 3 to run.

## Quake Live Dedicated Server Installation

Requirements:

* **Steam** for Linux (with steamcmd) installed, **Python 3** is installed

* User `steam` exists and has rights to write to the steamcmd directory

* Additional requirements which can be installed via apt-get:

  `sudo apt-get -y install redis-server git build-essential`

To install the server along with minqlx, simply run the installation script as a sudo-capable user:

    sh install_qlds.sh

For configured paths, inspect the script if necessary.

## Linux Services

We use [systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html) to control server (re)start and shutdown.

The systemd units use the shell scripts `launch_<server_name>.sh` to start the servers. For instance, for the iffa server, we create a systemd unit as follows under `/etc/systemd/system/ql-instagib.service`:

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

After the unit file has been created, we can enable and start the server as follows:

    sudo systemctl enable ql-instagib
    sudo systemctl start ql-instagib

### Convenience Scripts

* `restart_iffa.sh`, `restart_wffa.sh` to restart the servers
* `stop_all.sh` to stop all servers

## Quake Live Server Configuration

Our configuration system factors out configuration that is common to all servers in the file `server.base.cfg`.

Settings specific to a server are to be set in `<server name>/baseq3/server.additional.cfg`.

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