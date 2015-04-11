#!/usr/bin/env bash

# Variables
admin-user=admin
admin-pass=password

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y python-software-properties


# Install Java 7
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java7-installer oracle-java7-set-default

# Install Tomcat7
sudo apt-get install -y tomcat7
sudo apt-get install -y tomcat7-docs tomcat7-admin tomcat7-examples

# Set JAVA_HOME variable
sudo sed -ri 's|#JAVA_HOME=/usr/lib/jvm/openjdk-6-jdk|JAVA_HOME=/usr/lib/jvm/java-7-oracle|g' /etc/default/tomcat7

# Add admin user for manager-gui and admin-gui
sudo sed '/<tomcat-users>/a <user username="$admin-user" password="$admin-pass" roles="manager-gui,admin-gui"/>' /etc/tomcat7/tomcat-users.xml 
sudo service tomcat7 restart

# Download Sesame 2.8.1-sdk
cd /vagrant
wget -O sesame.tar.gz http://sourceforge.net/projects/sesame/files/Sesame%202/2.8.1/openrdf-sesame-2.8.1-sdk.tar.gz/download
tar -xvf sesame.tar.gz
sudo rm sesame.tar.gz

# Grant permissions to user tomcat7
sudo chown -R tomcat7:tomcat7 /usr/share/tomcat7 

# Deploy openrdf-sesame and openrdf-workbench wars
sudo cp openrdf-sesame-2.8.1/war/openrdf-sesame.war /var/lib/tomcat7/webapps/
sudo cp openrdf-sesame-2.8.1/war/openrdf-workbench.war /var/lib/tomcat7/webapps/
sudo rm -r openrdf-sesame-2.8.1/
sudo service tomcat7 restart

# Delete remaining war files
sudo rm /var/lib/tomcat7/webapps/openrdf-workbench.war
sudo rm /var/lib/tomcat7/webapps/openrdf-sesame.war
