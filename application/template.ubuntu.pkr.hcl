variable "ubuntu_ami_id" {
  type    = string
  default = ""
}

variable "app_name" {
  type    = string
  default = ""
}

variable "app_layer" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "ubuntu_ssh_username" {
  type    = string
  default = ""
}

variable "userscript" {
  type    = string
  default = ""
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.app_name}-aws-${var.app_layer}-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.region
  source_ami    = var.ubuntu_ami_id
  ssh_username  = var.ubuntu_ssh_username
  tags = {
    Name = "${var.app_name}-aws-${var.app_layer}"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = var.userscript
    pause_before = "10s"
    timeout      = "10s"       
  }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }
}

