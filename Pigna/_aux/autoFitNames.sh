#!/bin/bash

protoFolder="/usr/local/PinnacleSiteData/clinical/Protocols"
protoName=$1

myName=$2
#myName=gbenetti
#protoName="new_Prostata_3600_4020_6fx_SIB"

mkdir -p "/usr/local/PinnacleSiteData/clinical/Scripts/Pigna/temp/${myName}"
scriptLocation="/usr/local/PinnacleSiteData/clinical/Scripts/Pigna/temp/${myName}/autoFitNames.script"
scriptFirstLocation="/usr/local/PinnacleSiteData/clinical/Scripts/Pigna/temp/${myName}/autoFitNamesFirst.script"


echo "/**************************************************************
***                autoFitNamesFirst.Script                 ***
***               created by autoFitNames.sh                ***
***                  Giulio Benetti                         ***
***            giulio.benetti@gmail.com                     ***
***                                                         ***
**************************************************************/


Store.FloatAt.PadIP = 0.2;

Store.FloatAt.PadOP = 0.1;
Store.FloatAt.Pad = 0;

//InfoMessage = \"Welcome To Names Fitter\";
Store.FloatAt.AvviatoFN = 1;


Store.StringAt.SurrName = \"surround\";
" > $scriptFirstLocation




vPad=35
printStart () {


appendToScript=""





echo "/**************************************************************
***                autoFitNames.Script                      ***
***               created by autoFitNames.sh                ***
***                  Giulio Benetti                         ***
***            giulio.benetti@gmail.com                     ***
***                                                         ***
**************************************************************/


//////////////////////////////////////////////////////////////
//                      LOAD DEF                            //
//////////////////////////////////////////////////////////////

IF.Store.FloatAt.AvviatoFN.THEN. Store.StringAt.Trash. ELSE. Script.ExecuteNow = \"${scriptFirstLocation}\"; 


//////////////////////////////////////////////////////////////
//                        WINDOW                            //
//////////////////////////////////////////////////////////////

// Close window if it is already open
Store.At.FinestraFitNames.Unrealize = \"Dismiss\";
Store.At.FinestraFitNames = \"Dismiss\";

// Create the window
Store.At.FinestraFitNames = GeoFORM {
                   Name = \"FitNames\";
                 };


//////////////////////////////////////////////////////////////
//                      LEVELS                              //
//////////////////////////////////////////////////////////////

// Top level
Store.At.FinestraFitNames.WidgetList.GeoWidget = {
      WidgetClass = \"Form\";
      Name = \"TopLevel\";
      Label = \"Fit Names Window\";
      X = 1900;
      Y = 000;
      Width = 400;
      Height = 1900; 
    };


//////////////////////////////////////////////////////////////
//                     Headers                                //
//////////////////////////////////////////////////////////////
	
Store .At .FinestraFitNames .AddChild = \"\";
Store .At .FinestraFitNames .WidgetList .Last = {
     Name = \"HeadersArea\";
     ParentName = \"TopLevel\";
     WidgetClass = \"DrawingArea\";
     Width = 400;
     Height = 200;
     AttachRight = \"FORM\";
     AttachLeft = \"FORM\";
     AttachTop = \"FORM\";
     AttachBottom = \"--\";
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"HeadersArea\";
      Name = \"pHead\";
      X = 10;
      Y = 10;
      Width = 30;
      Height = 20;
      Font = \"Italic\";
      QueryColorKey = \"blue\";
      Label = \"_p?\";
    };  

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"HeadersArea\";
      Name = \"actHead\";
      X = 79;
      Y = 10;
      Width = 100;
      Height = 20;
      Font = \"Italic\";
      Label = \"Actual ROIs\";
    };  

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"HeadersArea\";
      Name = \"protHead\";
      X = 255;
      Y = 10;
      Width = 100;
      Height = 20;
      Font = \"Italic\";

      Label = \"Protocol ROIs\";
    };  


" > $scriptLocation

}

ActNumPTV=1

