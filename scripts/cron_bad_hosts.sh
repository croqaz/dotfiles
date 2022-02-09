#!/usr/bin/env bash
#
# CRON job script to update bad hosts for DnsMasq
#
date '+%Y-%m-%d %H:%M:%S'
ls -lh /etc/dnsmasq.d/99-blacklist.conf
wc -l /etc/dnsmasq.d/99-blacklist.conf
python ~/.local/scripts/update_bad_hosts.py /etc/dnsmasq.d/99-blacklist.conf
