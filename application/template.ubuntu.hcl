variable "ami_id" {
  type    = string
  default = "ami-0e040c48614ad1327"
}

variable "app_name" {
  type    = string
  default = "httpd"
}

variable "region" {
  type    = string
}

locals {
    app_name = "httpd"
}

source "amazon-ebs" "ubuntu" {
  access_key = "ASDFASDFASDFJQWEKONNOASDF"
  secret_key = "SDFQ324876134HJKLASDBJKASDJFHBAJSDFJKHASKDG"
  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.region
  source_ami    = "${var.ami_id}"
  ssh_username  = "ubuntu"
  tags = {
    Env  = "DEMO"
    Name = "PACKER-DEMO-${var.app_name}"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "userdata/tomcat.sh"
  }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }
}