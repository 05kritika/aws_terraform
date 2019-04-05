output "elb_address" {
  value = "${aws_elb.web.dns_name}"
}

output "instance_id" {
  value = "${aws_instance.web.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "ami_id" {
  value = "${aws_instance.web.ami}"

}

output "ec2_security_group" {
  value = "${aws_security_group.default.name}"

}

output "elb_security_group" {
  value = "${aws_security_group.elb.name}"

}
