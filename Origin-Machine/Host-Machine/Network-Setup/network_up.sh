if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ];
	then echo "5 bridge names must be provided! rb gb bb yb pb";
	exit 1;
fi

#sudo service nfs-kernel-server restart
sleep 2
# Network Setup:
# rb vm4 vm1
# gb vm4 vm2
# bb vm4
# yb vm4 vm3
# pb vm4 vm5

echo "Creating bridge named $1"
ovs-vsctl add-br $1
ifconfig $1 up

echo "Creating bridge named $2"
ovs-vsctl add-br $2
ifconfig $2 up

echo "Creating bridge named $3"
ovs-vsctl add-br $3
ifconfig $3 up

echo "Creating bridge named $4"
ovs-vsctl add-br $4
ifconfig $4 up

echo "Creating bridge named $5"
ovs-vsctl add-br $5
ifconfig $5 up

# echo "Adding GRE Tunnel"
ovs-vsctl add-port $3 gre0 -- set Interface gre0 type=gre options:remote_ip=10.10.10.169
ovs-vsctl add-port $3 gre1 -- set Interface gre1 type=gre options:remote_ip=10.10.10.10

echo "Internet should work now"
ping google.com -c 1

echo "Setting MTU"
#sudo ifconfig eth0 mtu 2000
sleep 2

#echo "Setting ib0 IP Address"
sudo ifconfig ib0 10.10.10.168/25
sudo ifconfig ib0 mtu 1500

#sudo ifconfig $1 mtu 2000
#sudo ifconfig $2 mtu 2000
#sudo ifconfig $3 mtu 2000
#sudo ifconfig $4 mtu 2000
#sudo ifconfig $5 mtu 2000
sleep 2

echo "Adding Rules"

sudo ip route add 10.10.10.7 src 10.10.10.20 dev bb # Linux Rule
sleep 5

sudo ip route add 10.10.10.8 src 10.10.10.20 dev bb # Linux Rule
sleep 5

sudo ip route add 10.10.10.9 src 10.10.10.20 dev bb # Linux Rule
sleep 5

sudo ovs-ofctl add-flow bb dl_type=0x0800,nw_src=10.10.10.7/32,nw_dst=10.10.10.20/32,in_port=2,actions=LOCAL # OVS Rules
sleep 5

sudo ovs-ofctl add-flow bb dl_type=0x0800,nw_src=10.10.10.8/32,nw_dst=10.10.10.20/32,in_port=2,actions=LOCAL # OVS Rules
sleep 5

sudo ovs-ofctl add-flow bb dl_type=0x0800,nw_src=10.10.10.9/32,nw_dst=10.10.10.20/32,in_port=2,actions=LOCAL # OVS Rules
sleep 5

virsh define vm1.xml
virsh define vm2.xml
virsh define vm3.xml
virsh define vm4.xml
virsh define vm5.xml



virt-manager


