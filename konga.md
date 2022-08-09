# konga安装部署

## 修改用户

```shell
    docker exec -it containerID /bin/bash
    # 切换用户
    su postgres
    # 进入命令
    psql;
    # 创建用户kong及密码
    # 创建数据库kong

    create user kong with password 'kong';
    create user konga with password 'konga';

    create database kong owner kong;
    create database konga owner konga;

    退出使用 \q
```
konga需要数据库`konga`，可以参考上面命令进入docker镜像创建`konga`库，或通过第三方工具如(navicat)连接postgresql，创建`konga`数据库
```shell
docker run -d --network=host \
--name konga \
-e "DB_ADAPTER=postgres" \
-e "DB_HOST=192.168.10.96" \
-e "DB_PORT=5432" \
-e "DB_USER=kong" \
-e "DB_PASSWORD=kong" \
-e "DB_DATABASE=konga" \
konga:latest
```
