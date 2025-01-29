#!/bin/zsh
cd /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/temp/

xVal=$1
yVal=$2
zVal=$3
dir=$4
extName=$5

rm -rf tmpRoi
mkdir tmpRoi
mv ROI.roi tmpRoi/ROI.roi
cd tmpRoi
csplit -k ROI.roi '/Beginning/' {100}

rm xx00

for f in xx*
do
	# echo $f
	name=$(head -1 $f | sed 's/\/\/  Beginning of ROI: //')
	# echo $name
	csplit -f tmpF $f '/surface_mesh/' 
	mv tmpF00 "$name"
done

#C = couch removal

echo "x = $xVal" # L max, R min
echo "y = $yVal" # A max, P min 
echo "z = $zVal"
echo "direction = $dir" 
echo "External = $extName" 

if [[ $dir == "C" ]]; then
	/usr/xpg4/bin/awk -v zVali="$zVal" '/^-?[0-9]/ &&	$3 > zVali - 0.5 && $3 < zVali + 0.5 { print $0 }' CouchSurface > slice.out
	/usr/xpg4/bin/awk -v xVali="$xVal" -v yVali="$yVal" ' ($1 > xVali - 0.5 && $1 < xVali + 0.5) ||  ($2 > yVali - 0.5 && $2 < yVali + 0.5)  { print $1" "$2 }' slice.out > max.out
else
	/usr/xpg4/bin/awk -v zVali="$zVal" '/^-?[0-9]/ &&	$3 > zVali - 0.15 && $3 < zVali + 0.15 { print $0 }' ${extName} > slice.out
	/usr/xpg4/bin/awk -v xVali="$xVal" -v yVali="$yVal" ' ($1 > xVali - 0.15 && $1 < xVali + 0.15) ||  ($2 > yVali - 0.15 && $2 < yVali + 0.15)  { print $1" "$2 }' slice.out > max.out
fi





#perl -e 'print sort { $a<=>$b } <>' 
case $dir in

  A)
	echo "
	PoiList.ChildrenEachCurrent.#\"@\".IF.PoiList.Current.Name.STRINGEQUALTO.#\"#repere ant\".THEN.PoiList.Current.Destroy = 1;
	CreateNewPOI = \"\";
	PoiList.Current.Name = \"repere ant\";" >> newRepere.script
	dyVal=$(cut -d " " -f2 max.out | perl -e 'print sort { $a<=>$b } <>'  | tail -1)
	dyVal=$((dyVal - yVal))
	dyVal=$(printf "%.*f\n" 1 $dyVal)
	yVal=$((dyVal + yVal))
    ;;
  P)
	echo "
	PoiList.ChildrenEachCurrent.#\"@\".IF.PoiList.Current.Name.STRINGEQUALTO.#\"#repere post\".THEN.PoiList.Current.Destroy = 1;
	CreateNewPOI = \"\";
	PoiList.Current.Name = \"repere post\";" >> newRepere.script
	dyVal=$(cut -d " " -f2 max.out | perl -e 'print sort { $a<=>$b } <>'  | head -1)
	dyVal=$((dyVal - yVal))
	dyVal=$(printf "%.*f\n" 1 $dyVal)
	yVal=$((dyVal + yVal))
    ;;
  L)
	echo "
	PoiList.ChildrenEachCurrent.#\"@\".IF.PoiList.Current.Name.STRINGEQUALTO.#\"#repere lat sin\".THEN.PoiList.Current.Destroy = 1;
	CreateNewPOI = \"\";
	PoiList.Current.Name = \"repere lat sin\";" >> newRepere.script
	dxVal=$(cut -d " " -f1 max.out |perl -e 'print sort { $a<=>$b } <>'  | tail -1)
	dxVal=$((dxVal - xVal))
	dxVal=$(printf "%.*f\n" 1 $dxVal)
	xVal=$((dxVal + xVal))
    ;;
  R)
	echo "
	PoiList.ChildrenEachCurrent.#\"@\".IF.PoiList.Current.Name.STRINGEQUALTO.#\"#repere lat destro\".THEN.PoiList.Current.Destroy = 1;
	CreateNewPOI = \"\";
	PoiList.Current.Name = \"repere lat destro\";" >> newRepere.script
	dxVal=$(cut -d " " -f1 max.out | perl -e 'print sort { $a<=>$b } <>'  | head -1)
	dxVal=$((dxVal - xVal))
	dxVal=$(printf "%.*f\n" 1 $dxVal)
	xVal=$((dxVal + xVal))
    ;;
  C)
	yVal=$(cut -d " " -f2 max.out | perl -e 'print sort { $a<=>$b } <>' | head -1)
	echo "TrialList.Current.CouchRemovalYCoordinate = \"$((yVal-0.2))}\";" > CouchRemoval.script
	echo "TrialList.Current.RemoveCouchFromScan = 1;" >> CouchRemoval.script
	echo "TrialList.Current.AlwaysDisplay2dCouchPosition = 1;" >> CouchRemoval.script
	echo "TrialList.Current.LaserLocalizer.LockCouch = 1;" >> CouchRemoval.script
	mv CouchRemoval.script ../CouchRemoval.script
    ;;
esac


echo "PoiList.Current.RelativeXCoord = \"${xVal}\";
PoiList.Current.RelativeYCoord = \"${yVal}\";
PoiList.Current.RelativeZCoord = \"${zVal}\";
Store.At.RepereRef=PoiList.Current.Address;
Store.StringAt.RepereName=PoiList.Current.Name;" >> newRepere.script

#echo "PoiList.Current.Color = \"skyblue\";" >> newRepere.script

mv newRepere.script ../newRepere.script
