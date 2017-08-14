# Sending Topology to LIME


if [ -z "$6" ];
	then echo "sudo bash LIME_MIGRATION.sh dpid1 dpid2 VM1 VM2 VM3 VM4";
	exit 1;
fi

original_ovx_switch="00:a4:23:05:00:00:00:01"
clone_ovx_switch="00:a4:23:05:00:00:00:02"

int_1_mac=$3
int_2_mac=$4
int_3_mac=$5


original_1_string="{
\"$original_ovx_switch\":
	{
		\"ports\":
			{
				\"1\":{\"type\":\"GHOST\"},
				\"2\":{\"type\":\"H_CONNECTED\",\"mac\":\"$int_1_mac\"},
				\"3\":{\"type\":\"H_CONNECTED\",\"mac\":\"$int_2_mac\"},
				\"4\":{\"type\":\"H_CONNECTED\",\"mac\":\"$int_3_mac\"},
				\"5\":{\"type\":\"DUMMY\"}
			}
	}
}"

clone_1_string="{
\"$clone_ovx_switch\":
	{
		\"ports\":
			{
				\"1\":{\"type\":\"GHOST\"},
				\"2\":{\"type\":\"EMPTY\"},
				\"3\":{\"type\":\"EMPTY\"},
				\"4\":{\"type\":\"EMPTY\"},
				\"5\":{\"type\":\"DUMMY\"},
			}
		\"original\": \"00:a4:23:05:00:00:00:01\"
	}
}"


echo $original_1_string
echo $clone_1_string

curl -d "$original_1_string" http://10.10.10.8:9000/config
curl -d "$clone_1_string" http://10.10.10.8:9000/config

printf "Topology to LIME Sent.\nVIRTUAL NETWORKING - START MAKING\n"

# # --------------------------------------------------------------------------------

# Delete any old Virtual Network with same Tenant ID.
python ovxctl.py -n removeNetwork 1 
# sleep 2

# tcp:<lime_address>:<lime_port>
# Create Network. LIME become controller of this virtual network.
python ovxctl.py -n createNetwork tcp:10.10.10.8:6633 10.10.3.1 24
# sleep 3

# switch 1 physical dpid
# We create a virtual switch.
python ovxctl.py -n createSwitch 1 $1
# sleep 3

# switch 2 physcial dpid
# We create another switch.
python ovxctl.py -n createSwitch 1 $2
# sleep 3


# # create ports on both switches
# # Tenant ID, DPID, PORT
python ovxctl.py -n createPort 1 $1 1
python ovxctl.py -n createPort 1 $1 2
python ovxctl.py -n createPort 1 $1 3
python ovxctl.py -n createPort 1 $1 4
python ovxctl.py -n createPort 1 $1 5

# sleep 4
printf "\n"

python ovxctl.py -n createPort 1 $2 1
python ovxctl.py -n createPort 1 $2 2
python ovxctl.py -n createPort 1 $2 3
python ovxctl.py -n createPort 1 $2 4
python ovxctl.py -n createPort 1 $2 5

# # sleep 4
# printf "\n"

# # # create connection between both switches (give virtual dpid)
python ovxctl.py -n connectLink 1 00:a4:23:05:00:00:00:01 1 00:a4:23:05:00:00:00:02 1 spf 1

# read -p "Press enter to continue: Link worked"


# # # connect vms to original ovs open virtual switch
# # # Tenant, VPID, VPORT, MAC
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:01 2 $int_1_mac
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:01 3 $int_2_mac
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:01 4 $int_3_mac
printf "\n"



python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 2 ce:5a:b9:7c:87:84
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 3 ce:5a:b9:7c:87:85 
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 4 ce:5a:b9:7c:87:86


# find out if placeholders need to be started
python ovxctl.py -n startPort 1 00:a4:23:05:00:00:00:02 2
python ovxctl.py -n startPort 1 00:a4:23:05:00:00:00:02 3
python ovxctl.py -n startPort 1 00:a4:23:05:00:00:00:02 4

# sleep 4
printf "\n"

# # connect something to dummy ports - Not exactly sure why? -- Needed to start ports
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:01 5 ce:5a:b9:7c:87:88
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 5 ff:ff:ff:ff:ff:ff 
# sleep 4
printf "\n"

# Coughli started dummy ports
python ovxctl.py -n startPort 1 00:a4:23:05:00:00:00:01 5
python ovxctl.py -n startPort 1 00:a4:23:05:00:00:00:02 5
# sleep 2

