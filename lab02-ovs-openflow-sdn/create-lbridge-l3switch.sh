#!/bin/sh

# create netns red and green
ip netns add red
ip netns add green

# create veth
ip link add veth-r type veth peer name veth-br-r
ip link add veth-g type veth peer name veth-br-g

# create v-bridge
ip link add v-bridge type bridge

# attach veth
ip link set veth-r netns red
ip link set veth-g netns green
ip link set veth-br-r master v-bridge
ip link set veth-br-g master v-bridge

# activate veth
ip netns exec red ip link set dev veth-r up
ip netns exec green ip link set dev veth-g up
ip link set dev veth-br-r up
ip link set dev veth-br-g up
ip link set dev v-bridge up

# assign ip address
ip netns exec red ip a add 10.1.1.2/24 dev veth-r
ip netns exec green ip a add 10.1.1.3/24 dev veth-g

# test
ip netns exec red ping 10.1.1.3 -c 3

# enable ipv4 forwarding
sysctl -w net.ipv4.ip_forward=1

# assign ip address to the v-bridge
ip a add 10.1.1.1/24 dev v-bridge

# set routing table in the red and green
ip netns exec red ip route add default via 10.1.1.1 
ip netns exec green ip route add default via 10.1.1.1 

# set NAT
iptables -t nat -A POSTROUTING -s 10.1.1.0/24 -j MASQUERADE

# test
ip netns exec red ping 1.1.1.1 -c 3
