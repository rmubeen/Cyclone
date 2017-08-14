m1_int0_name=$(sudo bash info.sh | grep "m1_int0_name" | grep -Po "vnet\d+")
m1_int1_name=$(sudo bash info.sh | grep "m1_int1_name" | grep -Po "vnet\d+")
m1_int2_name=$(sudo bash info.sh | grep "m1_int2_name" | grep -Po "vnet\d+")
m1_int3_name=$(sudo bash info.sh | grep "m1_int3_name" | grep -Po "vnet\d+")
m1_int4_name=$(sudo bash info.sh | grep "m1_int4_name" | grep -Po "vnet\d+")

printf "\nNames,mac addresses and ports of interfaces on m1\n\n"

echo "m1_int0_name: $m1_int0_name"
echo "m1_int1_name: $m1_int1_name"
echo "m1_int2_name: $m1_int2_name"
echo "m1_int3_name: $m1_int3_name"
echo "m1_int4_name: $m1_int4_name"

printf "\n"
echo "m1_int0_mac: $m1_int0_mac"
echo "m1_int1_mac: $m1_int1_mac"
echo "m1_int2_mac: $m1_int2_mac"
echo "m1_int3_mac: $m1_int3_mac"
echo "m1_int4_mac: $m1_int4_mac"
