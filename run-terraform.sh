#!/bin/bash

TMP_FILE=/tmp/run-terraform.tmp.$$

source ./params.sh


# Subsitute terraform variables to generate terraform/terraform.tfvars
#
echo ">>> Generating Terraform terraform.tfvars file from terraform.tfvars.template.."

cp terraform/terraform.tfvars.template terraform/terraform.tfvars

# Subsitiute tokens "##TOKEN_NAME##"
sed -i "s/##TF_AWS_ACCESS_KEY##/$TF_AWS_ACCESS_KEY/" terraform/terraform.tfvars
sed -i "s/##TF_AWS_SECRET_KEY##/$TF_AWS_SECRET_KEY/" terraform/terraform.tfvars
sed -i "s/##TF_AWS_KEY_NAME##/$TF_AWS_KEY_NAME/" terraform/terraform.tfvars


# Subsitute terraform variables to generate terraform/variables.tf
#
echo ">>> Generating Terraform variables.tf file from variables.template.."

cp terraform/variables.tf.template terraform/variables.tf

# Subsitiute tokens "##TOKEN_NAME##"
sed -i "s/##TF_AWS_INSTANCE_PREFIX##/$TF_AWS_INSTANCE_PREFIX/" terraform/variables.tf
sed -i "s/##TF_AWS_DOMAINNAME##/$TF_AWS_DOMAINNAME/" terraform/variables.tf
sed -i "s/##TF_AWS_ROUTE53_ZONE_ID##/$TF_AWS_ROUTE53_ZONE_ID/" terraform/variables.tf
sed -i "s/##TF_AWS_REGION##/$TF_AWS_REGION/" terraform/variables.tf
sed -i "s/##TF_AWS_AVAILABILITY_ZONES##/$TF_AWS_AVAILABILITY_ZONES/" terraform/variables.tf
sed -i "s/##TF_AWS_CENTOS_AMI##/$TF_AWS_CENTOS_AMI/" terraform/variables.tf
sed -i "s/##TF_AWS_WS2K16_AMI##/$TF_AWS_WS2K16_AMI/" terraform/variables.tf
sed -i "s/##TF_AWS_DOCKER_VOLUME_SIZE##/$TF_AWS_DOCKER_VOLUME_SIZE/" terraform/variables.tf
sed -i "s/##TF_AWS_UCP_MANAGER_COUNT##/$TF_AWS_UCP_MANAGER_COUNT/" terraform/variables.tf
sed -i "s/##TF_AWS_UCP_WORKER_COUNT##/$TF_AWS_UCP_WORKER_COUNT/" terraform/variables.tf
sed -i "s/##TF_AWS_UCP_WINWORK_COUNT##/$TF_AWS_UCP_WINWORK_COUNT/" terraform/variables.tf
sed -i "s/##TF_AWS_MANAGER_INSTANCE_TYPE##/$TF_AWS_MANAGER_INSTANCE_TYPE/" terraform/variables.tf
sed -i "s/##TF_AWS_WORKER_INSTANCE_TYPE##/$TF_AWS_WORKER_INSTANCE_TYPE/" terraform/variables.tf
sed -i "s/##TF_AWS_WINWORK_INSTANCE_TYPE##/$TF_AWS_WINWORK_INSTANCE_TYPE/" terraform/variables.tf
sed -i "s/##TF_AWS_DTR_INSTANCE_TYPE##/$TF_AWS_DTR_INSTANCE_TYPE/" terraform/variables.tf
sed -i "s/##WS2K16_ADMIN_PASSWORD##/$WS2K16_ADMIN_PASSWORD/" terraform/variables.tf
# Catch forward slashes
WS2K16_SSH_KEY_PUB_=`echo $WS2K16_SSH_KEY_PUB | sed 's~/~\\\/~g'`
sed -i "s/##WS2K16_SSH_KEY_PUB##/$WS2K16_SSH_KEY_PUB_/" terraform/variables.tf
WS2K16_DOCKER_WIN_URL_=`echo $WS2K16_DOCKER_WIN_URL | sed 's~/~\\\/~g'`
sed -i "s/##WS2K16_DOCKER_WIN_URL##/$WS2K16_DOCKER_WIN_URL_/" terraform/variables.tf


