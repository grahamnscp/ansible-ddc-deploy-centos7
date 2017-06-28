# ansible-ddc-deploy-centos7

This repo contains a Terraform sub-directory that provisions AWS resources required to deploy an HA UCP cluster with an HA DTR cluster.

There is a wrapper script that runs the Terraform apply and then uses it's output to generate the Ansible hosts file for the Ansible playbook deploy of the DDC software.

It was developed using a Centos 7.3 AMI but should work with RHEL 7.3 also.

Docker EE versions used at time of deploy are: 
  * engine 17.03-ee
  * UCP 2.1.4
  * DTR 2.2.5

First polulate the following files with your specific values:

Then run:

```bash
   $ ./run-terrform.sh
```

Check the generated Ansible *hosts* file looks good and then run the playbook:

Run command:

```bash
   $ ansible-playbook -i hosts -s site.yml
```

