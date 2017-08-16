## ngrok

#### Docker

> docker build -t haiyon/ngrokd .

#### 服务端

由于直接使用非80端口不太友好，使用Docker模式运行服务，并且通过nginx进行代理，如果没有nginx服务占用80端口，直接映射80端口即可

> docker pull haiyon/ngrokd

运行并映射非80端口
> docker run -d -p 8880:80 -p 8443:443 -p 12943:4443 --name ngrokd --restart always haiyon/ngrokd

nginx 代理配置

``` bash
upstream ngrok {
  server 127.0.0.1:8880;
  keepalive 64;
}

server {
  listen       80;
  server_name te.uexun.com;
  server_name_in_redirect off;

  root   /data/www/te.uexun;
  index index.php index.html;

  access_log  /var/log/nginx/te.uexun.access.log  main;
  error_log  /var/log/nginx/te.uexun.error.log;

  # deny running scripts inside writable directories
  location ~* /(images|cache|media|logs|tmp)/.*\.(php|pl|py|jsp|asp|sh|cgi)$ {
    return 403;
    error_page 403 /403_error.html;
  }

  # caching of files
  location ~* \.(ico|pdf|flv)$ {
    expires 1y;
  }

  location ~* \.(js|css|png|jpg|jpeg|gif|swf|xml|txt)$ {
    expires 14d;
  }
}

server {
  listen       80;
  server_name *.te.uexun.com;

  access_log  /var/log/nginx/tunnel.uexun.access.log  main;
  error_log  /var/log/nginx/teunnel.uexun.error.log;

  location / {
    proxy_pass  http://ngrok;
    #Proxy Settings
    proxy_redirect     off;
    proxy_set_header   Host             $host;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_set_header   Connection       "";
    proxy_set_header   X-Nginx-Proxy    true;
    proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
 }
}

```

#### 配置

编辑 config 配置服务器地址`已配置好，如果变更服务器端口需要重新修改`

配置示例：

```
# tcp
tunnels:
  ssh:
    remote_port: 28020
    proto:
      tcp: 22

 # http / https

  wx:
    subdomain: wx
    proto:
      http: 6010
```
注： ssh/ wx 为启动名称，可以随意定义，subdomain 为访问地址，如上wx 实际访问地址为 `wx.te.uexun.com`

#### Mac/Linux/arm

使用 run 脚本运行即可，选择完平台后在选开始服务，开始服务输入内容对应配置文件中的 wx / ssh ,多个服务用空格隔开即可

运行
> bash run

选择平台
> Select Platform： 1

开始服务
> Start Service： ssh wx

#### Windows

双击 run_window.bat 文件或拖到命令行运行即可


#### 其它
如果链接服务错误，请确认二级域名别人有没有使用，尝试更改为一个不太常用的名称，windows更改子域名编辑 run_window.bat 即可
