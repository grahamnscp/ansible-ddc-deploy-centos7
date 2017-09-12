# Host Instances:

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}


# UCP Manager Instances:
#
resource "aws_instance" "ucp-manager" {
  ami           = "${var.aws_centos_ami}"
  instance_type = "${var.manager_instance_type}"
  key_name      = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"

  root_block_device {
    volume_type = "gp2"
    delete_on_termination = true
  }

  # Second disk for docker storage
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "${var.docker_volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  count = "${var.ucp_manager_count}"

  security_groups = [ "${aws_security_group.ddc.name}" ]
  availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${var.name_prefix}_ucp-manager${count.index + 1}"
  }
}


# UCP Worker Instances:
#
# Linux Workers:
#
resource "aws_instance" "ucp-worker" {
  ami           = "${var.aws_centos_ami}"
  instance_type = "${var.worker_instance_type}"
  key_name      = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"

  root_block_device {
    volume_type = "gp2"
    delete_on_termination = true
  }

  # Second disk for docker storage
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "${var.docker_volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  count = "${var.ucp_worker_count}"

  security_groups = [ "${aws_security_group.ddc.name}" ]
  availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${var.name_prefix}_ucp-node${count.index + 1}"
  }
}


# Windows Workers:
#
resource "aws_instance" "ucp-winwork" {
  ami           = "${var.aws_ws2k16_ami}"
  instance_type = "${var.winwork_instance_type}"
  key_name      = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"

  root_block_device {
    volume_size = "50"
  }

  # Second disk for docker storage
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "${var.docker_volume_size}"
    volume_type = "standard"
    delete_on_termination = true
  }

  count = "${var.ucp_winwork_count}"

  security_groups = [ "${aws_security_group.ddc.name}" ]
  availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${var.name_prefix}_ucp-winwork${count.index + 1}"
  }

  user_data = "${data.template_file.win_user_data.rendered}"
}


# DTR Instances:
#
resource "aws_instance" "ucp-dtr" {
  ami           = "${var.aws_centos_ami}"
  instance_type = "${var.dtr_instance_type}"
  key_name      = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"

  root_block_device {
    volume_type = "gp2"
    delete_on_termination = true
  }

  # Second disk for docker storage
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "${var.docker_volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }

  count = "${var.ucp_dtr_count}"

  security_groups = [ "${aws_security_group.ddc.name}" ]
  availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${var.name_prefix}_ucp-dtr${count.index + 1}"
  }
}

