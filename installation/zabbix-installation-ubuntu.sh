# for libssl ubuntu 22.04 issue
echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list
apt update 
apt-get install libssl1.1

#!/bin/bash
cd /opt/
wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
apt update && apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

# Creating MYSQL Database for Zabbix + Give it Desired Permission  
mysql << EOF  
create database zabbix character set utf8 collate utf8_bin;
create user zabbix@localhost identified by 'PackopsZBX2022';
grant all privileges on zabbix.* to zabbix@localhost;
flush privileges;
EOF

### Enable This option for Importing Schema
vim /etc/mysql/mysql.conf.d/mysqld.cnf
log_bin_trust_function_creators = 1

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix 

 echo "DBPassword=PackopsZBX2022" >> /etc/zabbix/zabbix_server.conf 


cp /etc/zabbix/nginx.conf /etc/nginx/sites-enabled/zabbix.conf
#
## Uncomment and Change Server name to your Desired Domain-name + Uncomment Port number 80 
#

systemctl restart zabbix-server zabbix-agent nginx php7.4-fpm
systemctl enable zabbix-server zabbix-agent nginx php7.4-fpm 
