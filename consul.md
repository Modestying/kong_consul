# Consul 安装

><https://cloud.tencent.com/developer/article/1444664>
>
><https://www.cnblogs.com/summerday152/p/14013439.html>
>
><https://blog.csdn.net/hong10086/article/details/89440284#:~:text=ConsulAgent%20%E6%98%AF%20Consul%20%E7%9A%84%E6%A0%B8%E5%BF%83%E8%BF%9B%E7%A8%8B%EF%BC%8C%20Agent%20%E7%9A%84%E5%B7%A5%E4%BD%9C%E6%98%AF%E7%BB%B4%E6%8A%A4%E6%88%90%E5%91%98%E5%85%B3%E7%B3%BB%E4%BF%A1%E6%81%AF%E3%80%81%E6%B3%A8%E5%86%8C%E6%9C%8D%E5%8A%A1%E3%80%81%E5%81%A5%E5%BA%B7%E6%A3%80%E6%9F%A5%E3%80%81%E5%93%8D%E5%BA%94%E6%9F%A5%E8%AF%A2%E7%AD%89%E7%AD%89%E3%80%82%20Consul,%E9%9B%86%E7%BE%A4%E7%9A%84%E6%AF%8F%E4%B8%80%E4%B8%AA%E8%8A%82%E7%82%B9%E9%83%BD%E5%BF%85%E9%A1%BB%E8%BF%90%E8%A1%8C%20agent%20%E8%BF%9B%E7%A8%8B%E3%80%82%20%E5%8F%82%E4%B8%8E%E8%AF%84%E8%AE%BA%20%E6%82%A8%E8%BF%98%E6%9C%AA%E7%99%BB%E5%BD%95%EF%BC%8C%E8%AF%B7%E5%85%88%20%E7%99%BB%E5%BD%95%20%E5%90%8E%E5%8F%91%E8%A1%A8%E6%88%96%E6%9F%A5%E7%9C%8B%E8%AF%84%E8%AE%BA>
>
>consul 镜像站点<https://hub.docker.com/_/consul/>
>
>consul agent文档<https://www.consul.io/docs/agent>
>
>kong API文档 <https://docs.konghq.com/gateway/2.8.x/admin-api/>

## Consul启动配置项

* agent: 表示启动 Agent 进程。

* server：表示启动 Consul Server 模式

* client：表示启动 Consul Cilent 模式。

* bootstrap：表示这个节点是 Server-Leader ，每个数据中心只能运行一台服务器。技术角度上讲 Leader 是通过 Raft 算法选举的，但是集群第一次启动时需要一个引导 Leader，在引导群集后，建议不要使用此标志。

* ui：表示启动 Web UI 管理器，默认开放端口 8500，所以上面使用 Docker 命令把 8500 端口对外开放,或直接以`host`模式启动。

* node：节点的名称，集群中必须是唯一的，默认是该节点的主机名。

* client：consul服务侦听地址，这个地址提供HTTP、DNS、RPC等服务，默认是127.0.0.1所以不对外提供服务，如果你要对外提供服务改成0.0.0.0

* join：表示加入到某一个集群中去。 如：-json=192.168.0.11
  
* CONSUL_BIND_INTERFACE：网卡，根据自己实际情况
  
## 启动命令

```shell
docker-compose --env-file=.env up #docker-compose.yml启动
```

### server

192.168.10.174

```shell
docker run -d --name=consul_server \
--network=host \
-dev \
-e CONSUL_BIND_INTERFACE=ens33 \
consul agent \
--server=true \
--bootstrap-expect=1 \
-node=leader --client=0.0.0.0 \
-ui
```

### client

```shell
docker run --rm --name=consul_client \
--network=host \
 -e CONSUL_BIND_INTERFACE=enp5s0f0 \
 consul agent \
 --server=false \
 --client=0.0.0.0 \
 --join 192.168.10.203 -ui \
 -node=client
```

### 注册服务

向同一个服务(Name)添加不同的`Address`和`port`,在实际访问时，会随机访问服务(Name)下的地址

```shell
curl --location --request PUT 'http://192.168.10.174:8500/v1/agent/service/register' \
--header 'Content-Type: application/json' \
--data-raw '{
  "ID": "DemoApi_ubu",
  "Name": "DemoApi31",
  "Address": "192.168.10.174",
  "Port": 55
}'
```

#### 监控检查

带健康检查注册,data-ra:

```shell
curl --location --request PUT 'http://192.168.10.174:8500/v1/agent/service/register' \
--header 'Content-Type: application/json' \
--data-raw '{
  "ID": "Demo_ubu",
  "Name": "Demo",
  "Address": "192.168.10.174",
  "Port": 55,
  "Check":{
    "CheckID": "Demo_ubu_check",
    "Name": "Demo check",
    "Notes": " test notes",
    "TCP": "192.168.10.174:50190",
    "Interval": "5s",
    "Timeout": "5s"
    }
}'

```

多个健康检查

```shell
curl --location --request PUT 'http://192.168.10.174:8500/v1/agent/service/register' \
--header 'Content-Type: application/json' \
--data-raw '{
  "ID": "Demo_ubu",
  "Name": "Demo",
  "Address": "192.168.10.174",
  "Port": 55,
  "Checks": [
        {
        "CheckID": "Demo_ub18_check",
        "Name": "demo check",
        "Notes": "grpc test notes",
        "TCP": "192.168.10.174:50190",
        "Interval": "5s",
        "Timeout": "5s"
        },
        {
        "CheckID": "Video_ub18_check_2",
        "Name": "video check 2" ,
        "Notes": "http test notes",
        "TCP": "192.168.10.174:50111",
        "Interval": "5s",
        "Timeout": "5s"
        }
    ]
}'
```


### 删除服务

```shell
curl --location --request PUT 'http://192.168.10.174:8500/v1/agent/service/deregister/DemoApi_ubu'
```

### 查询服务

```shell
dig @127.0.0.1 -p 8600 Demo.service.consul
#Demo是服务注册时的Name，可在WEB页面查看
```

### kong网关服务配置

配置方式有两种

* konga网页手动配置，比较简单，但繁琐，一旦重启kong依赖的数据库初始化，还需手动重新配置,不过可以通过konga的`snapshots`将当前配置导出
* Kong的API接口注册服务和路由，参考`kong_init.sh`文件

注意，配置`kong+consul`需要将服务的`Host`设为`Demo(服务名).service.consul`,而不是服务部署IP，端口无需设置

`XXXX.service.consul`是consul的格式要求
