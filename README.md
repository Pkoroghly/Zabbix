![ alt text ](https://img.shields.io/badge/Linkedln-PashaKoroghli-0A66C2?style=&logo=Linkedln)
![ alt text ](https://img.shields.io/badge/copyright-MIT-67C52A?style=&logo=)
![ alt text ](https://img.shields.io/badge/Zabbix-6.4.5-DA1F26?style=&logo=)
![ alt text ](https://img.shields.io/badge/Ubuntu-22.04.2-E95420?style=&logo=ubuntu)

# Zabbix
Within this repository, one can discover an abundance of essential commands, valuable tips, and practical scripts relevant to the Zabbix monitoring domain.


**Name**  
The installation process of Zabbix  
  


## **Description**

#Zabbix is a tool used for monitoring IT infrastructure like networks, servers, virtual machines, and cloud services. It is open-source software that collects and displays basic metrics. For more definitions, check out @zabbix or Wikipedia. Zabbix can be installed through multiple methods, but this tutorial will focus on the installation method using Zabbix.

  
**Installation**  

## Zabbix Installation

> To begin, we need to obtain the Zabbix repository and perform updates
> on all files.

apt update

    wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb

    dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb

    apt update
    

> For the second step, we'll require some tools.

    apt install gcc libssh2-1-dev golang make odbc-mariadb unixodbc unixodbc-dev odbcinst mariadb-server zabbix-agent2 libxml2-dev pkg-config libsnmp-dev snmp  libopenipmi-dev libevent-dev  libcurl4-openssl-dev libpcre3-dev build-essential libmariadb-dev sudo libxml2-dev snmp libsnmp-dev libcurl4-openssl-dev php-gd php-xml php-bcmath php-mbstring vim libevent-dev libpcre3-dev libxml2-dev libmariadb-dev libopenipmi-dev pkg-config php-ldap -y

	Determine your directory.
    cd /opt
    

> Set The environment variable for Golang.

    export PATH=$PATH:/usr/local/go/bin
    

> To complete the task, download Zabbix.tar.gz and proceed to extract it
> in the current directory..

    wget https://cdn.zabbix.com/zabbix/sources/stable/6.4/zabbix-6.4.5.tar.gz
.
     tar -zxvf zabbix-6.4.5.tar.gz
cd zabbix-6.4.5
> We require a user specifically for Zabbix.

***Please note:* 
*This user cannot be used to log into Linux and does not have a user directory. It is solely to use Zabbix.***

    cd zabbix-6.4.5/
    addgroup --system --quiet zabbix 
    adduser --quiet --system --disabled-login --ingroup zabbix --home /var/lib/zabbix --no-create-home zabbix
    mkdir -m u=rwx,g=rwx,o= -p /var/lib/zabbix
    chown -R zabbix:zabbix /var/lib/zabbix
    

> It is now time to set up the configuration for Zabbix.

***Please note: 
that it is essential to configure the settings correctly. An error may occur if there are any issues in the previous level.***

    cd zabbix-6.4.5/
    
     ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-unixodbc --with-net-snmp --with-libcurl --with-libxml2 --with-openipmi  --enable-agent2 --with-ssh2  --enable-webservice
     

> At this stage, you can proceed with installing Zabbix. However, this
> installation does not include a user-friendly front end for end-users.

    make install
    apt update 
    which zabbix_get
	
> During this stage, we will be installing the database, Zabbix front
> end, Nginx, and necessary scripts.

 

      apt install  zabbix-frontend-php mariadb-server zabbix-nginx-conf zabbix-sql-scripts nginx -y
      

> check your nginx service

    systemctl status nginx 
    

> To ensure proper functionality, it is important to execute the syntax
> within the Zabbix directory. (*In this case, everything happens in
> root@sysadmin:/opt/zabbix-6.4.4#*)

    cp  conf/zabbix_server.conf  /etc/zabbix/
    cp /etc/zabbix/nginx.conf /etc/nginx/sites-enabled/zabbix.conf
    chown -R zabbix:zabbix  /etc/zabbix/
    

> Our Nginx site default is currently set to serve root /var/html from
> /etc/nginx/sites-enabled/Zabbix.conf. However, it is necessary to
> delete this configuration as it is causing difficulty in reading.

    rm -rf    /etc/nginx/sites-enabled/default
    

> To modify the Zabbix configuration file, we need to use the nano
> editor. Once inside the file, **we should update the listen port to 80
> from 8080**. Additionally, if we have the server name, we can include
> it in the designated area.

    nano /etc/nginx/sites-enabled/zabbix.conf
    systemctl restart nginx

## Zabbix db Installation

> Log in to the database.

    mysql
    

> In this process, we will generate a Zabbix database along with a
> username and password. Simply copy and paste the given scripts into
> MySQL and modify the password as per your preference.

    mysql << EOF  
    create database zabbix character set utf8mb4 collate utf8mb4_bin;
    create user zabbix@localhost identified by 'PackopsZBX2022';
    grant all privileges on zabbix.* to zabbix@localhost;
    flush privileges;
    SET GLOBAL log_bin_trust_function_creators = 1;
    EOF

> We will open the schema and then pass it to the database.

    zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix 
     

> To confirm the process, begin by accessing the database, proceed to
> make the necessary changes, and finally, verify the names of the
> databases.

    mysql
    user zabbix;
    show tables;
    

> Zabbix server must concat to database.

 

       nano /etc/zabbix/zabbix_server.conf
    			    DBHost=localhost (*If you have clustered your database, you can display the database IP address here.*)
    			    DBName=zabbix
    			    DBUser=zabbix
    				DBPassword=PackopsZBX2022!
				

> make a service to use systemctl to start, stop etc ...

    echo -n "[Unit]
    Description=Zabbix Server
    After=syslog.target network.target mysql.service

    [Service]
    Type=simple
    User=zabbix
    ExecStart=/usr/local/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf
    ExecReload=/usr/local/sbin/zabbix_server -R config_cache_reload
    RemainAfterExit=yes
    PIDFile=/tmp/zabbix_server.pid
    
    [Install]
    WantedBy=multi-user.target" > /etc/systemd/system/zabbix-server.service




    systemctl daemon-reload
    systemctl enable  zabbix-server --now 
    systemctl enable  nginx --now 
    systemctl enable  zabbix-agent2 --now 

## Usage

Zabbix is a software used to monitor the health and dependability of networks and servers. It has a notification system that allows users to receive email notifications for different types of events. This helps address any server problems quickly.
  
  

## Roadmap

To make Zabbix work properly, do the following steps in order:
1.  Set up the required repository.
2.  Install Zabbix.
3.  Create a database.
4.  Connect the database to Zabbix.
5.  Set up a service.
  
## Authors and acknowledgment  
I sincerely thank the Packops group and Mr Farshad Nickfetrat for authoring this highly informative article.
  
## License  
MIT License

Copyright (c) 2023 Pasha koroghli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
  












