import paramiko
import time
import smtplib
import sys 

host = sys.argv[1]
ssh=paramiko.SSHClient()ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())ssh.connect(host, username='geek', password=‘pass', port='2222', look_for_keys=False, allow_agent=False)
stdin,stdout,stderr = ssh.exec_command("log print")
test = stdout.read()
farshad = str(test)
print(test)
