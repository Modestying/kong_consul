# konga安装部署

## 启动容器

这里用户可以改为kong

```shell
    docker run -d --name postgres \
        -p 5432:5432 \
        -e "POSTGRES_USER=postgres" \
        -e "POSTGRES_PASSWORD=postgres" \
        -e "POSTGRES_DB=postgres" \
        192.168.10.212:8089/smart_platform_v1.0 \
        postgres:v0.1
```

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
