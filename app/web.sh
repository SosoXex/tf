#!/bin/bash
apt update && apt install -y aws-cli default-jdk tomcat9 && aws s3 ls