makePTVN () {
PTVN="$1"
PTVN_p="$2"
ringPTVN="$3"
ringPTVN_p="$4"
UPROIN="$5"
DOWNROIN="$6"

#
if [[ $PTVN == "Vuoto" && $PTVN_p == "Vuoto" && $ringPTVN == "Vuoto" && $ringPTVN_p == "Vuoto" && $UPROIN == "Vuoto" && $DOWNROIN == "Vuoto" ]] ; then
	echo "returning"
	return 2
fi


yOfTheLine="$((10+vPad))"

if [[ $ActNumPTV == 1 ]] ; then 
	attachAbove="HeadersArea"
else
	attachAbove=$((ActNumPTV-1))
	attachAbove="PTV${attachAbove}Area"
fi


echo "

//////////////////////////////////////////////////////////////
//                      PTV ${ActNumPTV}                                //
//////////////////////////////////////////////////////////////
	
Store .At .FinestraFitNames .AddChild = \"\";
Store .At .FinestraFitNames .WidgetList .Last = {
     Name = \"PTV${ActNumPTV}Area\";
     ParentName = \"TopLevel\";
     WidgetClass = \"DrawingArea\";
     Width = 400;
     Height = 200;
     AttachRight = \"FORM\";
     AttachLeft = \"FORM\";
     AttachTop = \"${attachAbove}\";
     AttachBottom = \"--\";
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Separator\";   
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"Sep${ActNumPTV}\";
      X = 50;
      Y = -10;
      Width = 299;
      Height = 5;
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}Lab\";
      X = 200;
      Y = 10;
      Width = 100;
      Height = 20;
      Font = \"Bold\";
      Label = \"PTV${ActNumPTV}\";
    };  



" >>  $scriptLocation

if [[ ${PTVN} != "Vuoto" ]] ; then 



echo "//////////////////////////////////////////////////////////////

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}Selector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.PTV${ActNumPTV}Name\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.PTV${ActNumPTV}Name\";
      ResetDependenciesWhenRealized = 1;
    }; 

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}Arrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.PTV${ActNumPTV}Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${PTVN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.PTV${ActNumPTV}Name = ${PTVN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}Name\";
      X = 219;
      Y = 50;
      Font = \"Italic\";
      Width = 300;
      Label = \"${PTVN}\";
    };  

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}Check\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey= \"Store.FloatAt.PTV${ActNumPTV}Check\" ;
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.PTV${ActNumPTV}Check\";
    };
	

" >>  $scriptLocation

appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.PTV${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.PTV${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.PTV${ActNumPTV}Name\";"

echo "Store.StringAt.PTV${ActNumPTV}Name = \"${PTVN}\";" >> $scriptFirstLocation

yOfTheLine="$((yOfTheLine+vPad))"
fi 

if [[ ${PTVN_p} != "Vuoto" ]] ; then 


echo "//////////////////////////////////////////////////////////////
Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}pSelector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.PTV${ActNumPTV}pName\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.PTV${ActNumPTV}pName\";
      ResetDependenciesWhenRealized = 1;
    }; 


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}pArrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.PTV${ActNumPTV}pName\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${PTVN_p}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.PTV${ActNumPTV}pName = ${PTVN_p}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    



Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}pName\";
      X = 219;
      Y = ${yOfTheLine};
      Font = \"Italic\";
      Width = 300;
      Label = \"${PTVN_p}\";
    };  



Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}pCheck\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey= \"Store.FloatAt.PTV${ActNumPTV}pCheck\" ;
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.PTV${ActNumPTV}pCheck\";
    };
	
">>  $scriptLocation


appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.PTV${ActNumPTV}pCheck.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.PTV${ActNumPTV}pCheck.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.PTV${ActNumPTV}pName\";"

echo "Store.StringAt.PTV${ActNumPTV}pName = \"${PTVN_p}\";" >> $scriptFirstLocation
yOfTheLine="$((yOfTheLine+vPad))"

fi
	

if [[ ${ringPTVN} != "Vuoto" ]] ; then 



echo "//////////////////////////////////////////////////////////////

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"ringPTV${ActNumPTV}Selector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.ringPTV${ActNumPTV}Name\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.ringPTV${ActNumPTV}Name\";
      ResetDependenciesWhenRealized = 1;
    }; 


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"ringPTV${ActNumPTV}Arrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.ringPTV${ActNumPTV}Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${ringPTVN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.ringPTV${ActNumPTV}Name = ${ringPTVN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"ringPTV${ActNumPTV}Name\";
      X = 219;
      Y = ${yOfTheLine};
      Font = \"Italic\";
      Width = 300;
      Label = \"${ringPTVN}\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}Check\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey=   \"Store.FloatAt.ringPTV${ActNumPTV}Check\"  ;
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.ringPTV${ActNumPTV}Check\";
    };
" >>  $scriptLocation


appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.ringPTV${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.ringPTV${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.ringPTV${ActNumPTV}Name\";"


echo "Store.StringAt.ringPTV${ActNumPTV}Name = \"${ringPTVN}\";" >> $scriptFirstLocation
yOfTheLine="$((yOfTheLine+vPad))"
fi



if [[ ${ringPTVN_p} != "Vuoto" ]] ; then 


echo "//////////////////////////////////////////////////////////////

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"ringPTV${ActNumPTV}pSelector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.ringPTV${ActNumPTV}pName\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.ringPTV${ActNumPTV}pName\";
      ResetDependenciesWhenRealized = 1;
    }; 


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"ringPTV${ActNumPTV}Arrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.ringPTV${ActNumPTV}pName\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${ringPTVN_p}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.ringPTV${ActNumPTV}pName = ${ringPTVN_p}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"ringPTV${ActNumPTV}pName\";
      X = 219;
      Y = ${yOfTheLine};
      Font = \"Italic\";
      Width = 300;
      Label = \"${ringPTVN_p}\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"PTV${ActNumPTV}pCheck\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey=   \"Store.FloatAt.ringPTV${ActNumPTV}pCheck\"  ;
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.ringPTV${ActNumPTV}pCheck\";
    };
" >>  $scriptLocation



appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.ringPTV${ActNumPTV}pCheck.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.ringPTV${ActNumPTV}pCheck.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.ringPTV${ActNumPTV}pName\";"

echo "Store.StringAt.ringPTV${ActNumPTV}pName = \"${ringPTVN_p}\";" >> $scriptFirstLocation

yOfTheLine="$((yOfTheLine+vPad))"

fi



## UP ROI

if [[ ${UPROIN} != "Vuoto" ]] ; then 


echo "//////////////////////////////////////////////////////////////

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"UPROI${ActNumPTV}Selector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.UPROI${ActNumPTV}Name\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.UPROI${ActNumPTV}Name\";
      ResetDependenciesWhenRealized = 1;
    }; 


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"UPROI${ActNumPTV}Arrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.UPROI${ActNumPTV}Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${UPROIN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.UPROI${ActNumPTV}Name = ${UPROIN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"UPROI${ActNumPTV}Name\";
      X = 219;
      Y = ${yOfTheLine};
      Font = \"Italic\";
      Width = 300;
      Label = \"${UPROIN}\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"UPROI${ActNumPTV}Check\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey=   \"Store.FloatAt.UPROI${ActNumPTV}Check\"  ;
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.UPROI${ActNumPTV}Check\";
    };
" >>  $scriptLocation



appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.UPROI${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.UPROI${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.UPROI${ActNumPTV}Name\";"

echo "Store.StringAt.UPROI${ActNumPTV}Name = \"${UPROIN}\";" >> $scriptFirstLocation

yOfTheLine="$((yOfTheLine+vPad))"

fi

## DOWN ROI




if [[ ${DOWNROIN} != "Vuoto" ]] ; then 


echo "//////////////////////////////////////////////////////////////

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"DOWNROI${ActNumPTV}Selector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.DOWNROI${ActNumPTV}Name\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.DOWNROI${ActNumPTV}Name\";
      ResetDependenciesWhenRealized = 1;
    }; 


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"DOWNROI${ActNumPTV}Arrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.DOWNROI${ActNumPTV}Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${DOWNROIN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.DOWNROI${ActNumPTV}Name = ${DOWNROIN}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"DOWNROI${ActNumPTV}Name\";
      X = 219;
      Y = ${yOfTheLine};
      Font = \"Italic\";
      Width = 300;
      Label = \"${DOWNROIN}\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"PTV${ActNumPTV}Area\";
      Name = \"DOWNROI${ActNumPTV}Check\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey=   \"Store.FloatAt.DOWNROI${ActNumPTV}Check\"  ;
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.DOWNROI${ActNumPTV}Check\";
    };
" >>  $scriptLocation



appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.DOWNROI${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.DOWNROI${ActNumPTV}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.DOWNROI${ActNumPTV}Name\";"

echo "Store.StringAt.DOWNROI${ActNumPTV}Name = \"${DOWNROIN}\";" >> $scriptFirstLocation

yOfTheLine="$((yOfTheLine+vPad))"

fi






ActNumPTV=$((ActNumPTV+1))
}



ActNumOAR=1




