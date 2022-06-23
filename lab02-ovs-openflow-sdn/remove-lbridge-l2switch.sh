#!/bin/sh

ip netns del red
ip netns del green
ip link del veth-r
ip link del veth-g
ip link del v-bridge
