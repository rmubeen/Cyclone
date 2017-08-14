# Get dpids of all bridges on m1
m1_rb_dpid=$(sudo ovs-ofctl show rb | grep -Po '(?<=dpid:).+')
m1_gb_dpid=$(sudo ovs-ofctl show gb | grep -Po '(?<=dpid:).+')
m1_bb_dpid=$(sudo ovs-ofctl show bb | grep -Po '(?<=dpid:).+')

# Port of vm1 on m1
m1_int3_name=$(virsh dumpxml vm1 | grep -oP "vnet\d+")
m1_int3_port=$(sudo ovs-vsctl get Interface $m1_int3_name ofport)

# Port of vm2 on m1
m1_int4_name=$(virsh dumpxml vm2 | grep -oP "vnet\d+")
m1_int4_port=$(sudo ovs-vsctl get Interface $m1_int4_name ofport)

# Ports of vm3 on m1
m1_vm3_ints=$(virsh dumpxml vm3 | grep -oP "vnet\d+")
m1_vm3_ints_names=($m1_vm3_ints)

m1_int0_port=$(sudo ovs-vsctl get Interface ${m1_vm3_ints_names[0]} ofport)
m1_int1_port=$(sudo ovs-vsctl get Interface ${m1_vm3_ints_names[1]} ofport)
m1_int2_port=$(sudo ovs-vsctl get Interface ${m1_vm3_ints_names[2]} ofport)

# Mac/hardware addresses of interfaces on host machine

m1_int0_mac=$(cat /sys/class/net/${m1_vm3_ints_names[0]}/address)
m1_int1_mac=$(cat /sys/class/net/${m1_vm3_ints_names[1]}/address)
m1_int2_mac=$(cat /sys/class/net/${m1_vm3_ints_names[2]}/address)
m1_int3_mac=$(cat /sys/class/net/$m1_int3_name/address)
m1_int4_mac=$(cat /sys/class/net/$m1_int3_name/address)


printf "\ndpids of bridges on m1\n\n"

echo $m1_rb_dpid
echo $m1_gb_dpid
echo $m1_bb_dpid

printf "\nNames,mac addresses and ports of interfaces on host machine\n\n"

echo "m1_int0_name: ${m1_vm3_ints_names[0]}"
echo "m1_int1_name: ${m1_vm3_ints_names[1]}"
echo "m1_int2_name: ${m1_vm3_ints_names[2]}"
echo "m1_int3_name: $m1_int3_name"
echo "m1_int4_name: $m1_int4_name"

printf "\n"
echo "m1_int0_mac: $m1_int0_mac"
echo "m1_int1_mac: $m1_int1_mac"
echo "m1_int2_mac: $m1_int2_mac"
echo "m1_int3_mac: $m1_int3_mac"
echo "m1_int4_mac: $m1_int4_mac"

printf "\n"
echo "m1_int0_port: $m1_int0_port"
echo "m1_int1_port: $m1_int1_port"
echo "m1_int2_port: $m1_int2_port"
echo "m1_int3_port: $m1_int3_port"
echo "m1_int4_port: $m1_int4_port"
