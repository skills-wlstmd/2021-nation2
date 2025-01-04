#!/bin/bash
yum update -y
yum install curl -y
yum install git -y
yum install jq -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
ln -s /usr/local/bin/aws /usr/bin/
ln -s /usr/local/bin/aws_completer /usr/bin/
sed  -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
service sshd restart
echo 'skills123@' | passwd --stdin ec2-user

mkdir scripts

cat << EOF > scripts/BeforeInstall.sh
#!/bin/bash
if [ -d /opt/scripts/ ]; then
    sudo rm -rf /opt/scripts/
fi

mkdir -p /opt/scripts/
EOF

cat << EOF > scripts/AfterInstall.sh
#!/bin/bash
sudo yum install -y python3-pip
pip3 install flask
EOF

cat << EOF > scripts/ApplicationStart.sh
#!/bin/bash
cd /opt/scripts/
nohup python3 app.pyc > /dev/null 2>&1 &
EOF

cat << EOF > scripts/ApplicationStop.sh # 직접 넣어주기
#!/bin/bash
SERVER_STATUS=$(curl -sS -o /dev/null -w "%{http_code}" localhost:80/health)
PYTHON_PID=$(pgrep python3)

if [ $SERVER_STATUS == 200 ]; then
    kill -9 $PYTHON_PID
    echo "killed python pid"
fi
EOF

sudo python3 app.py > /dev/null &