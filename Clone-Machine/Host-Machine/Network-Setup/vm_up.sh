echo "Give eth0 IP Address"
ifconfig eth0 20.20.20.20/24

echo "Starting eth ports"
ifconfig eth1 up
ifconfig eth2 up

echo "Creating bridge named $1"
ovs-vsctl add-br $1
ifconfig $1 up

echo "Adding GRE Tunnel"
ovs-vsctl add-port $1 gre0 -- set Interface gre0 type=gre options:remote_ip=20.20.20.30

echo "Adding Dummy Port to System"
ip tuntap add mode tap dummy

echo "Adding ports to $1"
ovs-vsctl add-port $1 eth1
ovs-vsctl add-port $1 eth2
ovs-vsctl add-port $1 dummy

echo "Printing Data"
ovs-ofctl show $1