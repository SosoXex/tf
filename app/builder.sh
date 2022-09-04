#!/bin/bash
apt update && apt install -y aws-cli default-jdk git maven && aws s3 ls