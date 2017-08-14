if [ -z "$1" ];
	then echo "Bridge name must be provided!";
	exit 1;
fi

echo "Creating bridge named $1"
ovs-vsctl add-br $1
ifconfig $1 up

echo "Adding GRE tunnels"
ovs-vsctl add-port $1 gre0 -- set interface gre0 type=gre options:remote_ip=10.10.10.20

echo "Internet should work now through $3"
ping google.com -c 1

virsh define Floodlight_VM.xml
virsh define LIME_VM.xml
virsh define OpenVx.xml

virt-manager