terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-central-1"
}

variable "snet"{
  default = "subnet-081298183b5a18fe4"
}
variable "ami" {
  default = "ami-0c9354388bb36c088"
}
variable "itype" {
  type = list(string)
  default = ["t2.micro"]
}

variable "rtags" {
  default     = "l15instance"
  }
variable "kp"{
default = "L14"
}
variable "cnt"{
default = "1"
}
variable "ivpc"{
default = "sg-0e2711cc241cc7671"
}
resource "aws_instance" "test"{
       count = var.cnt
       key_name = var.kp
       ami = var.ami
       instance_type = element(var.itype, count.index)
       tags = {
         Name = "${var.rtags}-${count.index+1}"
       }
       security_groups = [var.ivpc]
       subnet_id = var.snet
       associate_public_ip_address = true
}
