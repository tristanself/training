#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-fcc4db98
#
# Your subnet ID is:
#
#     subnet-fd3241b0
#
# Your security group ID is:
#
#     sg-a2c975ca
#
# Your Identity is:
#
#     terraform-training-zebra
#

terraform {
  backend "atlas" {
    name = "tristanself/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "eu-west-2"
}

variable "num_webs" {
  default = "2"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami           = "ami-fcc4db98"
  instance_type = "t2.micro"
  count         = "${var.num_webs}"

  subnet_id              = "subnet-fd3241b0"
  vpc_security_group_ids = ["sg-a2c975ca"]

  tags {
    "Identity"      = "terraform-training-zebra"
    "Name"          = "web ${count.index + 1}/${var.num_webs}"
    "SecurityLevel" = "Well_Secret"
  }
}

resource "dnsimple_record" "web" {
  domain = "thewebsiteofdoom.com"
  name = "www"
  type = "A"
  value = "${aws_instance.web.0.public_ip}"
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}

output "Name" {
  value = "${aws_instance.web.*.Name}"
}
