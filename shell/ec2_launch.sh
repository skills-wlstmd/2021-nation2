#!/bin/bash
name=`echo $1`
cat << EOF > /opt/shell.sh
yum install -y curl
yum update -y
yum install -y jq
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
ln -s /usr/local/bin/aws /usr/bin/
ln -s /usr/local/bin/aws_completer /usr/bin/
yum install -y ruby
wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
rm -rf install
systemctl start codedeploy-agent
systemctl enable codedeploy-agent
EOF
chmod 777 /opt/shell.sh

aws ec2 run-instances \
--image-id ami-0ef0765afb7b7bcc7 \
--count 1 \
--instance-type t3.small \
--key-name wsi \
--security-group-ids <SGID> \
--subnet-id <SubnetId> \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$name'},{Key=wsi:deploy:group,Value=dev-api}]' \
--user-data file:///opt/shell.sh
