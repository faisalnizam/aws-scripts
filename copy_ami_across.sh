#! /bin/bash 


echo "Enter Region To Copy From: " 
read region_from 

echo "Enter Region To Copy To: " 
read region_to 


echo "Enter AMI to Copy seperated by commas , "
read ami_to_copy 




for ami_id in $(echo ${ami_to_copy} | sed "s/,/ /g")
do
    echo "Copying AMI ${ami_id} from ${region_fron} to ${region_to} "
    #aws --profile ${region_from} copy-image --source-region ${region_to} --region {} --source-ami-id ${ami_id}
done