# Run the terraform deployment..
#
echo ">>> Applying Terraform in subdirectory ./terraform.."

CWD=`pwd`
cd ./terraform


# Run the Terraform apply
echo
/usr/local/bin/terraform apply
echo ">>> done."


# Collect output variables
echo
echo ">>> Collecting variables from terraform output.."
/usr/local/bin/terraform output > $TMP_FILE
cd $CWD

# Some parsing into shell variables and arrays
DATA=`cat $TMP_FILE |sed "s/'//g"|sed 's/\ =\ /=/g'`
DATA2=`echo $DATA |sed 's/\ *\[/\[/g'|sed 's/\[\ */\[/g'|sed 's/\ *\]/\]/g'|sed 's/\,\ */\,/g'`

for var in `echo $DATA2`
do
  var_name=`echo $var | awk -F"=" '{print $1}'`
  var_value=`echo $var | awk -F"=" '{print $2}'|sed 's/\]//g'|sed 's/\[//g'`

#  echo LINE:$var_name: $var_value

  case $var_name in
    "region")
      REGION="$var_value"
#      echo REGION=$REGION
      ;;
    "domain_name")
      DOMAIN_NAME="$var_value"
#      echo DOMAIN_NAME=$DOMAIN_NAME
      ;;

    "dtr_s3_id")
      DTR_S3_ID="$var_value"
#      echo DTR_S3_ID=$DTR_S3_ID
      ;;
    "dtr_s3_arn")
      DTR_S3_ARN="$var_value"
#      echo DTR_S3_ARN=$DTR_S3_ARN
      ;;

    "route53-ucp")
      UCP_LB_FQDN="$var_value"
#      echo UCP_LB_FQDN=$UCP_LB_FQDN
      ;;
    "route53-dtr")
      DTR_LB_FQDN="$var_value"
#      echo DTR_LB_FQDN=$DTR_LB_FQDN
      ;;

    # Managers:
    "ucp-manager-primary-public-name")
      UCP_MANAGER_PRIMARY_PUBLIC_NAME=$var_value
#      echo UCP_MANAGER_PRIMARY_PUBLIC_NAME=$UCP_MANAGER_PRIMARY_PUBLIC_NAME
      ;;
    "ucp-manager-primary-public-ip")
      UCP_MANAGER_PRIMARY_PUBLIC_IP=$var_value
#      echo UCP_MANAGER_PRIMARY_PUBLIC_IP=$UCP_MANAGER_PRIMARY_PUBLIC_IP
      ;;
    "route53-ucp-managers")
      UCP_MANAGERS=$var_value
#      echo UCP_MANAGERS=$UCP_MANAGERS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        MANAGER_NAME[$COUNT]=$entry
#        echo MANAGER_NAME[$COUNT]=${MANAGER_NAME[$COUNT]}
      done
      NUM_MANAGERS=$COUNT
      ;;
    "ucp-managers-public-names")
      UCP_MANAGERS_PUBLIC_NAMES="$var_value"
#      echo UCP_MANAGERS_PUBLIC_NAMES=$UCP_MANAGERS_PUBLIC_NAMES
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        MANAGER_PUBLIC_NAME[$COUNT]=$entry
#        echo MANAGER_PUBLIC_NAME[$COUNT]=${MANAGER_PUBLIC_NAME[$COUNT]}
      done
      ;;
    "ucp-managers-public-ips")
      UCP_MANAGERS_PUBLIC_IPS="$var_value"
#      echo UCP_MANAGERS_PUBLIC_IPS=$UCP_MANAGERS_PUBLIC_IPS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        MANAGER_PUBLIC_IP[$COUNT]=$entry
#        echo MANAGER_PUBLIC_IP[$COUNT]=${MANAGER_PUBLIC_IP[$COUNT]}
      done
      ;;

    # workers:
    "route53-ucp-workers")
      UCP_WORKERS="$var_value"
#      echo UCP_WORKERS=$UCP_WORKERS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        WORKER_NAME[$COUNT]=$entry
#        echo WORKER_NAME[$COUNT]=${WORKER_NAME[$COUNT]}
      done
      NUM_WORKERS=$COUNT
      ;;
    "ucp-workers-public-names")
      UCP_WORKERS_PUBLIC_NAMES="$var_value"
