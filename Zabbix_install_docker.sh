sudo apt-get install \ ca-certificates \ curl \ gnupg \ lsb-release
    
    sudo mkdir -p /etc/apt/keyrings
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
   sudo apt update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
apt install docker-compose -y

git clone https://github.com/zabbix/zabbix-docker.git
cd zabbix-docker
mv docker-compose_v3_ubuntu_mysql_latest.yaml docker-compose.yml
docker-compose up -d
