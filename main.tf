#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-fcc4db98
#
# Your subnet ID is:
#
#     subnet-092c0d72
#
# Your security group ID is:
#
#     sg-a2c975ca
#
# Your Identity is:
#
#     terraform-training-hound
#

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-2"
}

variable "num_webs" {
  default = "2"
}

variable "dnsimple_token" {
  default = "toke"
}

variable "dnsimple_account" {
  default = "fakeNEWS"
}

terraform {
  backend "atlas" {
    name = "jc18-sanger/training"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#provider "dnsimple" {
#  token   = "${var.dnsimple_token}"
#  account = "${var.dnsimple_account}"
#}
#
#resource "dnsimple_record" "anything" {
#  # ...
#  "domain" = "sanger.ca.uk"
#  "type"   = "A"
#  "name"   = "anything"
#  "value"  = "${aws_instance.web.0.public_ip}"
#}

resource "aws_instance" "web" {
  # ...
  "count"                = "${var.num_webs}"
  ami                    = "ami-fcc4db98"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-092c0d72"
  vpc_security_group_ids = ["sg-a2c975ca"]

  tags {
    "Identity" = "terraform-training-hound"
    "Name"     = "web ${count.index + 1} / ${var.num_webs}"
    "Group"    = "ISG"
  }
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}

output "Name" {
  value = "${aws_instance.web.*.tags.Name}"
}
