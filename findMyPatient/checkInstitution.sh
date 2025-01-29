#!/bin/bash


###############################################################
###                 PIGNAmain.Script                        ###
###                  Giulio Benetti                         ###
###            giulio.benetti@gmail.com                     ###
###                                                         ###
###############################################################


initialPath="$(pwd)"
scriptFolder="$(pwd)"

allArchExt="${scriptFolder}/allArchExt.db"
allInstExt="${scriptFolder}/allInstExt.db"
allArch="${scriptFolder}/allArch.db"
allInst="${scriptFolder}/allInst.db"

RED='\033[0;31m'
NC='\033[0m'

clear

comparePat () {

  echo "\nIn Archive but not in Institution"
  cat ${allArch} | while read l
  do 
    if ! /usr/xpg4/bin/grep -qF "${l}" "${allInst}"; then
      echo -n "Ext ${l}:\t"
      grep "${l}" "${allArchExt}"
      touch failedComp
    fi
  done

  echo "\nIn Institution but not in Archive"
  cat ${allInst} | while read l
  do 
    if ! /usr/xpg4/bin/grep -qF "${l}" "$allArch"; then
      echo -n "Inst ${l}:\t"
      grep "${l}" "${allInstExt}"
      touch failedComp
    fi
  done

  if [[ -f failedComp ]]; then
    echo -e "${RED}Backup FAILED${NC}\n\n"
    rm failedComp
  else
    echo "${RED}Backup completed SUCCESSFULLY${NC}\n\n"
  fi

}


createArchiveDB (){
  echo "Archive database creation started"
  rm -rf tmpDir $allArchExt $allArch
  mkdir tmpDir
  cd tmpDir

  echo "patID;Last;First;Middle;MRN;Physician;Time;instiName;Path" > $allArchExt

  IFS=$'\n'

  for tarfile in ${initialPath}/*.tar; do 

    shortTarFile=${tarfile#"$initialPath/"}

    timeout 1s /usr/gnu/bin/tar xf $tarfile Institution

    instiName=$(cat Institution | perl -lne '/^Name = "(.*)";/ && print $1')
    instiID=$(cat Institution | perl -lne '/^InstitutionID = ([0-9]*)/ && print $1')

    patIDs=($(cat Institution | perl -lne '/^    PatientID = ([0-9]*)/ && print $1'))
    FormattedDescriptions=($(cat Institution | perl -lne '/^    FormattedDescription = "(.*)";/ && print $1'))

    for i in "${!patIDs[@]}"; do
      echo "${patIDs[$i]}">> $allArch
      echo "${patIDs[$i]};\t${FormattedDescriptions[$i]//&&/;\\t};\t${instiName};\t${shortTarFile}">> $allArchExt
    done

    rm -rf ${scriptFolder}/tmpDir/*
    echo "${tarfile} analizzato!"
  done
  cd $initialPath
  rm -rf ${scriptFolder}/tmpDir/
}


createPinnDB (){
  echo "Pinnacle institution database creation started"
  # read -p "Put Institution file in this folder before proceeding (check institution number XXX in pinnacle and copy/paste the institution file from /PrimaryPatientData/NewPatients/Institution_XXX). Press any key to continue..." 

  rm -rf $allInstExt $allInst


  echo "patID;Last;First;Middle;MRN;Physician;Time;instiName;Path" > $allInstExt
  IFS=$'\n'

  for tarfile in ${initialPath}/*.tar; do 

    shortTarFile=${tarfile#"$initialPath/"}

    timeout 1s /usr/gnu/bin/tar xf $tarfile Institution

    instiIDStatic=$(cat Institution | perl -lne '/^InstitutionID = ([0-9]*)/ && print $1')

    rm Institution
    break
  done
  cp /PrimaryPatientData/NewPatients/Institution_${instiIDStatic}/Institution ./Institution

  instiName=$(cat Institution | perl -lne '/^Name = "(.*)";/ && print $1')
  instiID=$(cat Institution | perl -lne '/^InstitutionID = ([0-9]*)/ && print $1')
  patIDs=($(cat Institution | perl -lne '/^    PatientID = ([0-9]*)/ && print $1'))
  FormattedDescriptions=($(cat Institution | perl -lne '/^    FormattedDescription = "(.*)";/ && print $1'))


  for i in "${!patIDs[@]}"; do
    echo "${patIDs[$i]}" >> $allInst
    echo "${patIDs[$i]};\t${FormattedDescriptions[$i]//&&/;\\t};\t${instiName};\t${shortTarFile}">> $allInstExt
  done

  rm Institution

}


spwnMenu () {
PS3="Choose one of the following options:"
options=("Create Archive DB" "Create Institution DB" "Check" "Quit")

select opt in "${options[@]}"
do
  case $opt in

    "${options[0]}")
      createArchiveDB
      break
    ;;

    "${options[1]}")
      createPinnDB
      break
    ;;

    "${options[2]}")
      comparePat
      break
    ;;

    "${options[3]}")
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

echo "This script aims to verify whether all the patients inside a specific institution are present inside the archived folder."
echo "Put the script in the folder of the archive you want to verify."

while [ $wannaQuit -eq 0 ]; do
  spwnMenu
done

