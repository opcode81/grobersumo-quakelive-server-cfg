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
            for key, value in re.findall(r'set (\w+)\s+"(.*?)"', content, re.MULTILINE):
                self.d[key] = value

    def write(self, cfg_path):
        with open(cfg_path, "w") as f:
            for k, v in self.d.items():
                f.write(f'set {k} "{v}"\n')


if __name__ == '__main__':
    argv = sys.argv[1:]
    if len(argv) != 1:
        print("usage: make_server_cfg.py <folder name containing baseq3/server.add.cfg>")
        sys.exit(1)

    cfg = ServerCfg()
    cfg.read("server.base.cfg")
    cfg.read(os.path.join(argv[0], "baseq3", "server.additional.cfg"))
    cfg.write(os.path.join(argv[0], "baseq3", "server.cfg"))


