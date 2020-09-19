#!/bin/bash
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
