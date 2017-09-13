# Windows bits

data "template_file" "win_user_data" {

  template = "${file("win_user_data.tpl")}"

  vars {
    p_hostname = "ucp-winwork${count.index + 1}"
    p_domainname = "${var.domainname}"
    p_adminpwd = "${var.ws2k16_admin_password}"
    p_sshkey = "${var.ws2k16_ssh_key_pub}"
    p_dockerwinurl = "${var.ws2k16_docker_win_url}"
  }
}

