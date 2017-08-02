# Global Variables:

variable "name_prefix" {
  default = "my"
}

variable "domainname" {
  default = "sub.example.com"
}

# Existing route53 zone_id to add sub domain entries to:
variable "route53_zone_id" {
  description = "Existing Route53 zone"
  default = "my existing route53 zone id here"
}

#
variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
#variable "public_key" {}

variable "aws_region" {
#  default = "us-west-2"
  default = "eu-west-2"
}

variable "availability_zones" {
#  default = "us-west-2a,us-west-2b,us-west-2c"
  default = "eu-west-2a,eu-west-2b"
}

variable "aws_centos_ami" {
#  default = "ami-d2c924b2" # centos 7 us-west-2
  default = "ami-bb373ddf" # centos 7 eu-west-2
}

#
variable "docker_volume_size" {
  description = "Size in GB for the second volume attached to the instance used for docker devmapper pool"
  default=31
}

variable "ucp_manager_count" {
  description = "Number of manager nodes, needs to be 3, 5 or 7"
  default = 3
}

variable "ucp_worker_count" {
  description = "Number of worker nodes"
  default = 2
}

variable "ucp_dtr_count" {
  description = "Number of dtr nodes"
  default = 3
}

variable "manager_instance_type" {
  default = "t2.large"
}

variable "worker_instance_type" {
  default = "t2.large"
}

variable "dtr_instance_type" {
  default = "t2.large"
}

variable "ucp_dns" {
  default = "ucp"
}

variable "dtr_dns" {
  default = "dtr"
}

variable "apps_dns" {
  default = "apps"
}

variable "dtr_storage_name" {
  default = "dtr-storage-bucket"
}

