Before creating the media type, you will need to


1. Create a Bot using the official @BotFather tool
 ![image](https://user-images.githubusercontent.com/88557305/177824558-95563a30-2c12-4d59-939b-864d1338c175.png)
2. Copy it's HTTP API Token,
3. Find your new Bot using the search option and then start it.
4. Create a Group,
5. Add your new bot to the group.
6. Retrieve the Chat ID from the chat data using the getUpdates api call with the bots HTTP API Token.



Get your ID from  @myidbot
![image](https://user-images.githubusercontent.com/88557305/177823168-b030117d-0cec-401c-b7b2-33e774325414.png)





## Set Proxy for Zabbix Server 

vim /etc/systemd/system/zabbix-server.service

```
[Unit]
Description=Zabbix Server
After=syslog.target network.target mysql.service

[Service]
Type=simple
User=zabbix
Environment="HTTP_PROXY=http://kube:xxaaaSDG2us347bsd@185.202.113.167:7777"
Environment="HTTPS_PROXY=http://kube:xxaaaSDG2us347bsd@185.202.113.167:7777"
Environment="NO_PROXY=192.168.4.0/24,127.0.0.1"


ExecStart=/usr/local/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf
ExecReload=/usr/local/sbin/zabbix_server -R config_cache_reload
RemainAfterExit=yes
PIDFile=/tmp/zabbix_server.pid

[Install]
WantedBy=multi-user.target
```
## GO To Administration => media => Telegram 
![image](https://user-images.githubusercontent.com/88557305/177822654-384f6460-e878-4b18-9007-1104bf4832a9.png)
