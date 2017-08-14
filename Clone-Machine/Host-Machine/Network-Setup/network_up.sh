if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ];
	then echo "5 bridge names must be provided! rb gb bb yb pb";
	exit 1;
fi

#bash network_down.sh rb gb bb yb pb


echo "Creating bridge named $1"
ovs-vsctl add-br $1
ifconfig $1 up
#ifconfig $1 mtu 2000

echo "Creating bridge named $2"
ovs-vsctl add-br $2
ifconfig $2 up
#ifconfig $2 mtu 2000


echo "Creating bridge named $3"
ovs-vsctl add-br $3
ifconfig $3 up
#ifconfig $3 mtu 2000


echo "Creating bridge named $4"
ovs-vsctl add-br $4
ifconfig $4 up
#ifconfig $4 mtu 2000


echo "Creating bridge named $5"
ovs-vsctl add-br $5
ifconfig $5 up
#ifconfig $5 mtu 2000


echo "Adding GRE Tunnel"
ovs-vsctl add-port bb gre0 -- set Interface gre0 type=gre options:remote_ip=10.10.10.168


echo "Internet should work now"
ping google.com -c 1

echo "Adding Rules"
# Linux Rule

sudo ip route add 10.10.10.7 src 10.10.10.30 dev bb # Linux Rule
sleep 5

sudo ip route add 10.10.10.8 src 10.10.10.30 dev bb # Linux Rule
sleep 5

sudo ip route add 10.10.10.9 src 10.10.10.30 dev bb # Linux Rule
sleep 5

sudo ovs-ofctl add-flow bb dl_type=0x0800,nw_src=10.10.10.7/32,nw_dst=10.10.10.30/32,in_port=2,actions=LOCAL # OVS Rules
sleep 5

sudo ovs-ofctl add-flow bb dl_type=0x0800,nw_src=10.10.10.8/32,nw_dst=10.10.10.30/32,in_port=2,actions=LOCAL # OVS Rules
sleep 5

sudo ovs-ofctl add-flow bb dl_type=0x0800,nw_src=10.10.10.9/32,nw_dst=10.10.10.30/32,in_port=2,actions=LOCAL # OVS Rules
sleep 5

virsh define vm1.xml
virsh define vm2.xml
virsh define vm3.xml
virsh define vm4.xml
virsh define vm5.xml

echo "Setting ib0 ip"
sudo ifconfig ib0 10.10.10.169/25

sudo ifconfig ib0 mtu 1500
#sudo ifconfig eth0 mtu 2000


# echo "Adding Mount Point"
sudo mount -v 10.10.10.20:/var/lib/libvirt/images/Backup /var/lib/libvirt/images/Backup

sudo virt-manager &