python ovxctl.py -n startNetwork 1
read -p "Press enter to continue before adding flows (Assign VM ips)"
# echo "Ping should be enable now"
# read -p "Press enter to continue, Network has started, ping should be possible, floodlight should have topology"
# # sleep 20

# Delete Flows
# curl http://10.10.10.7:8080/wm/staticflowentrypusher/clear/all/json 
# echo "Adding Flows"

# Michael boy's flows
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm11\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"3\", \"dst-mac\":\"$int_1_mac\", \"actions\":\"output=2\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm12\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"4\", \"dst-mac\":\"$int_1_mac\", \"actions\":\"output=2\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm13\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"5\", \"dst-mac\":\"$int_1_mac\", \"actions\":\"output=2\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json


curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm21\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"2\", \"dst-mac\":\"$int_2_mac\", \"actions\":\"output=3\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm22\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"4\", \"dst-mac\":\"$int_2_mac\", \"actions\":\"output=3\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm23\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"5\", \"dst-mac\":\"$int_2_mac\", \"actions\":\"output=3\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json


curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm31\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"2\", \"dst-mac\":\"$int_3_mac\", \"actions\":\"output=4\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm32\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"3\", \"dst-mac\":\"$int_3_mac\", \"actions\":\"output=4\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm33\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"5\", \"dst-mac\":\"$int_3_mac\", \"actions\":\"output=4\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json


# curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm51\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"2\", \"dst-mac\":\"$int_5_mac\", \"actions\":\"output=5\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
# curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm52\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"3\", \"dst-mac\":\"$int_5_mac\", \"actions\":\"output=5\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json
# curl -d "{\"switch\":\"00:a4:23:05:00:00:00:01\", \"name\":\"vm53\", \"priority\":\"100\", \"active\":\"true\", \"ingress-port\":\"4\", \"dst-mac\":\"$int_5_mac\", \"actions\":\"output=5\"}" http://10.10.10.7:8080/wm/staticflowentrypusher/json


# echo "Flows Added"
echo "Printing Flows"
curl http://10.10.10.7:8080/wm/staticflowentrypusher/list/all/json
# printf "\n"
# sleep 10

# # # ----------------------------------------------------------------------------------------
read -p "Press enter to continue for migration"
date > VM_Migration_Default.txt
curl http://10.10.10.8:9000/startMigration


# read -p "Press continue to migrate VM1"
date >> VM_Migration_Default.txt
data="{\"originalHost\":\"10.10.10.20\",\"destinationHost\":\"10.10.10.30\",\"domain\":\"vm1\",\"originalDpid\":\"00:a4:23:05:00:00:00:01\",\"cloneDpid\":\"00:a4:23:05:00:00:00:02\",\"connectedPort\":\"2\",\"clonePort\":\"2\"}"
curl -d "$data" http://10.10.10.8:9000/migrateVM
python ovxctl.py -n disconnectHost 1 1
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 2 $int_1_mac


# read -p "Press continue to migrate VM2"
date >> VM_Migration_Default.txt
data="{\"originalHost\":\"10.10.10.20\",\"destinationHost\":\"10.10.10.30\",\"domain\":\"vm2\",\"originalDpid\":\"00:a4:23:05:00:00:00:01\",\"cloneDpid\":\"00:a4:23:05:00:00:00:02\",\"connectedPort\":\"3\",\"clonePort\":\"3\"}"
curl -d "$data" http://10.10.10.8:9000/migrateVM
python ovxctl.py -n disconnectHost 1 2
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 3 $int_2_mac

# read -p "Press continue to migrate VM3"
date >> VM_Migration_Default.txt
data="{\"originalHost\":\"10.10.10.20\",\"destinationHost\":\"10.10.10.30\",\"domain\":\"vm3\",\"originalDpid\":\"00:a4:23:05:00:00:00:01\",\"cloneDpid\":\"00:a4:23:05:00:00:00:02\",\"connectedPort\":\"4\",\"clonePort\":\"4\"}"
curl -d "$data" http://10.10.10.8:9000/migrateVM
python ovxctl.py -n disconnectHost 1 3
python ovxctl.py -n connectHost 1 00:a4:23:05:00:00:00:02 4 $int_3_mac




# echo "Finishing Migration"
curl 'http://10.10.10.8:9000/finishMigration/00:a4:23:05:00:00:00:01'
date >> VM_Migration_Default.txt
echo "Lime Complete"

# # ----------------------------------------------------------------------------------
