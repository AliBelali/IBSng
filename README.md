# IBSng Radius Server Docker
IBSng 1.24 Web-Based Accounting based CentOS 6 Docker

Attention #1:

This free version of IBSng hasn’t been updated or debugged for a very long time. It contains bugs and is not compatible with newer versions of CentOS, PHP, Python, and PostgreSQL. As a result, it may have vulnerabilities. Please exercise caution when using it, and be aware that there is absolutely NO WARANTY.

Attention #2:

The developer and any person involved in the chain of access to this program do not assume any responsibility for the consequences of its use. Users are solely responsible for any outcomes resulting from their use of this program.

IBSng Accounting A1.24 Docker :

IBSng A1.24 is a free beta version of IBSng LAN Accounting. It's a radius server. A RADIUS server is a central server that provides authentication and authorization services for remote users who access a network. It receives authentication requests from RADIUS clients, such as routers, firewalls, or VPNs, verifies the credentials of the user, and returns an authorization decision to the client.

Limits of This Version:
- It's not Updated For a Long Time.
- Traffic analayzer not working.(Probably also Graphs doesn't work)
- Bandwidth Limits Not Working.
- It needs SNMP access to radius client for traffic usage calculation.
- It needs ssh access to radius client for disconnecting finished users.
- It needs interim updates be enabled in radius client for syncing online users.

Installation:
1. Install Docker:
```
bash <(curl -sSL https://get.docker.com)
```
2. Clone the Project Repository:

```
git clone https://github.com/AliBelali/IBSng.git
cd IBSng/
```
3. Build Docker Image
```
docker build -t alibelali/ibsng ./
```
4. Start Services
```
docker run -d -p 80:80 --name IBSng alibelali/ibsng
```

web UI: http://Your-IP/IBSng/admin 

user : system 

pass: admin

You can mount postgresql database from your host:

Copy content of postgresql from container to host :

    docker cp IBSng:/var/lib/pgsql /<your path>/pgsql
    
stop and remove ibsng container: 

    docker rm ibsng -f
start container again with -v option as follow: 

    docker run -d -p 80:80 --name IBSng -v /<your pgsql on host path>/pgsql:/varlib/pgsql alibelali/ibsng 
