
# Maximizing website availability using Zabbix for Nginx and Keepalived with simple health checks.

## Overview

Nginx and Keepalived collaborate to keep a web server running and handle high traffic. One server is primary, and the other is a backup in case of failure. Zabbix sender monitors the servers and alerts admins of issues, ensuring the blog runs smoothly.

# Description

Nginx and Keepalived are two software tools that ensure a service's high availability and scalability. Nginx is a web server that can handle a large number of concurrent connections and requests. It is known for its low resource usage and high performance. Keepalived, on the other hand, is a tool that provides high availability by configuring multiple servers to work together in a failover scenario. 

To set up high availability for a service, Nginx is installed on two servers: one is designated as the primary server, while the other is the backup server. The two servers are configured to work together using Keepalived. Keepalived monitors the primary server; if it fails, it automatically switches traffic to the backup server. This ensures the service remains available even if one of the servers goes down.

Zabbix sender is a monitoring system that checks the health of both servers. It sends alerts to administrators if there are any issues, allowing them to quickly identify and resolve any problems. This proactive monitoring ensures that any potential issues are detected and resolved before they affect the availability of the blog.

The combination of Nginx, Keepalived, and Zabbix sender provides a reliable and scalable service hosting solution. This setup can handle large numbers of visitors by ensuring high availability and monitoring server health while maintaining optimal performance.

## Getting start

## Dependencies

Three Ubuntu Linux 22.04.3 services, such as a virtual box, were installed in a virtual environment. These servers now require updates, and Zabbix 6.4 must be installed on one of them.

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

* How to run the program

* Step-by-step bullets

```

code blocks for commands

```

##  Help

Any advise for common problems or issues.

```

command to run if program contains helper info

```

## **Authors**

Contributors names and contact info

ex. Dominique Pizzie

ex. [@DomPizzie](https://twitter.com/dompizzie)

## **Version History**

* 0.2

* Various bug fixes and optimizations

* See [commit change]() or See [release history]()

* 0.1

* Initial Release

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
