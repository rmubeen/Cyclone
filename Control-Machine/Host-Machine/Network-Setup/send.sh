original_ovx_switch="00:a4:23:05:00:00:00:01"
clone_ovx_switch="00:a4:23:05:00:00:00:04"

int_1_mac="52:54:00:aa:52:b8"
int_2_mac="52:54:00:49:a5:72"


original_1_string="{
\"$original_ovx_switch\":
	{
		\"ports\":
			{
				\"1\":{\"type\":\"GHOST\"},
				\"2\":{\"type\":\"H_CONNECTED\",\"mac\":\"$int_1_mac\"},
				\"3\":{\"type\":\"H_CONNECTED\",\"mac\":\"$int_2_mac\"},
				\"4\":{\"type\":\"DUMMY\"}
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
				\"4\":{\"type\":\"DUMMY\"}
			}
	}
}"



echo $original_1_string
echo $clone_1_string


curl -d "$original_1_string" http://192.168.2.113:9000/config
curl -d "$clone_1_string" http://192.168.2.113:9000/config


echo ""
