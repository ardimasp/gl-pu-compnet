#!/bin/sh

ip netns del red
ip netns del green
ip link del veth-r
ip link del veth-g
ip link del v-bridge

iptables -t nat -D POSTROUTING -s 10.1.1.0/24 -j MASQUERADE

