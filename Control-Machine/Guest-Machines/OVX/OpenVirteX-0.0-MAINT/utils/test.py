import json

with open("tata.json") as f:
	x = f.read()
	y = json.loads(x)
	print json.dumps(y, indent=4, sort_keys=True)
