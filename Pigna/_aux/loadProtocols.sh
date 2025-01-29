#!/bin/bash



echo "Store.At.ProtList = ObjectList{ChildClassName = \"SimpleString\";};" > /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/loadProtocols.script

cd /usr/local/PinnacleSiteData/clinical/Protocols
for f in *; do
	echo "Store .At .ProtList .CreateChild = \"\";" >>  /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/loadProtocols.script
	echo "Store .At .ProtList .Last .Value = \"${f}\";" >>  /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/loadProtocols.script
done
