#!/bin/bash

# Arguments 
# $1 = source path
# $2 = folder suffix

TEST_MODE=0

#base_out_folder="/Users/blibby/Development/Utils/shell_scripts/cphoto.sh/test/output"
#base_out_folder="/Users/blibby/Pictures/Photos/2016"
volume="/Volumes/WD_PASSPORT_3TB/"
base_out_folder="$volume""Photos/2017/"
base_out_hunting_folder="$volume""Photos-Hunting/2017/"
base_folder_name=$(date +%Y%m%d)
interator=0


function endsWith()
{
  if [[ "$1" == *$2 ]]; then
      return 1
  else
      return 0
  fi
}

function buildFolderName()
{
  #local iterator_str="%02d\n" $iterator
  printf -v iterator_str "%02d" $interator

  folder_name="$base_folder_name""_""$iterator_str"

  if [ $# -eq 1 ]; then

    if [ "$1" == "hunting" ]; then
      echo "Hunting folder - ignore suffix"
    elif [ "$1" == "drone" ]; then
      echo "Drone folder - ignore suffix"
    else
      folder_name="$folder_name""-"$1
      echo "Suffix applied:" $1
    fi
  else
    echo "No suffix arguments supplied"
  fi

  echo "building folder_name=" $folder_name
}

buildFolderName $2

#folder_name="$folder_name""_00-"$2


echo "folder_name=" $folder_name

source_dir=$1

if [ -d $source_dir ]; then
  #new_path="/Users/blibby/Pictures/Photos/2016/$folder_name"
  if [ "$2" == "hunting" ]; then
    echo "Put this in the hunting folder."
    new_path="$base_out_hunting_folder""$folder_name"
  elif [ "$2" == "drone" ]; then
    echo "Put this in the drone folder."
    new_path="$base_out_folder""drone""/$folder_name"
  else
    new_path="$base_out_folder""Catalog""/$folder_name"
  fi
  echo "Creating directory: $new_path"
  

  COUNTER=0
  MAX_COUNT=25
  while [  $COUNTER -lt $MAX_COUNT ]; do
    echo The counter is $COUNTER
    if [ -d "$new_path" ]; then
    # Control will enter here if $DIRECTORY exists.
      let COUNTER=COUNTER+1
      let interator=interator+1
      echo "iterator=" $interator
      buildFolderName $2
      new_path="$base_out_folder""/$folder_name"
    else
      let COUNTER=MAX_COUNT+1
      echo Output folder does not exist $folder_name
    fi
  done

  if [ $TEST_MODE -eq 1 ]; then
      echo "TEST_MODE: mkdir skipped for $new_path"
  else
    #mkdir "$new_path"
    echo "making new path"
  fi

  echo "cp $source_dir $new_path"

  # echo "Copying files from $1 to $new_path..."
  if [ $TEST_MODE -eq 1 ]; then
      echo "TEST_MODE: cp -rvp $1 $new_path skipped"
  else
    #cp -rvp "$1" "$new_path"
    echo "copying to new path"
  fi

  # rsync to preserve file dates
  # http://apple.stackexchange.com/questions/80485/can-timestamps-be-preserved-when-copying-files-on-os-x
  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/rsync.1.html
  # rsync -aE $source_dir $new_path"

  # echo "Copy completed, showing new path contents."
  if [ $TEST_MODE -eq 1 ]; then
      echo "TEST_MODE: ls and open skipped"
  else
    ls -al "$new_path"
    open "$new_path"
    echo "opening new path"
  fi

  echo "Remove statement to run:"
  echo "rm $source_dir*"
  echo "rm $source_dir*" | pbcopy
else 
  echo "Source directory does not exists: $1"
fi 


