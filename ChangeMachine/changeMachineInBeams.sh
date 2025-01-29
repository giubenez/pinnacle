#!/bin/sh

machineVal=$1

sed "s/MachineNameAndVersion = .*/MachineNameAndVersion = \"${machineVal}\";/g" /usr/local/PinnacleSiteData/clinical/Scripts/ChangeMachine/tmp/beamuf.out > /usr/local/PinnacleSiteData/clinical/Scripts/ChangeMachine/tmp/beamuf.edit.out

 

