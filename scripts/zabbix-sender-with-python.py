from zappix.sender import Sender
from zappix.get import Get
ZBX_IP="192.168.100.1"
def zabbix_sender(KEY, VALUE):
   sender = Sender(ZBX_IP)
   sender.send_value('YOUR_HOST', KEY, VALUE)

zabbix_sender('YOUR_KEY', 88)
