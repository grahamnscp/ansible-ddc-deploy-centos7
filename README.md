# ansible-ddc-deploy-centos7
Ansible Playbook to deploy Docker Data Center (UCP cluster and DTR HA) to AWS EC2 centos7 AMI

Note: this repo is a WIP

TODO: Implement separate disk device for devicemapper storage
TODO: Shared storage for DTR cluster

Deploy hosts with Terraform (or whatever) then hook the IP address, hostname, domainname etc values into the hosts file)

Run command:
```
   $ ansible-playbook -i hosts -s site.yml
```

