# ansible-ddc-deploy-centos7

This repo contains a Terraform sub-directory that provisions AWS resources required to deploy an HA UCP cluster with an HA DTR cluster.

There is a wrapper script that runs the Terraform apply and then uses it's output to generate the Ansible hosts file for the Ansible playbook deploy of the DDC software.

It was developed using a Centos 7.3 AMI but should work with RHEL 7.3 also.

Docker EE versions used at time of development where: 
  * docker-ee-17.03.2.ee.4-1.el7.centos.x86_64
  * UCP 2.1.4
  * DTR 2.2.5


### First populate the following files and parameters as required;

  * files/docker_subscription.lic - needs populating with your licence file contents

  * params.sh - 
    * has variables to access AWS hosts,
    * the UCP_ADMIN_PASSWORD is what you want your DDC admin password to be
    * Add your DOCKER_EE_URL as per standard Docker Store setup
    * Set required versions of UCP and DTR ex. 2.1.4 and 2.2.5

  * terraform/terraform.tfvars - contains your AWS access key and secret values
    * note: the key_name is the name of your AWS key without the .pem extension


### To run:

#### Terraform:

This script performs a terraform apply in the terraform sub-directory and then generates an Ansible hosts file

```bash
   $ ./run-terrform.sh
```

#### Ansible Playbook:

Please check that the generated Ansible **hosts** file looks good and then run the playbook:

```bash
   $ ansible-playbook -i hosts -s site.yml
```

