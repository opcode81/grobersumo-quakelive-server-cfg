#!/usr/bin/python3.6
import os
import sys

class Mappool:
    def __init__(self):
        self.a = []
        
    def read(self, mappool_path):
        with open(mappool_path, "r") as f:
            self.a = f.readlines()
    
    def write(self, mappool_path, game_type):
        with open(mappool_path, "w") as f:
            for line in self.a:
                if not(line.startswith('#')):
                    f.write(line.rstrip() + '|' + game_type + '\n')
                
if __name__ == '__main__':
    argv = sys.argv[1:]
    if len(argv) != 1:
        print("usage: make_mappool_cfg.py <gametype>")
        sys.exit(1)

    maps = Mappool()
    root = os.path.dirname(os.path.realpath(__file__))
    maps.read(os.path.join(root, "mappool.base.txt"))
    maps.write(os.path.join(root, argv[0], "baseq3", "mappool.txt"), argv[0])