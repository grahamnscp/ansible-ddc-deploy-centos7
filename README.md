# ansible-ddc-deploy-centos7
Ansible Playbook to deploy Docker Data Center (UCP cluster and DTR HA) to AWS EC2 centos7 AMI

Note: this repo is a WIP
TODO: Shared storage for DTR cluster - DTR deployment commented out for now


Deploy hosts with Terraform (or whatever) then hook the IP address, hostname, domainname etc values into the hosts file

NOTE: works best to accept the ssh keys for the IP addresses locally before running the playbook


Run command:
```
   $ ansible-playbook -i hosts -s site.yml
```