#      echo UCP_WORKERS_PUBLIC_NAMES=$UCP_WORKERS_PUBLIC_NAMES
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        WORKER_PUBLIC_NAME[$COUNT]=$entry
#        echo WORKER_PUBLIC_NAME[$COUNT]=${WORKER_PUBLIC_NAME[$COUNT]}
      done
      ;;
    "ucp-workers-public-ips")
      UCP_WORKERS_PUBLIC_IPS="$var_value"
#      echo UCP_WORKERS_PUBLIC_IPS=$UCP_WORKERS_PUBLIC_IPS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        WORKER_PUBLIC_IP[$COUNT]=$entry
#        echo WORKER_PUBLIC_IP[$COUNT]=${WORKER_PUBLIC_IP[$COUNT]}
      done
      ;;
    "route53-ucp-winworks")
      UCP_WINWORK="$var_value"
#      echo UCP_WINWORKE=$UCP_WINWORK
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        WINWORK_NAME[$COUNT]=$entry
#        echo WINWORK_NAME[$COUNT]=${WINWORK_NAME[$COUNT]}
      done
      NUM_WINWORK=$COUNT
      ;;
    "ucp-winwork-public-names")
      UCP_WINWORK_PUBLIC_NAMES="$var_value"
#      echo UCP_WINWORK_PUBLIC_NAMES=$UCP_WINWORK_PUBLIC_NAMES
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        WORKER_PUBLIC_NAME[$COUNT]=$entry
#        echo WINWORK_PUBLIC_NAME[$COUNT]=${WINWORK_PUBLIC_NAME[$COUNT]}
      done
      ;;
    "ucp-winwork-public-ips")
      UCP_WINWORK_PUBLIC_IPS="$var_value"
#      echo UCP_WINWORK_PUBLIC_IPS=$UCP_WINWORK_PUBLIC_IPS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        WINWORK_PUBLIC_IP[$COUNT]=$entry
#        echo WINWORK_PUBLIC_IP[$COUNT]=${WINWORK_PUBLIC_IP[$COUNT]}
      done
      ;;

    # DTRs:
    "route53-ucp-dtrs")
      UCP_DTRS="$var_value"
#      echo UCP_DTRS=$UCP_DTRS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        DTR_NAME[$COUNT]=$entry
#        echo DTR_NAME[$COUNT]=${DTR_NAME[$COUNT]}
      done
      NUM_DTRS=$COUNT
      ;;
    "dtrs-public-names")
      DTRS_PUBLIC_NAMES="$var_value"
#      echo DTRS_PUBLIC_NAMES=$DTRS_PUBLIC_NAMES
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        DTR_PUBLIC_NAME[$COUNT]=$entry
#        echo DTR_PUBLIC_NAME[$COUNT]=${DTR_PUBLIC_NAME[$COUNT]}
      done
      ;;
    "dtrs-public-ips")
      DTRS_PUBLIC_IPS="$var_value"
#      echo DTRS_PUBLIC_IPS=$DTRS_PUBLIC_IPS
      COUNT=0
      for entry in $(echo $var_value |sed "s/,/ /g")
      do
        COUNT=$(($COUNT+1))
        DTR_PUBLIC_IP[$COUNT]=$entry
#        echo DTR_PUBLIC_IP[$COUNT]=${DTR_PUBLIC_IP[$COUNT]}
      done
      ;;
  esac
done

echo ">>> done."


# Output shell variables
echo
echo ">>> Variables from Terraform output are:"
echo REGION=$REGION
echo DOMAIN_NAME=$DOMAIN_NAME
echo UCP_LB_FQDN=$UCP_LB_FQDN
echo DTR_LB_FQDN=$DTR_LB_FQDN

echo UCP_MANAGER_PRIMARY_PUBLIC_NAME=$UCP_MANAGER_PRIMARY_PUBLIC_NAME
echo UCP_MANAGER_PRIMARY_PUBLIC_IP=$UCP_MANAGER_PRIMARY_PUBLIC_IP

