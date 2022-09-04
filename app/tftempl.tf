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
  default = "t2.micro"
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

resource "aws_s3_bucket" "storage" {
  bucket = "s3_storage"
  tags = {
    Name        = "s3_storage"
  }
}

resource "aws_instance" "build"{
       count = var.cnt
       key_name = var.kp
       ami = var.ami
       instance_type = var.itype
       tags = {
         Name = "build"
       }
       security_groups = [var.ivpc]
       subnet_id = var.snet
       associate_public_ip_address = true
}

resource "aws_instance" "web"{
       count = var.cnt
       key_name = var.kp
       ami = var.ami
       instance_type = var.itype
       tags = {
         Name = "web"
       }
       security_groups = [var.ivpc]
       subnet_id = var.snet
       associate_public_ip_address = true
}

output "ip builder"{
value = (aws_instance.build.public_ip,aws_instance.build.private_ip)
}
output "ip web"{
value = (aws_instance.web.public_ip,aws_instance.web.private_ip)
}
output "id s3"{
value = (aws_s3_bucket.storage.id)
}