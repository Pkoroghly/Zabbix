```
# add repo for openssl dependency issue 
echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list
apt update 
apt-get install libssl1.1

wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.
apt update 
apt-get install zabbix-proxy-mysql zabbix-sql-scripts  

# Install MariaDB
sudo apt -y install mariadb-common mariadb-server mariadb-client
systemctl start mariadb
sudo systemctl enable mariadb


mysql << EOF  
create database zabbixproxy character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'PackopsZBX2022';
grant all privileges on zabbixproxy.* to zabbix@localhost;
EOF

 
# OLD PATH zcat /usr/share/zabbix-proxy-mysql/schema.sql.gz | mysql -u zabbix zabbix -p
cat /usr/share/zabbix-sql-scripts/mysql/proxy.sql | mysql -u zabbix zabbixproxy -p

vim /etc/zabbix/zabbix_proxy.conf

DBHost=localhost
DBName=zabbixproxy
DBUser=zabbix
DBPassword=PackopsZBX2022
Server=10.7.44.235 (IP ADDRESS OF ZABBIX SERVER)
Hostname=Zabbix-proxy-1

service zabbix-proxy start
```
