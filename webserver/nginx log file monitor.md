```
Usermod –a –G adm zabbix
chown www-data:adm /var/log/nginx/access.log
service zabbix-agent2 restart

#Test access.log Persmission for user Zabbix
sudo -H -u zabbix bash -c 'tail -f /var/log/nginx/access.log'
```

# Lets Write a Regex for this Example Nginx Log
```
192.168.4.63 - - [22/Apr/2022:20:52:45 +0000] "POST /jsrpc.php?output=json-rpc HTTP/1.1" 200 73 "http://zabbix.packops.local/zabbix.php?action=dashboard.view" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0"
```

```
^(\S+) (\S+) (\S+) \[([\w:\/]+\s[+\-]\d{4})\] \"(\S+)\s?(\S+)?\s?(\S+)?\" (\d{3}|-) (\d+|-)\s?\"?([^\"]*)\"?\s?\"?([^\"]*)\"
```

# Zabbix Server  Config:
1. Create an item Type **Zabbix Agent (Active)** 
2. key would be like 
```
log[/var/log/nginx/access.log,"^(\S+) (\S+) (\S+) \[([\w:\/]+\s[+\-]\d{4})\] \"(\S+)\s?(\S+)?\s?(\S+)?\" (\d{3}|-) (\d+|-)\s?\"?([^\"]*)\"?\s?\"?([^\"]*)\"",,,skip,\8,,,]
```

## /8  ===> Means 8 section of Nginx Log which is Response code 
