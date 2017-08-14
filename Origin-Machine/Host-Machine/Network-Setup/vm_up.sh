ovs-vsctl del-br $1
ip tuntap del mode tap dummy

sudo ifconfig eth0 up
sudo ifconfig eth1 up
sudo ifconfig eth2 up
sudo ifconfig eth3 up
sudo ifconfig eth4 up

#sleep 5
ovs-vsctl add-br $1
ifconfig $1 up

#sleep 5
ovs-vsctl add-port $1 eth1
ovs-vsctl add-port $1 eth2
ovs-vsctl add-port $1 eth3
ovs-vsctl add-port $1 eth4

#sleep 5
sudo ifconfig eth0 10.10.10.3/8

#sleep 5
ovs-vsctl add-port $1 gre0 -- set Interface gre0 type=gre options=remote_ip=10.10.10.6

sudo ip route add 10.10.3.50 src 10.10.10.3 dev $1
sudo ip route add 10.10.3.30 src 10.10.10.3 dev $1
sudo ip route add 10.10.3.20 src 10.10.10.3 dev $1
sudo ip route add 10.10.3.10 src 10.10.10.3 dev $1

#ovs-ofctl add-flow $1 dl_type=0x8000,nw_src=10.10.3.50/32,nw_dst=10.10.10.3/32,in_port=4,actions=LOCAL
#ovs-ofctl add-flow $1 dl_type=0x0800,nw_src=10.10.3.30/32,nw_dst=10.10.10.3/32,in_port=3,actions=LOCAL
#ovs-ofctl add-flow $1 dl_type=0x0800,nw_src=10.10.3.20/32,nw_dst=10.10.10.3/32,in_port=2,actions=LOCAL
#ovs-ofctl add-flow $1 dl_type=0x0800,nw_src=10.10.3.10/32,nw_dst=10.10.10.3/32,in_port=1,actions=LOCAL

#sleep 5
ip tuntap add mode tap dummy
ovs-vsctl add-port $1 dummy
ovs-vsctl set bridge $1 protocols=OpenFlow10
ovs-vsctl set-controller $1 tcp:10.10.10.9:6633

sleep 16
ping 10.10.3.10 -c 2
ping 10.10.3.20 -c 2
ping 10.10.3.30 -c 2
ping 10.10.3.50 -c 2
