mysqldump zabbix > zabbix.sql
JOBDONE=$(echo $?)
if [ "$JOBDONE" -ne 0 ]; then
  zabbix_sender -z 192.168.4.11 -s "zbx" -k sender -o 1
else
  zabbix_sender -z 192.168.4.11 -s "zbx" -k sender -o 0
fi
