# kong+consul 部署使用

文章内容均为示例，请各位根据自己情况进行适配


1. `kong_init.sh` 用于添加路由，在linux可直接使用，mac自带bash为`3.x`,请自行搜索解决方案
2. `.env`里`IP`根据自己实际ip进行配置
3. 通过域名访问服务，需要将dns设置为`consul`的ip地址，通过`docker inspect consul_server`进行查询
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
4. 有问题提issue，尽量帮忙解决
5. 个人主页：[https://www.cnblogs.com/erfeng/](https://www.cnblogs.com/erfeng/)