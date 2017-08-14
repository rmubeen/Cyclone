if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ];
	then echo "5 bridge names must be provided! rb gb bb yb pb";
	exit 1;
fi


echo "Deleting gre ports"
ovs-vsctl del-port $3 gre0

echo "Deleting bridge $1"
ifconfig $1 0
ovs-vsctl del-br $1

echo "Deleting bridge $2"
ifconfig $2 0
ovs-vsctl del-br $2

echo "Deleting bridge $3"
ifconfig $3 0
ovs-vsctl del-br $3

echo "Deleting bridge $4"
ifconfig $4 0
ovs-vsctl del-br $4

echo "Deleting bridge $5"
ifconfig $5 0
ovs-vsctl del-br $5

#echo "Resetting ib0 ip"
#sudo ifconfig ib0 0

echo "Internet should work now"
ping google.com -c 1

virsh undefine vm1
virsh undefine vm2
virsh undefine vm3
virsh undefine vm4
virsh undefine vm5


