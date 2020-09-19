#!/bin/bash
sudo rm -rf /var/www/mediawiki
sudo aws s3 cp s3://deployment-zips-mediawiki/mediawiki.tar /home/centos/mediawiki.tar
sudo tar -xvf /home/centos/mediawiki.tar -C /var/www/
sudo mv /var/www/mediawiki-1.34.2 /var/www/mediawiki
sleep 30
sudo aws s3 cp s3://resource-softwares-files/LocalSettings.php /var/www/mediawiki/LocalSettings.php
sudo chown centos:centos /var/www/mediawiki/LocalSettings.php
sudo chown apache:apache /var/www/mediawiki
secret=`aws secretsmanager  get-secret-value --region ap-south-1 --secret-id mysql-credentials --query "SecretString" --output text`
dbname=`echo $secret | jq -r ".db_name"`
dbuser=`echo $secret | jq -r ".db_username"`
dbpassword=`echo $secret | jq -r ".db_password"`
dbhost=`echo $secret | jq -r ".db_host"`
sudo sed -i -e 's/dbname/'$dbname'/g' /var/www/mediawiki/LocalSettings.php
sudo sed -i -e 's/dbserver/'$dbhost'/g' /var/www/mediawiki/LocalSettings.php
sudo sed -i -e 's/dbuser/'$dbuser'/g' /var/www/mediawiki/LocalSettings.php
sudo sed -i -e 's/dbpassword/'$dbpassword'/g' /var/www/mediawiki/LocalSettings.php
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl restart httpd