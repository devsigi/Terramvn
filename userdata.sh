#!/bin/bash
sudo yum install java-11-openjdk-devel -y
sudo yum install wget -y
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
sudo tar -zvxf apache-maven-3.8.5-bin.tar.gz
sudo mv apache-maven-3.8.5 /opt/maven
sudo rm apache-maven-3.8.5-bin.tar.gz -y
sudo yum install git -y

Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
sudo export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.14.1.1-2.el8_5.x86_64
sudo export M2_HOME=/opt/maven
sudo export M2=$M2_HOME/bin
sudo export PATH=$JAVA_HOME/bin:$M2_HOME:$M2:$PATH
--//--
