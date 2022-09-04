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

variable "keyname"{
default = "bw1"
}

resource "tls_private_key" "newkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.keyname
  public_key = tls_private_key.newkey.public_key_openssh
}

resource "aws_s3_bucket" "hw14s3war-s3-war" {
  bucket = "hw14s3war-s3-war"
  tags = {
    Name        = "hw14s3war-s3-war"
  }
}

resource "aws_instance" "build"{
       key_name = aws_key_pair.generated_key.key_name
       ami = var.ami
       instance_type = var.itype
       security_groups = [var.ivpc]
       subnet_id = var.snet
       associate_public_ip_address = true
       tags = {
         Name = "build"
       }
       connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.newkey.private_key_pem
    host     = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y git default-jdk aws-cli maven",
      "git clone https://github.com/koddas/war-web-project.git",
      "mvn -f ./war-web-project package",
    ]
  }
}

resource "aws_instance" "web"{
       key_name = aws_key_pair.generated_key.key_name
       ami = var.ami
       instance_type = var.itype
       tags = {
         Name = "web"
       }
       security_groups = [var.ivpc]
       subnet_id = var.snet
       associate_public_ip_address = true

       connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.newkey.private_key_pem
    host     = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y aws-cli tomcat9",
    ]
  }
}

output "ip_builder"{
value = aws_instance.build.public_ip
}
output "pip_builder"{
value = aws_instance.build.private_ip
}
output "ip_web"{
value = aws_instance.web.public_ip
}
output "pip_web"{
value = aws_instance.web.private_ip
}
output "id_s3"{
value = aws_s3_bucket.hw14s3war-s3-war.id
}
output "private_key" {
  value     = tls_private_key.newkey.private_key_pem
  sensitive = true
}