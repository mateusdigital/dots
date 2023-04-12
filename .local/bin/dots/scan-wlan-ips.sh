#!/bin/bash

## Depends on expose-wsl

echo "Scanning network for connected ips...";

readonly wsl_exposed_ip="$(expose-wsl | grep "WSL should" | cut -d":" -f2 | tr -d " ")";
readonly network_prefix="$(echo "${wsl_exposed_ip}" | cut -d"." -f1-3)"
readonly ip_list=$(nmap -sn "${network_prefix}.0/24" | grep "Nmap scan report for" | awk '{print $5}')

echo "WSL exposed ip: $wsl_exposed_ip";
echo "Connected ips:";
for ip_address in $ip_list; do
    echo "    $ip_address";
done
