#/bin/bash
# author: fyl

#文件说明:为kong网关注册服务和路由，并添加jwt(鉴权)、cors(跨域支持)、grpc_web访问插件，根据自己需求进行修改

#使用方法 ./kong_init 本机IP kong的KONG_ADMIN_LISTEN端口号(8510)
#示例：./kong_init 192.168.10.152 8510

#返回201 表示创建成功
#使用时，ServiceMap的Key需要设置成proto包名，以便自动配置路由  -->  paths="/"$key -->paths=/hello
echo "脚本名: $0";

echo "IP: $1";
echo "Port:" $2;
declare -A ServiceMap
ServiceMap["hello"]=8503

for key in ${!ServiceMap[*]};do
    #添加服务
    curl -i -X POST http://$1:$2/services/ \
            --data name=$key \
            --data protocol="grpc" \
            --data host=$1 \
            --data port=${ServiceMap[$key]}

    #为服务添加cros和jwt插件
    curl -i -X POST http://$1:$2/services/$key/plugins \
            --data name=cors
    curl -i -X POST http://$1:$2/services/$key/plugins \
            --data name=jwt #--data "config.claims_to_verify=exp"

    #服务添加路由
    curl -i -X POST http://$1:$2/services/$key/routes \
            --data name=$key \
            --data protocols="grpc" \
            --data-urlencode paths="/"$key \
            --data path_handling=v1
    curl -i -X POST http://$1:$2/services/$key/routes \
            --data name=$key"_web" \
            --data hosts[]=$1":8509" \
            --data-urlencode paths="/"$key \
            --data protocols[]="http" \
            --data protocols[]="https" \
            --data path_handling=v1
            
    # #_web路由添加grpc_web插件
    curl -i -X POST http://$1:$2/routes/$key"_web"/plugins \
            --data name=grpc-web \
            --data config.proto="/proto/"$key"/"$key".proto"
done