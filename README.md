# dockerhub argoxpaasnginx:latest

## 增强

* `https://<PaaS云服务商分配的域名>/<UUID>.html` 展示了各种配置以及客户端二维码。
* `https://<PaaS云服务商分配的域名>/<UUID>.json` 为对应的v2ray客户端文件。
* 增加订阅模式，以防止每次Cloudflare分配的域名改变。可在V2rayA和安卓上的V2rayNG中添加订阅，地址为`https://<PaaS云服务商分配的域名>/<UUID>.txt`。每次发现之前的地址不可用之后先刷新下订阅再尝试连接，如果还不行过30秒刷一次再试，因为容器启动需要时间。
* `https://<PaaS云服务商分配的域名>/cf.txt` 为最新的Cloudflare分配域名。
* 增加Cloudflared多次重试，应对Cloudflare偶尔抽风。
* `https://<PaaS云服务商分配的域名>/<UUID>.rootfs/`可直接下载rootfs中的内容（可在nginx.conf中删除相关段以禁用）。
* 可同时使用域名直连与argo隧道
### Cloudflare固定隧道

使用固定隧道需要设置ARGO_AUTH（Token，一长串Base64编码字符，可在Cloudflare官网隧道的Overview页面里找到），并在Cloudflare官网上配置一个Tunnel的Public Hostname，其服务需要指向`127.0.0.1:8080`。
如果未设置ARGO_AUTH则不启用该特性。启用固定隧道并不会禁用trycloudflare.com的域名。
固定隧道的地址为类似`https://固定通道的域名/VMESS_WSPATH`，端口，UUID等其他设置与非固定隧道的配置一样。

public hostname指向80，则由nginx入站分流，若指向8888，则由xray入站回落，端口，UUID等设置一样。
增加8080，xget

## 部署

* 注册任意一家 PaaS 云服务商
* 根据 PaaS 云服务商的不同绑定自己的 GitHub 账户或使用项目提供的 Actions 生成 DockerHub 镜像，严重建议小号 + 私库
* 项目可用到的变量
  | 变量名 | 是否必须 | 默认值 | 备注 |
  | ------------ | ------ | ------ | ------ |
  | UUID         | 否 | de04add9-5c68-8bab-950c-08cd5320df18 | 可在线生成 https://www.uuidgenerator.net/ |
  | ARGO_AUTH    | 否 |    | Cloudflare固定隧道的Token(一长串Base64编码字符) |
  | VLESS_WSPATH  | 否 | /vless | 以 / 开头（vless+xhttp） |


* GitHub Actions 用到的变量

  |    变量名     |      备注      |
  | ------------- | -------------- |
  |DOCKER_USERNAME|Docker Hub 用户名|
  |DOCKER_PASSWORD|Docker Hub 密码  |
  |DOCKER_REPO    |Docker Hub 仓库名|

![image](https://user-images.githubusercontent.com/116990986/211692321-34df154a-320a-448f-9abe-2efab9c53550.png)

## 鸣谢

* ifeng 的 v2ray 项目：https://github.com/hiifeng
* fscarmen2 的 argo xray 项目：https://github.com/fscarmen2
* xixu-me 的 xget 项目：https://github.com/xixu-me/xget
## 免责声明

* 本程序仅供学习了解, 非盈利目的，请于下载后 24 小时内删除, 不得用作任何商业用途, 文字、数据及图片均有所属版权, 如转载须注明来源。
* 使用本程序必循遵守部署免责声明。使用本程序必循遵守部署服务器所在地、所在国家和用户所在国家的法律法规, 程序作者不对使用者任何不当行为负责.
