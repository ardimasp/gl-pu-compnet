#!/bin/sh

ip netns del red
ip netns del green
ip link del veth-r
ip link del veth-g
ovs-vsctl del-br v-bridge
