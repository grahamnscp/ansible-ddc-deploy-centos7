# Automated Deploy of HA clustered Docker EE on AWS

This repo contains a Terraform sub-directory that provisions AWS resources required to deploy an HA UCP cluster with an HA DTR cluster.

There is a wrapper script called run-terraform.sh which generates the various configuration files required from the deployment from the personalised values specified in the params.sh file.

The script Terraform apply and then uses it's output to generate the Ansible hosts file for the Ansible playbook deploy of the DDC software.

This repo was developed using a Centos 7.3 AMI but should work with RHEL 7.3 also.


### First populate the following files and parameters as required;

  * files/docker_subscription.lic - needs populating with your licence file contents

  * params.sh -
    * has variables to access AWS hosts,
    * the UCP_ADMIN_PASSWORD is what you want your DDC admin password to be
    * Add your DOCKER_EE_URL as per standard Docker Store setup
    * Set required versions of UCP and DTR ex. 2.1.4 and 2.2.5


### To run


#### Terraform:

This script performs a terraform apply in the terraform sub-directory and then generates an Ansible hosts file

```bash
   $ ./run-terraform.sh
```

Check variables in the auto-generated files:

  * terraform/terraform.tfvars
  * terraform/variables.tf
  * hosts


#### Ansible Playbook:

Please check that the generated Ansible **hosts** file looks good and then run the playbook:

```bash
   $ ansible-playbook -i hosts -s site.yml
```

