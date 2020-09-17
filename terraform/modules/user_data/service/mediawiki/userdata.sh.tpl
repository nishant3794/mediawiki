#!/bin/bash
sudo rm -rf /var/www/*
sudo aws s3 cp mediawiki-deployment-zip/mediawiki.tar /var/www/mediawiki.tar
sudo tar -xvzf /var/www/mediawiki.tar
sudo chown -R apache:apache /var/www/mediawiki
sudo systemctl restart httpd