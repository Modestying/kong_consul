# kong+consul 部署使用

文章内容均为示例，请各位根据自己情况进行适配

1. `kong_init.sh` 用于添加路由，在linux可直接使用，mac自带bash为 `3.x`,请自行搜索解决方案
2. `.env`里 `IP`根据自己实际ip进行配置
3. 通过域名访问服务，需要将dns设置为 `consul`的ip地址，通过 `docker inspect consul_server`进行查询，在启动需要访问其他服务的容器时，添加dns配置
```shell
            "Networks": {
                "kong_consul_local": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "consul_server",
                        "consul_server",
                        "0054af028eb8"
                    ],
                    "NetworkID": "a372688da6a44c7dd60eac29c578baf623241483135d18bc66af44cf88a426e9",
                    "EndpointID": "196ad4346195a7864db7a66bbbaf9ed6a62a9264b5565ca45ceeb6f22b2f6f13",
                    "Gateway": "172.24.0.1",
                    "IPAddress": "172.24.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:18:00:03",
                    "DriverOpts": null
                }
            }
        }
```
```shell
docker run --dns=172.24.0.3 image:tag
```
4. 连接服务端示例代码

```golang
func ConnectServer() v1.GreeterClient {
	// 直接访问 ./client localhost:9000
	// 网关访问 ./client localhost:8509
	// dns访问 ./client dns:///hello.service.consul:9000
	conn, err := grpc.Dial(TEST_SERVER, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		panic(err)
	}
	return v1.NewGreeterClient(conn)
}
```

5. 有问题提issue，尽量帮忙解决
6. 个人主页：[https://www.cnblogs.com/erfeng/](https://www.cnblogs.com/erfeng/)
7. 示例服务`hello`地址: `https://github.com/Modestying/kratos_demo`