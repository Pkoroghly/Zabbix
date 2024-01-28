```
ZB Server : 192.168.4.151
Clinet : 192.168.4.50
```

* Zabbix Server 

** 1- Make an Zabbix Trapper Item
*** Give the key  your desired name 
like : 
key : Sender 

** Client
```
echo "deb http://security.ubuntu.com/ubuntu impish-security main" | sudo tee /etc/apt/sources.list.d/impish-security.list
sudo apt-get update
sudo apt-get install libssl1.1
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_6.0-1+ubuntu20.04_all.deb
```

```
zabbix_sender -z 192.168.4.151 -p 10051 -s 'zbx' -k sender -o 1
```
. -z : Zabbix server host (IP address can be used as well)
. -s : technical name of monitored host (as registered in  Zabbix frontend)
. -k : item key
. -o : value to send
