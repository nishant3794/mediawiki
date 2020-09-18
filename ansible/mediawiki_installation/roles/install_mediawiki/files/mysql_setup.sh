#/bin/bash
secret=`aws secretsmanager  get-secret-value --region ap-south-1 --secret-id mysql-credentials --query "SecretString" --output text | jq -r ".rds_password"`
echo "[client]" >> .my.cnf
echo "user=root" >> .my.cnf
echo "password=$secret" >> .my.cnf
mysqladmin -u root password "$secret"
mysql -u root -p"$secret" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$secret" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$secret" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$secret" -e "FLUSH PRIVILEGES"