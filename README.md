# A lightweight DNS service for docker hosts

DNS service auto updating with host container names resolved as A records
Listens to host Dockers event stream and parses IP address allocation automatically

Can be used to give all containers name resolution of other containers without external dependencies

### Usage
```sh
docker run -d --name dns -p 53:53/udp -v /var/run/docker.sock:/var/run/docker.sock omriiluz/docker-dns
```
### Example

```sh
$ docker run -d --name dns -p 53:53/udp -v /var/run/docker.sock:/var/run/docker.sock omriiluz/docker-dns
8abca078d92d8d456eefa56541dd05032f1e59e43b122af56ca38759e2b4dae7
$ docker run -d --name mongodb mongo:3.0
cc8410f15878f05efb1619cfc043e1806b812307bb633652a059a4ebfeef58c1
$ dig +short mongodb @localhost                                                                                                                                                   10.0.10.35
```

### TODO
- Move to an ETCD backend so data can be shared across hosts
- Integrate curl 7.40 (with unix domais feature) and remove socat proxy
