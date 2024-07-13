#!/bin/bash

logfile=/tmp/wireguard-resolve-dns.log

# truncate logfile
echo >$logfile

resolve_and_update() {
    local dns_name=$1
    local old_ip=$2
    local interface=$3
    local public_key=$4
    local port=$5

    output=$(host -t A $dns_name)
    if [[ $? != 0 ]]; then
        echo "fail to resolve dns $dns_name" >>$logfile
        echo $old_ip
        return
    fi

    new_ip=$(echo $output | awk '{ print $NF }')
    if [[ "$new_ip" != "$old_ip" ]]; then
        echo "$(date) $dns_name ip changed from $old_ip to $new_ip, update $interface" >>$logfile
        if wg set "$interface" peer "$public_key" endpoint "${new_ip}:${port}"; then
            echo $new_ip
            return
        fi
    fi
    echo $old_ip
}

DNS_NAME={{ resolve_dns.domain }}
PORT={{ wireguard_interfaces.wg0.port }}

old_ip=$(host -t A $DNS_NAME | awk '{ print $NF }')
while true; do
    old_ip=$(resolve_and_update $DNS_NAME "$old_ip" wg0 "{{ wireguard_interfaces.peers.p1.pubkey }}" $PORT)
    sleep 60
done
