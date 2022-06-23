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

