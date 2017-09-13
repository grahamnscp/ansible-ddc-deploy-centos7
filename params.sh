#
# These variables are subsituted into templates buy run-terraform.sh
#

# Terraform Variables - terraform/variables.tf.template -> terraform/variables.tf
#
# note: keep TF_AWS_INSTANCE_PREFIX short as prepends AWS instance names
TF_AWS_INSTANCE_PREFIX=MY
TF_AWS_DOMAINNAME=MY.existing.domain
#
TF_AWS_ROUTE53_ZONE_ID=MY-existingroute53zoneid
#
TF_AWS_REGION=awsregion
TF_AWS_AVAILABILITY_ZONES=availabilityzonea,availabilityzoneb
TF_AWS_CENTOS_AMI=ami-bb373ddf
#TF_AWS_WS2K16_AMI=ami-57435533
TF_AWS_WS2K16_AMI=ami-76e4f512
#
TF_AWS_DOCKER_VOLUME_SIZE=31
TF_AWS_UCP_MANAGER_COUNT=3
TF_AWS_UCP_WORKER_COUNT=2
TF_AWS_UCP_WINWORK_COUNT=2
#
TF_AWS_MANAGER_INSTANCE_TYPE=t2.large
TF_AWS_WORKER_INSTANCE_TYPE=t2.large
TF_AWS_WINWORK_INSTANCE_TYPE=m4.xlarge # has issue with swarm join -> network related?
TF_AWS_WINWORK_INSTANCE_TYPE=i3.xlarge
TF_AWS_DTR_INSTANCE_TYPE=t2.large

# Windows instance user_data variables
#
WS2K16_ADMIN_PASSWORD="P@55W0rdH3re!"
WS2K16_SSH_KEY_PUB="ssh-rsa MY-pubsshkeyhere MY-username@example.com"
WS2K16_DOCKER_WIN_URL="https://download.docker.com/components/engine/windows-server/17.06/docker-17.06.1-ee-2.zip"


# terraform/terraform.tfvars.template -> terraform/terraform.tfvars
#
TF_AWS_ACCESS_KEY=MY-awskey
TF_AWS_SECRET_KEY="MY-awssecretkey"
TF_AWS_KEY_NAME=MY-awskeyname

# Ansible Variables - hosts.template -> hosts
#
ANSIBLE_USER=centos 
ANSIBLE_SSH_PRIVATE_KEY_FILE=/home/MY-username/.ssh/MY-awsusersshkey.pem
#
DOCKER_STORAGE_DEVICE=/dev/xvdb
#
UCP_ADMIN_USERNAME=admin
UCP_ADMIN_PASSWORD=MY-ucpadminpassword
#
DOCKER_EE_URL=https://storebits.docker.com/ee/linux/sub-<MY url>
DOCKER_EE_RELEASE=stable-17.06
#
DOCKER_HUB_ORG=docker
DOCKER_HUB_ORG_DTR=docker
DOCKER_HUB_USERNAME=MY-hubusername
DOCKER_HUB_PASSWORD=MY-hubpassword
#
UCP_VERSION=2.2.2
DTR_VERSION=2.3.2


