#!/bin/bash
set -x
sudo echo "Hello" >> h123
sudo yum install java-11-openjdk-devel -y
sudo yum install wget -y
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
sudo tar -zvxf apache-maven-3.8.5-bin.tar.gz
sudo mv apache-maven-3.8.5 /opt/maven
sudo rm apache-maven-3.8.5-bin.tar.gz -f
sudo yum install git -y
#sudo su -
