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

resource "aws_s3_bucket" "hw14s3war-s3-war" {
  bucket = "hw14s3war-s3-war"
  tags = {
    Name        = "hw14s3war-s3-war"
  }
}

resource "aws_instance" "build"{
       key_name = var.kp
       ami = var.ami
       instance_type = var.itype
       user_data = <<EOF
#!/bin/bash
echo "Installing NodeExporter"
mkdir /home/ubuntu/node_exporter
cd /home/ubuntu/node_exporter
echo "Changing Hostname"
touch 1
EOF
       security_groups = [var.ivpc]
       subnet_id = var.snet
       associate_public_ip_address = true
       tags = {
         Name = "build"
       }
}

resource "aws_instance" "web"{
       key_name = var.kp
       ami = var.ami
       instance_type = var.itype
       tags = {
         Name = "web"
       }
       security_groups = [var.ivpc]
       user_data = <<EOF
#!/bin/bash
echo "Installing NodeExporter"
mkdir /home/ubuntu/node_exporter
cd /home/ubuntu/node_exporter
echo "Changing Hostname"
touch 1
EOF
       subnet_id = var.snet
       associate_public_ip_address = true
}

output "ip_builder"{
value = aws_instance.build.public_ip
}
output "ip_web"{
value = aws_instance.web.public_ip
}
output "id_s3"{
value = aws_s3_bucket.hw14s3war-s3-war.id
}