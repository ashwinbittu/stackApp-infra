variable "source_ami" {
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

variable "ssh_username" {
  type    = string
  default = ""
}

variable "script" {
  type    = string
  default = ""
}

variable "root-device-type" {
  type    = string
  default = ""
}

variable "virtualization-type" {
  type    = string
  default = ""
}

variable "owners" {
  type    = string
  default = ""
}

source "amazon-ebs" "amzlinx" {
  ami_name      = "${var.app_name}-aws-${var.app_layer}-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = var.source_ami
      root-device-type    = var.root-device-type
      virtualization-type = var.virtualization-type
    }
    most_recent = true
    owners      = [var.owners]
  }  
  ssh_username  = var.ssh_username
  tags = {
    Name = "${var.app_name}-aws-${var.app_layer}"
  }
}

build {
  sources = ["source.amazon-ebs.amzlinx"]

  provisioner "shell" {
    script = var.script
    pause_before = "10s"
    timeout      = "10s"       
  }

  post-processor "shell-local" {
    inline = ["echo foo"]
  }
}