addOAR () {
OAR="$1"

yOfTheLine="$((10+vPad*ActNumOAR))"

if [[ $ActNumPTV == 1 ]] ; then 
	attachAbove="FORM"
else
	attachAbove=$((ActNumPTV-1))
	attachAbove="PTV${attachAbove}Area"
fi

if [[ $ActNumOAR == 1 ]] ; then 
echo "

//////////////////////////////////////////////////////////////
//                      OAR                                //
//////////////////////////////////////////////////////////////
	
Store .At .FinestraFitNames .AddChild = \"\";
Store .At .FinestraFitNames .WidgetList .Last = {
     Name = \"OARArea\";
     ParentName = \"TopLevel\";
     WidgetClass = \"DrawingArea\";
     Width = 400;
     Height = 200;
     AttachRight = \"FORM\";
     AttachLeft = \"FORM\";
     AttachTop = \"${attachAbove}\";
     AttachBottom = \"--\";
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Separator\";   
      ParentName = \"OARArea\";
      Name = \"OARSep${ActNumOAR}\";
      X = 50;
      Y = -10;
      Width = 299;
      Height = 5;
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"OARArea\";
      Name = \"OARLab\";
      X = 200;
      Y = 10;
      Width = 100;
      Height = 20;
      Font = \"Bold\";
      Label = \"OAR\";
    };  

" >>  $scriptLocation
fi



echo "//////////////////////////////////////////////////////////////

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"OARArea\";
      Name = \"OAR${ActNumOAR}Selector\";
      X = 35;
      Y = $((yOfTheLine-9));
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.OAR${ActNumOAR}Name\";
      QueryListKey = \"RoiList.*.Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.OAR${ActNumOAR}Name\";
      ResetDependenciesWhenRealized = 1;
    }; 



Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"OARArea\";
      Name = \"OAR${ActNumOAR}Arrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = ${yOfTheLine};
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.OAR${ActNumOAR}Name\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${OAR}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.OAR${ActNumOAR}Name = ${OAR}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"OARArea\";
      Name = \"OAR${ActNumOAR}Name\";
      X = 219;
      Y = ${yOfTheLine};
      Font = \"Italic\";
      Width = 300;
      Label = \"${OAR}\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ToggleButton\";
      QueryColorKey = \"Blue\";
      ParentName = \"OARArea\";
      Name = \"PTV1Check\";
      X = 2;
      Y = $((yOfTheLine-7));
      Width = 20;
      Height = 20;
      QueryValueKey=\"Store.FloatAt.OAR${ActNumOAR}Check\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.OAR${ActNumOAR}Check\";
    };
" >>  $scriptLocation



appendToScript="$appendToScript\n
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.OAR${ActNumOAR}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.CreateChild\";
      AddAction = \"\";
      ReplaceCurrentAction = \"IF.Store.FloatAt.OAR${ActNumOAR}Check.EQUALTO.#1.THEN.Store.At.RemoveFromSurr.Last.Value=Store.StringAt.OAR${ActNumOAR}Name\";"

echo "Store.StringAt.OAR${ActNumOAR}Name = \"${OAR}\";" >> $scriptFirstLocation

ActNumOAR=$((ActNumOAR+1))
}


addSurr () {
Surr="$1"
echo "//////////////////////////////////////////////////////////////
//                      Surround                            //
//////////////////////////////////////////////////////////////	

Store .At .FinestraFitNames .AddChild = \"\";
Store .At .FinestraFitNames .WidgetList .Last = {
     Name = \"SurrArea\";
     ParentName = \"TopLevel\";
     WidgetClass = \"DrawingArea\";
     Width = 400;
     Height = 200;
     AttachRight = \"FORM\";
     AttachLeft = \"FORM\";
     AttachTop = \"OARArea\";
     AttachBottom = \"--\";
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Separator\";   
      ParentName = \"SurrArea\";
      Name = \"SepSur\";
      X = 50;
      Y = -10;
      Width = 299;
      Height = 5;
    };

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"SurrArea\";
      Name = \"OARLab\";
      X = 200;
      Y = 10;
      Width = 100;
      Height = 20;
      Font = \"Bold\";
      Label = \"Surround\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"SurrArea\";
      Name = \"SurrSelector\";
      X = 35;
      Y = 35;
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.SurrName\";
      QueryListKey = \"RoiList.*.Name\";
      QueryColorKey = \"RoiList.*.Color\";
      QueryColorListKey = \"RoiList.*.Color\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.SurrName\";
      ResetDependenciesWhenRealized = 1;
    }; 




Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"ArrowLeft\";
      ParentName = \"SurrArea\";
      Name = \"SurrArrow\";
      Width = 30;
      Height = 30;
      X = 194;
      Y = 45;
      QueryColorKey = \"red\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current = Store.StringAt.SurrName\";
      AddAction = \"\";
      ReplaceCurrentAction = \"RoiList.Current.Name = ${Surr}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.SurrName = ${Surr}\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = ${scriptLocation}\";
    };    



Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"SurrArea\";
      Name = \"SurrName\";
      X = 219;
      Y = 45;
      Font = \"Italic\";
      Width = 300;
      Label = \"${Surr}\";
    };  

