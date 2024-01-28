**How we can monitor Mysql :**

1.Template DB MySQL 
1.Template  ODBC
1.Template  Mysql by zabbix agent2
1.Userparameter

# Make Mysql user and password 

```
CREATE USER 'zbx_monitor'@'%' IDENTIFIED BY '1234';
GRANT REPLICATION CLIENT,PROCESS,SHOW DATABASES,SHOW VIEW ON *.* TO 'zbx_monitor'@'%';
flush privileges;
```

# Template Mysql by zabbix agent and DB mysql's Macro for mysql
```
{$MYSQL.DSN} --> tcp://192.168.4.151
{$MYSQL.PASSWORD}  ---->  1234
{$MYSQL.USER}  ----> zbx_monitor
```