echo NUM_MANAGERS=$NUM_MANAGERS
for (( COUNT=1; COUNT<=$NUM_MANAGERS; COUNT++ ))
do
  echo MANAGER_NAME[$COUNT]=${MANAGER_NAME[$COUNT]}
  echo MANAGER_PUBLIC_NAME[$COUNT]=${MANAGER_PUBLIC_NAME[$COUNT]}
  echo MANAGER_PUBLIC_IP[$COUNT]=${MANAGER_PUBLIC_IP[$COUNT]}
done

echo NUM_WORKERS=$NUM_WORKERS
for (( COUNT=1; COUNT<=$NUM_WORKERS; COUNT++ ))
do
  echo WORKER_NAME[$COUNT]=${WORKER_NAME[$COUNT]}
  echo WORKER_PUBLIC_NAME[$COUNT]=${WORKER_PUBLIC_NAME[$COUNT]}
  echo WORKER_PUBLIC_IP[$COUNT]=${WORKER_PUBLIC_IP[$COUNT]}
done

echo NUM_WINWORK=$TF_AWS_UCP_WINWORK_COUNT
for (( COUNT=1; COUNT<=$TF_AWS_UCP_WINWORK_COUNT; COUNT++ ))
do
  echo WINWORK_NAME[$COUNT]=${WINWORK_NAME[$COUNT]}
  echo WINWORK_PUBLIC_NAME[$COUNT]=${WINWORK_PUBLIC_NAME[$COUNT]}
  echo WINWORK_PUBLIC_IP[$COUNT]=${WINWORK_PUBLIC_IP[$COUNT]}
done

echo NUM_DTRS=$NUM_DTRS
for (( COUNT=1; COUNT<=$NUM_DTRS; COUNT++ ))
do
  echo DTR_NAME[$COUNT]=${DTR_NAME[$COUNT]}
  echo DTR_PUBLIC_NAME[$COUNT]=${DTR_PUBLIC_NAME[$COUNT]}
  echo DTR_PUBLIC_IP[$COUNT]=${DTR_PUBLIC_IP[$COUNT]}
done

echo DTR_S3_ID=$DTR_S3_ID
echo DTR_S3_ARN=$DTR_S3_ARN
echo ">>> done."


# Parse Ansible hosts.template to generate the Ansible hosts file
#
echo
echo ">>> Generating Ansible hosts file from hosts.template.."
cp ./hosts.template hosts

# Subsitiute tokens "##TOKEN_NAME##"
sed -i "s/##DOMAIN_NAME##/$DOMAIN_NAME/" ./hosts
sed -i "s/##UCP_EXTERNAL_FQDN##/$UCP_LB_FQDN/g" ./hosts
sed -i "s/##DTR_EXTERNAL_FQDN##/$DTR_LB_FQDN/g" ./hosts
#sed -i "s/##UCP_EXTERNAL_FQDN##/${MANAGER_PUBLIC_NAME[1]}/g" ./hosts
#sed -i "s/##DTR_EXTERNAL_FQDN##/${DTR_PUBLIC_NAME[1]}/g" ./hosts

sed -i "s/##REGION##/$REGION/" ./hosts
sed -i "s/##DTR_S3_ID##/$DTR_S3_ID/" ./hosts
sed -i "s/##DTR_S3_ARN##/$DTR_S3_ARN/" ./hosts
for (( COUNT=1; COUNT<=$NUM_MANAGERS; COUNT++ ))
do
  sed -i "s/##MANAGER_NAME_${COUNT}##/${MANAGER_NAME[$COUNT]}/" ./hosts
  sed -i "s/##MANAGER_PUBLIC_IP_${COUNT}##/${MANAGER_PUBLIC_IP[$COUNT]}/" ./hosts
done
for (( COUNT=1; COUNT<=$NUM_DTRS; COUNT++ ))
do
  sed -i "s/##DTR_NAME_${COUNT}##/${DTR_NAME[$COUNT]}/" ./hosts
  sed -i "s/##DTR_PUBLIC_IP_${COUNT}##/${DTR_PUBLIC_IP[$COUNT]}/" ./hosts