" >>  $scriptLocation

}


printEnd () {

echo "


//////////////////////////////////////////////////////////////
//                        Dismiss                            //
//////////////////////////////////////////////////////////////
    
Store .At .FinestraFitNames .AddChild = \"\";
Store .At .FinestraFitNames .WidgetList .Last = {
     Name = \"ButtonArea\";
     ParentName = \"TopLevel\";
     WidgetClass = \"DrawingArea\";
     Width = 450;
     Height = 50;
     AttachRight = \"FORM\";
     AttachLeft = \"FORM\";
     AttachBottom = \"FORM\";   
    };
    
// Dismiss Button
Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"PushButton\";
      ParentName = \"ButtonArea\";
      Name = \"DismissButton\";
      X = 10;
      Y = 5;
      Font = \"Bold\";
      Label = \"Dismiss\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.At.FinestraFitNames.Unrealize\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FreeAt.FinestraFitNames\";
    };    
    
// Info Button
Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"PushButton\";
      ParentName = \"ButtonArea\";
      Name = \"InfoButton\";
      X = 110;
      Y = 5;
      Label = \"Info\";

      Width = 200;
      QueryColorKey = \"Yellow\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/fitNamesInfo.script\";
    };    
    

//////////////////////////////////////////////////////////////
//                        Ring Area                         //
//////////////////////////////////////////////////////////////
    
Store .At .FinestraFitNames .AddChild = \"\";
Store .At .FinestraFitNames .WidgetList .Last = {
     Name = \"RingsArea\";
     ParentName = \"TopLevel\";
     WidgetClass = \"DrawingArea\";
     Width = 450;
     Height = 200;
     AttachRight = \"FORM\";
     AttachLeft = \"FORM\";
     AttachTop = \"--\";
     AttachBottom = \"ButtonArea\";   
    };
    
	
Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"RingsArea\";
      Name = \"CreateRingLab\";
      X = 88;
      Y = 10;
      Width = 230;
      Height = 20;
      Font = \"Bold\";
      Label = \"Create Rings, _p, UP, DOWN\";
    };  

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"RingsArea\";
      Name = \"Padding in/out-plane\";
      Width = 150;
      X = 00;
      Y = 37;
    };  

	

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Text\";
      ParentName = \"RingsArea\";
      Name = \"PadIP\";
      X = 155;
      Y = 30;
      Width = 50;
      QueryValueKey = \"Store.FloatAt.PadIP.Value\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.PadIP\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Text\";
      ParentName = \"RingsArea\";
      Name = \"PadOP\";
      X = 195 ;
      Y = 30;
      Width = 50;
      QueryValueKey = \"Store.FloatAt.PadOP.Value\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.PadOP\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Label\";
      ParentName = \"RingsArea\";
      Name = \"const\";
      Width = 150;
      X = 280;
      Y = 37;
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"Text\";
      ParentName = \"RingsArea\";
      Name = \"Pad\";
      X = 330 ;
      Y = 30;
      Width = 40;
      QueryValueKey = \"Store.FloatAt.Pad.Value\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.FloatAt.Pad\";
    };  


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {         
      WidgetClass = \"OptionMenu\";
      ParentName = \"RingsArea\";
      Name = \"ToRingSelector\";
      X = 0;
      Y = 70;
      Width = 120;
      Height = 20;
      AddLabelToStartOfList = 1;
      Label = \"---\";
      QueryValueKey = \"Store.StringAt.ToRingName\";
      QueryListKey = \"RoiList.*.Name\";
      QueryColorKey = \"RoiList.*.Color\";
      QueryColorListKey = \"RoiList.*.Color\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.ToRingName\";
      ResetDependenciesWhenRealized = 1;
    }; 


Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"PushButton\";
      ParentName = \"RingsArea\";
      Name = \"CreateRing\";
      X = 168;
      Y = 70;
      Width = 60;
      Label = \"   ring\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.TempPTV = Store.StringAt.ToRingName\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/createRing.script\";
    };    




