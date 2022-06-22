#data "aws_region" "current" {}

data "aws_ami" "amzlinux" {
    owners = ["${var.ownwer}"]
    filter {
      name = "description"
      values = ["${var.image_desc}"]
    }
}

resource "aws_instance" "prd-spoke1" {
  ami = data.aws_ami.amzlinux.id
  instance_type = "${var.instance_type}"
  subnet_id =  "${subnet_id}"
  key_name = "${key_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  tags = {
    Name = "${var.tags}"
  }
}