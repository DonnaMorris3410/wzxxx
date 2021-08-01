#!/bin/bash
 
apt-get install -y cpulimit
cpulimit -e xmrig -l 85 -b
