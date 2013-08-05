#!/bin/bash

###
#
# This script will create Pyramus installation bundle
#
#

#  sudo apt-get install openjdk-7-jdk unzip

## Retrieve install packages

echo "cleaning up /tmp/pyramusbundle "

# Change to workdir
rm -r /tmp/pyramusbundle
mkdir -p /tmp/pyramusbundle
cd /tmp/pyramusbundle


echo "creating jboss user for creating bundle"

adduser --system --home=/opt/jboss-user -group jboss
chown jboss: /tmp/pyramusbundle

# Download all packages

echo "Retrieving required components"

sudo -u jboss wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
sudo -u jboss wget https://github.com/otavanopisto/pyramus/raw/master/jboss-as-mysql-module-7.1.1.zip
sudo -u jboss wget http://maven.otavanopisto.fi:7070/nexus/content/repositories/releases/fi/pyramus/pyramus/0.6.4/pyramus-0.6.4.war
sudo -u jboss wget http://maven.otavanopisto.fi:7070/nexus/content/repositories/releases/fi/pyramus/reports/0.6.4/reports-0.6.4.war
sudo -u jboss wget https://github.com/otavanopisto/xmldb-updater/raw/master/dist/xmldb-updater-cmd-2.0.1.zip
sudo -u jboss wget https://pyramus.googlecode.com/files/updates-0.6.3.zip

# wget https://github.com/foofoofoo/diff

echo "Cleaning and creating /opt/jboss and unpacking contents"

rm -r /opt/jboss
mkdir /opt/jboss && chown jboss:jboss /opt/jboss
sudo -u jboss tar -xvf /tmp/pyramusbundle/jboss-as-7.1.1.Final.tar.gz -C /opt/jboss/
sudo -u jboss unzip jboss-as-mysql-module-7.1.1.zip -d /opt/jboss/jboss-as-7.1.1.Final/modules/

sudo -u jboss unzip /tmp/pyramusbundle/xmldb-updater-cmd-2.0.1.zip /opt/jboss/
sudo -u jboss mkdir /opt/jboss/pyramus-updates
sudo -u jboss unzip /tmp/pyramusbundle/updates-0.6.3.zip -d /opt/jboss/pyramus-updates

# Deploying Pyramus components
sudo -u jboss cp pyramus-0.6.4.war /opt/jboss/jboss-as-7.1.1.Final/standalone/deployments/ROOT.war
sudo -u jboss cp reports-0.6.4.war /opt/jboss/jboss-as-7.1.1.Final/standalone/deployments/PyramusReports.war

# Final change: configurations
echo "patching configurations"
cd /opt/jboss
sudo -u jboss patch --verbose -p1 -i /home/pyro/pyramus-standalone-patch.diff

echo "creating package to /tmp/Pyramusbundle-0.6.4-`date -I`.tgz"

# Last but not least, wrap it up as a package
tar -czf /tmp/Pyramusbundle-0.6.4-`date -I`.tgz -C /opt jboss

echo "All done! exiting..."

exit 0
