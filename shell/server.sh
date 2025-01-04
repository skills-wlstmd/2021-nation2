#!/bin/bash
yum update -y
yum install -y jq
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
yum install -y ruby
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
rm -rf install
systemctl start codedeploy-agent
systemctl enable codedeploy-agent
systemctl status codedeploy-agent