#! /bin/bash
# INPUT REQUIRED 
# REGION NAME AS ARGUMENT 1
# PROFILE NAE FROM CREDENTIALS FILE ARGUMENT 2
# INPUT FILE WITH VOLUMEID's TO BACK ARGUMENT 3 

region=$1
profile=$2
input=$3


 while IFS= read -r line
   do
      volume_id=${line}
      echo "Orphan Volume:   "$volume_id 
      echo "Creating Snapshot of $volume_id"  
#aws --profile ${profile} ec2 create-snapshot --volume-id {$volume_id} --description 'Orphan Volume Snapshot' --tag-specifications 'ResourceType=snapshot,Tags=[{Key=env,Value=prod},{Key=orphan,Value=yes}]'
    done < "$input"
