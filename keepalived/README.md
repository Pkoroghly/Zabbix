
# Maximizing website availability using Zabbix for Nginx and Keepalived with simple health checks.

## Overview

Nginx and Keepalived collaborate to keep a web server running and handle high traffic. One server is primary, and the other is a backup in case of failure. Zabbix sender monitors the servers and alerts admins of issues, ensuring the blog runs smoothly.
![6 4_ Zabbix_100_Sci E_2 1 5_Keepalived_2023 11 08 drawio](https://github.com/pasha-k87/Zabbix/assets/79890366/7ec72e06-8b7b-487e-b246-73ed6e77a06f)

# Description

Nginx and Keepalived are two software tools that ensure a service's high availability and scalability. Nginx is a web server that can handle a large number of concurrent connections and requests. It is known for its low resource usage and high performance. Keepalived, on the other hand, is a tool that provides high availability by configuring multiple servers to work together in a failover scenario. 

To set up high availability for a service, Nginx is installed on two servers: one is designated as the primary server, while the other is the backup server. The two servers are configured to work together using Keepalived. Keepalived monitors the primary server; if it fails, it automatically switches traffic to the backup server. This ensures the service remains available even if one of the servers goes down.

Zabbix sender is a monitoring system that checks the health of both servers. It sends alerts to administrators if there are any issues, allowing them to quickly identify and resolve any problems. This proactive monitoring ensures that any potential issues are detected and resolved before they affect the availability of the blog.

Overall, the combination of Nginx, Keepalived, and Zabbix sender provides a reliable and scalable service hosting solution. This setup can handle large numbers of visitors by ensuring high availability and monitoring server health while maintaining optimal performance.

## Getting start

To run this scenario, we divide it into phase one configuration on the Linux server-side and Phase two set-up of needed components on the Zabbix side. 

## Dependencies

Three Ubuntu Linux 22.04.3 services were installed in a virtual environment, such as a virtual box. These servers now require updates, and Zabbix 6.4 must be installed on one of them.

### Phase one

 1. After updating both servers, it is necessary to configure Keepalived
    in the Master and Backup servers. The configuration can be found in
    the installation section at the bottom.
    
 2. It is important to create a healthcheck script for both servers. Insert, Additionally, you can utilize the healthcheck script available in the installation section.

> The Keepalived needs to access the healthcare script. This line can
> help give access o keepalived access, but it is not routine.

    chm 777 -R /opt/healthcheck.sh 

> In a standard or logical manner, you should sh owen keepalive.

 3. Finally, install Nginx on both servers.
 4. To check if Nginx is available on a browser, try accessing both range IP addresses on Port 80.
 5. Now to start or restart keepalived service on both servers.
 6. After restarting, check keepalived status. `serive keeplived status`
 7. As mentioned earlier, Zabbix needs to be installed on the third server. You can find instructions on the official Zabbix website https://www.zabbix.com/download. Different paths are available for installation, including Docker, Zabbix, or Zabbix source. It does not matter which one you choose. In addition, you can check [README.md](https://github.com/pasha-k87/Zabbix/commit/55574f710a843c06ccd2fffefa47f1221ea77521) on my GitHub repository. I've provided Instructions to install the Zabbix source.
 8. Install Zabbix sender LTS from the official repository. Additionally, you may install a Zabbix agent, but for this use case, the Zabbix sender is sufficient.  `wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb` | `apt install zabbix-sender`

 
### Phase two
 9. Now on Zabbix have to create an item for keepalived.
>  Data collection>Host>items>Creat item
10. Set: name (optional character), Type (Zabbix trapper) , Key(optional character), Type of information (Numeric (unsigned)), Update interval (optional character),
11. Set Zabbix sender on servers: `zabbix_sender -z 192.168.31.70 zabbix-server -s "zbx" -k mck-o 1000` 
> Set IP servers to the previous config with MASTER at 192.168.31.70
> using the key (Zabbix component) name 'mck'.
12. It's time to add the result to the health check script and send it to the monitoring service.
13. check the response: `cat /var/log/syslog`
14.  `Nano /opt/healthcheck.sh`
15. in the healthcheck.sh after ok condition copy `zabbix_sender -z 192.168.31.70 zabbix-server -s "zbx" -k mck -o 0` | and after not oK `zabbix_sender -z 192.168.31.70 zabbix-server -s "zbx" -k mck -o 1`.
16. create another key for Backup Server same as MASTER Server on Zabbix. You can take a clone just than just change the name.

# Installing

## Keepalived Config MASTER Server (Priority 101)

    vim /etc/keepalived/keepalived.conf

```
    vrrp_script chk_http_port {
        script "/opt/healthcheck.sh"
        interval 5   # Check every 5 seconds
        fall 2       # Number of consecutive failures before considering the server as down
        rise 2       # Number of consecutive successes before considering the server as up
    }
    
    
    vrrp_instance VI_1 {
        state MASTER
        interface ens160
        virtual_router_id 51
        priority 101
        advert_int 1
        authentication {
            auth_type Squad$Ops2023@ #Feel free to personalize your password to your preference.
            auth_pass mypassword
        }
        virtual_ipaddress {
            192.168.31.70 #To customize your IP, simply input the IP address within your network range.
        }
        track_script {
            chk_http_port
        }
    }

```


## Keepalived Backup Server (Prority 99)

> vim /etc/keepalived/keepalived.conf

```
vrrp_script chk_http_port {
    script "/opt/healthcheck.sh"
    interval 5   # Check every 5 seconds
    fall 2       # Number of consecutive failures before considering the server as down
    rise 2       # Number of consecutive successes before considering the server as up
}

vrrp_instance VI_1 {
    state BACKUP
    interface ens160
    virtual_router_id 51
    priority 99
    advert_int 1
    authentication {
        auth_type Squad$Ops2023@ #Feel free to personalize your password to your preference.
        auth_pass mypassword
    }
    virtual_ipaddress {
        192.168.31.13 #To customize your IP, simply input the IP address within your network range.
    }
    track_script {
        chk_http_port
    }
}
```
## healtcheck.sh

> Path 
> /opt/healthcheck.sh

    #!/bin/bash
        
        # Define the URL to check
        URL="http://localhost/"
        
        # Make an HTTP GET request and store the response
        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
        
        # Check the HTTP response code
        if [ "$RESPONSE" == "200" ]; then
            # Server is healthy
            logger "its ok"
            exit 0
        else
            # Server is unhealthy
            logger "DOWN"
            exit 1
        fi
        

## Executing program
Now you can check your monitoring pipeline, by logging Zabbix Monitoring>Latest data> search your Name Item. You can test it just stop Nginx service on MASTER server.

``


## **Authors**

Pasha Koroghly
Email: p.koroghly@gmail.com
linkedin: https://www.linkedin.com/in/pasha-koroghli

## **Version History**

* Initial Release:	6.4- Zabbix-100-Sci.E-2.1.5-Keepalived-2023.11.08

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

###  Keepalived

Loadbalancing framework relies on well-known and widely used Linux Virtual Server (IPVS) kernel module providing Layer4 loadbalancing. [Keepalived](https://www.keepalived.org/) implements a set of checkers to dynamically and adaptively maintain and manage loadbalanced server pool according their health.  On the other hand high availability is achieved by VRRP protocol. VRRP is a fundamental brick for router failover. In addition, Keepalived implements a set of hooks to the VRRP finite state machine providing low-level and high-speed protocol interactions.

### Zabbix

[Zabbix](https://www.zabbix.com/documentation/current/en/manual/definitions) is a fantastic open-source tool that expertly monitors your IT infrastructure, including networks, servers, virtual machines, and cloud services. It collects and displays basic metrics with ease and accuracy.**

### Fluentd

[Fluentd](https://docs.fluentd.org/) is a cross-platform open-source data collection software project originally developed at Treasure Data. It is written primarily in the Ruby programming language.

### Elasticsearch

[Elasticsearch](https://en.wikipedia.org/wiki/Elasticsearch) is a search engine based on the Lucene library. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents.

### Kibana

[Kibana](https://en.wikipedia.org/wiki/Kibana) is a source-available data visualization dashboard software for Elasticsearch, whose free and open source fork in OpenSearch is OpenSearch Dashboards.

### Stateless

A [stateless](https://en.wikipedia.org/wiki/Stateless_protocol) protocol is a communication protocol in which the receiver must not retain session state from previous requests.

### The Virtual Router Redundancy Protocol (VRRP)

The Virtual Router Redundancy Protocol ([VRRP](https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol)) is a computer networking protocol that provides for automatic assignment of available Internet Protocol routers to participating hosts. This increases the availability and reliability of routing paths via automatic default gateway selections on an IP subnetwork.

### Failover

[Failover](https://en.wikipedia.org/wiki/Failover) is switching to a redundant or standby computer server, system, hardware component or network upon the failure or abnormal termination of the previously active application, server, system, hardware component, or network in a computer network.

### Virtual IP address

A [virtual IP address](https://en.wikipedia.org/wiki/Virtual_IP_address) is an IP address that does not correspond to a physical network interface. Uses for VIPs include network address translation, fault-tolerance, and mobility.

### Barman 
[Barman](https://docs.pgbarman.org/release/3.7.0/) is a tool used for PostgreSQL server disaster recovery management. It is open-source and written in Python. This tool helps organizations to remotely back up multiple servers in business-critical environments to reduce risk and aid DBAs during recovery.

## References

 - https://packops.ir/
 - https://www.zabbix.com/documentation/current/en/manual/definitions
 - https://ubuntu.com/server/docs
 - http://nginx.org/en/docs/
 - https://www.keepalived.org/
