#!/bin/bash

###
#
# This script will install Pyramus from bundle for testing
# 
# THE RESULT IS NOT SECURE FOR PUBLIC SERVICE!
#

#  sudo apt-get install openjdk-7-jdk unzip

# Variable defaults

export TMPDIR="/tmp"
export INSTALLDIR="/opt/jboss"
export JBOSSUSER="jboss"

export DBHOST="localhost"
export DBNAME="pyramus"
export DBUSER="pyramus"
export DBPASSWD="password"

export TARGETHOST="test.pyramus.fi"

# Ask variables
echo "Beginning install process of Pyramus"

echo -n "Enter temporary directory where installation files will be downloaded and/or spread during the process (/tmp):"
read TMPDIR

echo -n "Enter installation directory (/opt/jboss):"
read INSTALLDIR

echo -n "Enter username for the new user created for limited rights (jboss):"
read JBOSSUSER

echo -n "Enter MySQL database host used for Pyramus (localhost):"
read DBHOST

echo -n "Enter MySQL database name used for Pyramus (pyramus):"
read DBNAME

echo -n "Enter MySQL database user (pyramus):"
read DBUSER

echo -n "Enter MySQL database user's password (password):"
read DBPASSWD

echo -n "Enter target hostname the Pyramus install should be accessible from (test.pyramus.fi):"
read TARGETHOST


# Change to workdir
cd $TMPDIR

# Download all packages

echo "Retrieving required components"

# ... we don't have bundle yet
# wget bundle.tar.gz

# Create the user
sudo adduser --system --home=$INSTALLDIR --group $JBOSSUSER
sudo -u $JBOSSUSER tar -xvf $TMPDIR/Pyramusbundle-0.6.4-2013-08-05.tgz -C $INSTALLDIR

# Create the database if not ready
echo " "
echo "######################################################"
echo "Creating MySQL database, asking mysql root password..."
mysql -p -u root -e "create database $DBNAME ; grant all on $DBNAME.* to $DBUSER@$DBHOST identified by '$DBPASSWD';  grant all on $DBNAME.* to $DBUSER@$TARGETHOST identified by '$DBPASSWD'; flush privileges; "

# Modify JBoss configurations according to entered informations:
sudo -u $JBOSSUSER sed -i "s/DBHOST/$DBHOST/" $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

sudo -u $JBOSSUSER sed -i "s/DBNAME/$DBNAME/" $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

sudo -u $JBOSSUSER sed -i "s/DBUSER/$DBUSER/" $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

sudo -u $JBOSSUSER sed -i "s/DBPASSWD/$DBPASSWD/" $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

sudo -u $JBOSSUSER sed -i "s/DBHOST/$DBHOST/" $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

sudo -u $JBOSSUSER sed -i "s/INSTALLDIR/$INSTALLDIR/" $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/standalone.xml

# Adding first Jboss user
echo " "
echo "###################################################"
echo "Create user type Management User to ManagementRealm"
# sudo -u $JBOSSUSER $INSTALLDIR/jboss-as-7.1.1.Final/bin/add-user.sh

# sudo -u $JBOSSUSER mkdir $INSTALLDIR/pyramus-updates
# sudo -u $JBOSSUSER unzip $TMPDIR/updates-0.6.3.zip -d $INSTALLDIR/pyramus-updates
sudo -u $JBOSSUSER java -jar $INSTALLDIR/jboss/xmldb-updater-cmd/xmldb-updater-cmd-2.0.1-jar-with-dependencies.jar --databaseDriversFolder $INSTALLDIR/jboss/jboss-as-7.1.1.Final/modules/com/mysql/jdbc/main/ --databaseUrl jdbc:mysql://$DBHOST:3306/$DBNAME --databaseUsername $DBUSER --databasePassword $DBPASSWD --databaseVendor MySQL --force $INSTALLDIR/jboss/pyramus-updates/updates/

echo " "
echo "############################################################################"
echo "Create user type Application User to realm WebServices with role WebServices"
# sudo -u $JBOSSUSER $INSTALLDIR/jboss-as-7.1.1.Final/bin/add-user.sh

echo "Generating self-signed test certificate for https use"
keytool -genkey -keysize 2048 -keyalg RSA -keystore $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/jboss.keystore -dname "CN=$TARGETHOST, OU=Test, O=Pyramus, L=Test, S=Test, C=FI" -alias tomcat
keytool -exportcert -keystore $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/jboss.keystore -alias tomcat -file $TMPDIR/pyramustmp.cer
keytool -import -v -trustcacerts -alias root -keystore $INSTALLDIR/jboss/jboss-as-7.1.1.Final/standalone/configuration/jboss.keystore -file $TMPDIR/pyramustmp.cer


echo "All done!"

exit 0