done
# Append variable number of worker nodes to ansible hosts file
echo "" >> ./hosts
echo "[ucp-workers]" >> ./hosts
for (( COUNT=1; COUNT<=$NUM_WORKERS; COUNT++ ))
do
  echo "ucp-worker${COUNT} ansible_host=${WORKER_PUBLIC_IP[$COUNT]} fqdn=${WORKER_NAME[$COUNT]}" >> ./hosts
done
echo "" >> ./hosts
echo "#[ucp-winworkers]" >> ./hosts
for (( COUNT=1; COUNT<=$NUM_WINWORK; COUNT++ ))
do
  echo "#ucp-winwork${COUNT} ansible_host=${WINWORK_PUBLIC_IP[$COUNT]} fqdn=${WINWORK_NAME[$COUNT]}" >> ./hosts
done
echo "" >> ./hosts

# From params.sh
sed -i "s/##ANSIBLE_USER##/$ANSIBLE_USER/" ./hosts
_ANSIBLE_SSH_PRIVATE_KEY_FILE=$(echo $ANSIBLE_SSH_PRIVATE_KEY_FILE | sed 's/\//\\\//g')
sed -i "s/##ANSIBLE_SSH_PRIVATE_KEY_FILE##/$_ANSIBLE_SSH_PRIVATE_KEY_FILE/" ./hosts
_DOCKER_STORAGE_DEVICE=$(echo $DOCKER_STORAGE_DEVICE | sed 's/\//\\\//g')
sed -i "s/##DOCKER_STORAGE_DEVICE##/$_DOCKER_STORAGE_DEVICE/" ./hosts
sed -i "s/##UCP_ADMIN_USERNAME##/$UCP_ADMIN_USERNAME/" ./hosts
sed -i "s/##UCP_ADMIN_PASSWORD##/$UCP_ADMIN_PASSWORD/" ./hosts
_DOCKER_EE_URL=$(echo $DOCKER_EE_URL | sed 's/\//\\\//g')
sed -i "s/##DOCKER_EE_URL##/$_DOCKER_EE_URL/" ./hosts
sed -i "s/##DOCKER_EE_RELEASE##/$DOCKER_EE_RELEASE/" ./hosts
sed -i "s/##DOCKER_HUB_ORG##/$DOCKER_HUB_ORG/" ./hosts
sed -i "s/##DOCKER_HUB_ORG_DTR##/$DOCKER_HUB_ORG_DTR/" ./hosts
sed -i "s/##DOCKER_HUB_USERNAME##/$DOCKER_HUB_USERNAME/" ./hosts
sed -i "s/##DOCKER_HUB_PASSWORD##/$DOCKER_HUB_PASSWORD/" ./hosts
sed -i "s/##UCP_VERSION##/$UCP_VERSION/" ./hosts
sed -i "s/##DTR_VERSION##/$DTR_VERSION/" ./hosts
echo ">>> done."


echo
echo ">>> Loop through hosts to accept keys before running Ansible playbook.."
MANAGERS=`for (( i=1; i<=$NUM_MANAGERS; i++ )) ; do echo ${MANAGER_NAME[$i]} ; done`
WORKERS=`for (( i=1; i<=$NUM_WORKERS; i++ )) ; do echo ${WORKER_NAME[$i]} ; done`
DTRS=`for (( i=1; i<=$NUM_DTRS; i++ )) ; do echo ${DTR_NAME[$i]} ; done`
HOSTS="$MANAGERS $WORKERS $DTRS"
#for host in $HOSTS ;  do echo "Connecting to host: ${host}..." ; ssh-keyscan -H $host >> ~/.ssh/known_hosts ; done
echo ">>> Loop through hosts to accept keys before running Ansible playbook (CTRL-D to disconnect from each host in loop).."
#for host in $HOSTS ;  do echo "Connecting to host: ${host}..." ; ssh -i $ANSIBLE_SSH_PRIVATE_KEY_FILE $ANSIBLE_USER@$host ; done
echo ">>> done."


# Don't run the ansible automatically, prompt with command:
#
echo 
echo "################################################################"
echo ">>> Please check the Ansible hosts file and run the playbook <<<"
echo ">>>                                                          <<<"
echo ">>>    ansible-playbook -i hosts -s site.yml                 <<<"
echo ">>>                                                          <<<"
echo "################################################################"
echo


/bin/rm $TMP_FILE
exit 0