Store.FreeAt.RemoveFromSurr;
Store.At.RemoveFromSurr=ObjectList{ChildClassName=\"SimpleString\";};

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"PushButton\";
      ParentName = \"RingsArea\";
      Name = \"Create _p\";
      X = 230;
      Y = 70;
      Width = 40;
      QueryColorKey = \"Blue\";
      Label = \" _p\"; // excluding marked\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.TempPTV = Store.StringAt.ToRingName\";


$appendToScript

      
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/create_p.script\";
      

    };    

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"PushButton\";
      ParentName = \"RingsArea\";
      Name = \"CreateUp\";
      X = 270;
      Y = 70;
      Width = 60;
      Label = \"   UP\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.TempPTV = Store.StringAt.ToRingName\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/createUp.script\";
    };    

Store.At.FinestraFitNames.AddChild = \"\";
Store.At.FinestraFitNames.WidgetList.Last = {
      WidgetClass = \"PushButton\";
      ParentName = \"RingsArea\";
      Name = \"CreateDown\";
      X = 328;
      Y = 70;
      Width = 60;
      Label = \"DOWN\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Store.StringAt.TempPTV = Store.StringAt.ToRingName\";
      AddAction = \"\";
      ReplaceCurrentAction = \"Script.ExecuteNow = /usr/local/PinnacleSiteData/clinical/Scripts/Pigna/_aux/createDown.script\";
    };    




Store.At.FinestraFitNames.Create = \"\";

" >>  $scriptLocation



}

shopt -s nocasematch
IFS=$'\n'
AllObj=($( cat ${protoFolder}/${protoName}/protocol.OrbitObjectives | grep ROIName | cut -d '"' -f2 | grep . | uniq ))

dos=( $(echo "${AllObj[*]}" | cut -c 4-7 ))
sortedDos=( $(echo "${dos[*]}" | sort -nr))




#echo "${AllObj[*]}"
#echo "${frist3d[*]}"
#echo "${sortedDos[*]}"

#echo "${sortedDos[*]}" | sort -n

printStart

#echo "${!sortedDos[@]}" #numeri dell'array
#echo "\n\n${AllObj[*]}\n\n"	


i=0
while [ "${sortedDos[$i]}" -eq "${sortedDos[$i]}" ]  #è un numero
do
	PTV="Vuoto"
	PTV_p="Vuoto"
	ring="Vuoto"
	ring_p="Vuoto"
	UPROI="Vuoto"
	DOWNROI="Vuoto"

	echo "\n${sortedDos[$i]}"

	for j in "${!AllObj[@]}" #numeri dell'array
	do
	
	if [[ ${AllObj[$j]} == *"${sortedDos[$i]}"* ]] ; then #string contiene dose in lavorazione

		
		if [[ ${AllObj[$j]:0:4} == "ring" ]] ; then
			if [[ ${AllObj[$j]} == *"_p"* ]] ; then
				ring_p=${AllObj[$j]}
				unset 'AllObj[$j]'
				j=$((j-1))
			else
				ring=${AllObj[$j]}
				unset 'AllObj[$j]'
				j=$((j-1))
			fi
		elif [[ ${AllObj[$j]:0:3} == "ptv" ]]; then
			if [[ ${AllObj[$j]} == *"_p"* ]] ; then
				PTV_p=${AllObj[$j]}
				unset 'AllObj[$j]'
				j=$((j-1))
			else
				PTV=${AllObj[$j]}
				unset 'AllObj[$j]'
				j=$((j-1))
			fi
		elif [[ ${AllObj[$j]:0:3} == "UP_" ]] ; then
			UPROI=${AllObj[$j]}
			unset 'AllObj[$j]'
			j=$((j-1))
		elif [[ ${AllObj[$j]:0:5} == "DOWN_" ]] ; then
			DOWNROI=${AllObj[$j]}
			unset 'AllObj[$j]'
			j=$((j-1))
		fi
	fi
	
	


	done
	makePTVN "${PTV}" "${PTV_p}" "${ring}" "${ring_p}" "${UPROI}" "${DOWNROI}"
	echo "makePTVN ${PTV} ${PTV_p} ${ring} ${ring_p} ${UPROI} ${DOWNROI}"


	#echo "\n\n\tremaining = ${AllObj[*]}"	
	i=$((i+1))
done

surrName="Vuoto"

for oarz in "${AllObj[@]}"
do
	
	if [[ "${oarz,,}" == "surround" ]] ; then
		surrName="${oarz}"
	else
		addOAR "${oarz}"
	fi
done

if [[ "$surrName" != "Vuoto" ]] ; then
	addSurr "$surrName"
fi

printEnd


