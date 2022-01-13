#!/usr/bin/env bash

cd ~/Dev/hosts-blocklists && \
    git pull && \
    wc -l dnsmasq/dnsmasq.blacklist.txt && \
    cp dnsmasq/dnsmasq.blacklist.txt /etc/dnsmasq.d/99-blacklist.conf
