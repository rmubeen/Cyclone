sudo ifconfig eth1 down
sudo ifconfig eth1 up
sudo ifconfig eth1 0
sudo ifconfig eth1 10.10.10.9
echo "Setting MTU: 1100"
sudo ifconfig eth1 mtu 1100
echo "MTU Set"
ping 10.10.10.20 -c 2
