if [ -z "$1" ];
	then echo "Address of the original machine should be provided.";
	exit 1;
fi

if [ -z "$2" ];
	then echo "Address of the clone machine should be provided.";
	exit 1;
fi
