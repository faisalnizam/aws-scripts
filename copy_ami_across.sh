#! /bin/bash 

echo "Enter Profile to Use: " 
read profile

echo "Enter Region To Copy From: " 
read region_from 

echo "Enter Region To Copy To: " 
read region_to 


echo "Enter AMI to Copy seperated by commas , "
read ami_to_copy 

echo "Enter Account Number to Share the AMI with: "
read account_to

for ami_id in $(echo ${ami_to_copy} | sed "s/,/ /g")
do
    echo "Extracting AMI Name "
    ami_name_command="aws --profile ${profile} --region ${region_from} ec2 describe-images --image-ids ${ami_id} --output text --query 'Images[].[ Tags[?Key==\`Name\`].Value | [0]]'"
    ami_name=`eval $ami_name_command` 

    # Replace Space By - to make it compatible with Naming Convention 
    ami_name=`echo ${ami_name// /-}`

    echo "Copying AMI ${ami_id} from ${region_fron} to ${region_to} with Name ${ami_name} "
    new_ami_id=`aws --profile ${profile} ec2 copy-image --source-region ${region_from} --region ${region_to} --source-image-id ${ami_id} --name ${ami_name} | jq .ImageId `

    echo "" 
    new_ami_id=`echo ${new_ami_id//\"/}`
    echo "New Image ID Created in ${region_to} is ${new_ami_id}"

    echo ${new_ami_id} >> ${profile}_ami_ids.txt

    echo "" 
    echo "Enabling Image Attributes to be available across other account" 

    #aws --profile ${profile} --region ${region_to} ec2 modify-image-attribute --image-id ${new_ami_id} --launch-permission  "Add=[{UserId='${account_to}'}]"

    echo ""
    echo "Setting Tags for the AMI"

    aws --profile ${profile} --region ${region_to} ec2 create-tags  --resources ${new_ami_id} --tags Key=Name,Value=${ami_name}

done

