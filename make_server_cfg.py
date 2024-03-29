#!/usr/bin/python3.6
import os
import sys
import collections
import re


class ServerCfg:
    def __init__(self):
        self.d = collections.OrderedDict()

    def read(self, cfg_path):
        with open(cfg_path, "r") as f:
            content = f.read()
            for key, value in re.findall(r'^set (\w+)\s+"(.*?)"', content, re.MULTILINE):
                self.d[key] = value

    def write(self, cfg_path):
        with open(cfg_path, "w") as f:
            for k, v in self.d.items():
                f.write('set %s "%s"\n' % (k, v))


def readWorkshopItems(path):
    with open(os.path.join(root, path), "r") as f:
        lines = [l.strip() for l in f.readlines()]
        workshopItems = [l for l in lines if len(l) > 0 and l[0] != "#"]
    return workshopItems


if __name__ == '__main__':
    argv = sys.argv[1:]
    if len(argv) != 1:
        print("usage: make_server_cfg.py <folder name containing baseq3/server.add.cfg>")
        sys.exit(1)

    root = os.path.dirname(os.path.realpath(__file__))

    workshopItems = readWorkshopItems("workshop.base.txt")
    forcedWorkshopItems = readWorkshopItems("workshop_forced.base.txt")

    cfg = ServerCfg()
    cfg.read(os.path.join(root, "server.base.cfg"))
    cfg.read(os.path.join(root, argv[0], "baseq3", "server.additional.cfg"))
    cfg.d["qlx_workshopReferences"] = ", ".join(forcedWorkshopItems)
    cfg.write(os.path.join(root, argv[0], "baseq3", "server.cfg"))
    
    with open(os.path.join(root, argv[0], "baseq3", "workshop.txt"), "w") as f:
        for w in workshopItems + forcedWorkshopItems:
            f.write(w + "\n")

    with open(os.path.join(root, "zmq_stats_password.txt"), "r") as f:
        zmq_stats_password = f.read().strip()
    with open(os.path.join(root, argv[0], "baseq3", "zmqpass.txt"), "w") as f:
        f.write("stats_stats=" + zmq_stats_password)
