#!/bin/bash

if [ -z "$1" ];
then 
	echo "Need destination IP";
	exit 1;
fi

if [ -z "$2" ];
then 
	echo "Need destination port number";
	exit 1;
fi

if [ -z "$3" ];
then 
	echo "Need dpid";
	exit 1;
fi
curl -d "{\"switch\": \"$3\", \"name\":\"mod-$1_to_$2_on_$3\", \"priority\":\"100\", \"dst-ip\":\"$1\", \"active\":\"true\", \"actions\":\"output=$2\"}" http://10.10.10.8:8080/wm/staticflowentrypusher/json
echo ""
echo "Wrote rule that forwards dest IP $1 to port $2 on switch $3"
