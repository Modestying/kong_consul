# kong 启动

><https://hub.docker.com/_/kong>

## 建议初学者启动不要加上-d，可以更直观的了解到服务启动情况

## 需要konga，则postgresql启动参考konga.md

```shell
不要用最新的postgres,存在问题
docker run -d \
--network=host \
--name kong-database \
-e "POSTGRES_USER=kong" \
-e "POSTGRES_DB=kong" \
-e "POSTGRES_PASSWORD=kong" \
postgres:9.6
```

## kong数据库连接

启动完成后，会自动Exit(0)，正常现象

```shell
docker run -d \
--network=host \
-e "KONG_DATABASE=postgres" \
-e "KONG_PG_HOST=192.168.10.96" \
-e "KONG_PG_USER=kong" \
-e "KONG_PG_PASSWORD=kong" \
-e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
kong:latest  kong migrations bootstrap
```

## 启动kong

端口根据实际情况进行修改

```shell
docker run -d --name kong \
--network=host \
-e "KONG_DATABASE=postgres" \
-e "KONG_PG_HOST=192.168.10.96" \
-e "KONG_PG_PASSWORD=kong" \
-e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
-e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
-e "KONG_ADMIN_LISTEN=0.0.0.0:8510" \
-e "KONG_PROXY_LISTEN=0.0.0.0:8508 http2,0.0.0.0:8509" \
-e "KONG_DNS_RESOLVER=192.168.10.153:8600"  \
kong:latest
```
