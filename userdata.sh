#!/bin/bash
sudo yum -y update
sudo yum upgrade
# Install OpenJdk 8
sudo yum install java-11-openjdk-devel -y
#sudo amazon-linux-extras install java-openjdk11 -y
# Install wget
sudo yum install wget -y
# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y update
sudo yum install jenkins -y
sudo systemctl start jenkins
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.15.0.9-2.el8_5.x86_64"
export PATH=$JAVA_HOME/bin:$PATH
