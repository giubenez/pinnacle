#!/bin/bash

###############################################################
###                 PIGNAmain.Script                        ###
###                  Giulio Benetti                         ###
###            giulio.benetti@gmail.com                     ###
###                                                         ###
###############################################################

initialPath="/autoDataSets/Archivio"
scriptFolder="/autoDataSets/Archivio/findPatient"
dbFile="${scriptFolder}/all.db"
dbPhysFile="${scriptFolder}/allPhys.db"
scannedFilesFile="${scriptFolder}/scanned.txt"


RED='\033[0;31m'
NC='\033[0m'

clear
echo "database location : $dbFile \n"

findMyPat () {
  IFS=$' '
  read -p "Enter the keywords for the patient (MRN, Name, Last Name, etc): " -a keyw
  tmpDB=$(<${dbFile})
  for kw in ${keyw[@]}; do
    tmpDB=$( echo "$tmpDB" | grep -i $kw )
  done
  head -1 ${dbFile}
  echo "$tmpDB"
}

findMyPhys () {
  IFS=$' '
  read -p "Enter the keywords for the Physics (like \"2018\"): " -a keyw
  tmpDB=$(<${dbPhysFile})
  for kw in ${keyw[@]}; do
    tmpDB=$( echo "$tmpDB" | grep -i $kw )
  done
  echo "$tmpDB"
}

updateDB (){
  echo "Database update started"
  touch $scannedFilesFile
  touch $dbPhysFile
  rm -rf tmpDir
  mkdir tmpDir
  cd tmpDir

  if [[ ! -f $dbFile ]] ; then
    echo "patID;Last;First;Middle;MRN;Physician;Time;instiName;Path" > $dbFile
  fi

  IFS=$'\n'

  shopt -s globstar

  for tarfile in ${initialPath}/**/*.tar; do 
    if /usr/xpg4/bin/grep -qF "${tarfile}" "$scannedFilesFile"; then
      echo "${tarfile} already analyzed!"
      continue
    fi

    shortTarFile=${tarfile#"$initialPath/"}

    timeout 1s /usr/gnu/bin/tar xf $tarfile Institution

    instiName=$(cat Institution | perl -lne '/^Name = "(.*)";/ && print $1')
    instiID=$(cat Institution | perl -lne '/^InstitutionID = ([0-9]*)/ && print $1')

    patIDs=($(cat Institution | perl -lne '/^    PatientID = ([0-9]*)/ && print $1'))
    FormattedDescriptions=($(cat Institution | perl -lne '/^    FormattedDescription = "(.*)";/ && print $1'))

    for i in "${!patIDs[@]}"; do
       echo "${patIDs[$i]};\t${FormattedDescriptions[$i]//&&/;\\t};\t${instiName};\t${tarfile}" >> $dbFile
    done

    if /usr/xpg4/bin/grep -qF "BackupMachine ={" Institution; then
      #echo "Physics detected"
      echo "${instiID};\t${instiName};\t${tarfile}" >> $dbPhysFile
    fi

    rm -rf ${scriptFolder}/tmpDir/*
    echo ${tarfile} >> $scannedFilesFile
    echo "${tarfile} analyzed!"
  done
}


spwnMenu () {
PS3="Choose one of the following options:"
options=("Find a Patient" "Find a Physics" "Update the database" "Rebuild the database" "Quit")

select opt in "${options[@]}"
do
  case $opt in

    "${options[0]}")
      findMyPat
      break
    ;;

    "${options[1]}")
      findMyPhys
      break
    ;;

    "${options[2]}")
      updateDB
      break
    ;;

    "${options[3]}")
      read -p "The database will take hours to rebuild. If you really want to delete it, please write 'banana'" delVar
      if [[ "${delVar}" == "banana" ]] ; then 
        mv $dbFile ${scriptFolder}/bkp/all.db
        mv $scannedFilesFile ${scriptFolder}/bkp/scanned.txt
        mv $dbPhysFile ${scriptFolder}/bkp/allPys.txt

        echo "Database cleared"
        updateDB
      fi
      break
    ;;

    "${options[4]}")
      wannaQuit=1
      break
    ;;

    *)
      echo "Invalid option $REPLY"
      break
    ;;
  esac
done
}

wannaQuit=0

while [ $wannaQuit -eq 0 ]; do
  spwnMenu
done

