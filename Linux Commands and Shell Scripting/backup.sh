#!/bin/bash

# this script is the final project from the Linux Commands and Shell Scripting IBM course
# it tasked me with creating a script that would create a backup of important files in a target directory
# the important files are copied into an archived and compressed folder and saved with a timestamp


# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1 # setting variable equal to first command line argument passed to script
destinationDirectory=$2 # second command line argument

# [TASK 2]
echo "Here is the target directory: $targetDirectory"
echo "Here is the destination directory: $destinationDirectory"

# [TASK 3]
# the variable is set to the time in seconds since the Unix epoch (1970-01-01 00:00:00 UTC)
currentTS=`date +%s`

# [TASK 4]
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
origAbsPath=`pwd`

# [TASK 6]
cd $destinationDirectory || exit
destDirAbsPath=`pwd`

# [TASK 7]
cd $origAbsPath || exit
cd $targetDirectory || exit

# [TASK 8]
yesterdayTS=$(($currentTS-(24*60*60)))

declare -a toBackup

for file in * # [TASK 9]
do
  # [TASK 10]
  if [[ $(date -r $file +%s) -gt $yesterdayTS ]]
  then
    toBackup+=($file) # [TASK 11]
  fi
done

# [TASK 12]
tar -czvf $backupFileName ${toBackup[@]}
# [TASK 13]
mv $backupFileName $destDirAbsPath
# Congratulations! You completed the final project for this course!
