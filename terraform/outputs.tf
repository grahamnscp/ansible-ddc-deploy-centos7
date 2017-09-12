# Output Values:

output "region" {
  value = "${var.aws_region}"
}
output "domain_name" {
  value = "${var.domainname}"
}

output "ucp-manager-primary-public-name" {
  value = "${element(aws_instance.ucp-manager.*.public_dns,0)}"
}
output "ucp-manager-primary-public-ip" {
  value = "${element(aws_instance.ucp-manager.*.public_ip,0)}"
}

output "ucp-managers-public-names" {
  value = ["${aws_instance.ucp-manager.*.public_dns}"]
}
output "ucp-managers-public-ips" {
  value = ["${aws_instance.ucp-manager.*.public_ip}"]
}

output "ucp-workers-public-names" {
  value = ["${aws_instance.ucp-worker.*.public_dns}"]
}
output "ucp-workers-public-ips" {
  value = ["${aws_instance.ucp-worker.*.public_ip}"]
}

output "ucp-winwork-public-names" {
  value = ["${aws_instance.ucp-winwork.*.public_dns}"]
}
output "ucp-winwork-public-ips" {
  value = ["${aws_instance.ucp-winwork.*.public_ip}"]
}

output "dtr-primary-public-name" {
  value = "${element(aws_instance.ucp-dtr.*.public_dns,0)}"
}
output "dtrs-public-names" {
  value = ["${aws_instance.ucp-dtr.*.public_dns}"]
}
output "dtrs-public-ips" {
  value = ["${aws_instance.ucp-dtr.*.public_ip}"]
}

output "dtr_s3_id" {
  value = "${aws_s3_bucket.dtr-storage-bucket.id}"
}
output "dtr_s3_arn" {
  value = "${aws_s3_bucket.dtr-storage-bucket.arn}"
}

output "route53-ucp" {
  value = "${aws_route53_record.ucp.name}"
}
output "route53-dtr" {
  value = "${aws_route53_record.dtr.name}"
}
output "route53-apps" {
  value = "${aws_route53_record.apps.name}"
}
output "route53-ucp-managers" {
  value = ["${aws_route53_record.ucp-manager.*.name}"]
}
output "route53-ucp-workers" {
  value = ["${aws_route53_record.ucp-worker.*.name}"]
}
output "route53-ucp-winworks" {
  value = ["${aws_route53_record.ucp-winwork.*.name}"]
}
output "route53-ucp-dtrs" {
  value = ["${aws_route53_record.ucp-dtr.*.name}"]
}

output "elb-ucp-instances" {
  value = ["${aws_elb.ucp.*.instances}"]
}
output "elb-dtr-instances" {
  value = ["${aws_elb.dtr.*.instances}"]
}
output "elb-apps-instances" {
  value = ["${aws_elb.apps.*.instances}"]
}
