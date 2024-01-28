# Nginx Side
```
location = /basic_status {
    stub_status;
    allow 127.0.0.1;
    allow ::1;
    deny all;
}
```
# Zabbix Side 
 ## Templates: 
- Nginx by HTTP                    13 item
- Nginx by Zabbix agent     17 item 

![image](https://user-images.githubusercontent.com/88557305/177218645-3891e2db-a872-407a-a84a-43fcdc81e347.png)
