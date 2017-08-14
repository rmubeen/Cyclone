if [ -z "$1" ];
        then echo "Bridge names must be provided!";
        exit 1;
fi

echo "Deleting bridge $1"
ifconfig $1 0
ovs-vsctl del-br $1


echo "Internet should work now"
ping google.com -c 1

virsh undefine Floodlight_VM
virsh undefine LIME_VM
virsh undefine OpenVx
