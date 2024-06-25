# CURL-CI&CD

## 设计构想

- 请求参数：
  - username：项目编写者名称
  - deployer：项目发布者名称
  - passwd：项目发布者密码
  - deploy_message：项目更新日志内容
  - project_name：项目名称
  - module_name：模块名称
  - method_name：动作名称

- 日志输出格式：
  - [info] ${time} ${deployer} ${method_name} ${project_name} ${module_name}:${deploy_message}
    ```bash
    [info] 2024-06-21 00:00:00 test deployed test-project test-mode:test deployed
    [info] 2024-06-21 00:00:00 test rollback test-project test-mode:test rollback
    ```

- 模块设计部分：
  - 初步构想是作为一个中间件处理，在接受到路由的时候进行特定脚本的执行，后续调试只需要修改脚本即可

- 问题部分：
  - 外部请求时，需要知道脚本的执行情况
  - deployer 和 passwd 的校对
  - 文件拷贝情况的校对

## 函数部分

- function sync_file()
- function check_username_and_passwd()
- function check_md5()
- function deploy()
- function rollback()
- function log()

## 设计目的

为了信息安全的原因，避免服务器横向的 SSH 连接，从而使用 CURL 的方式监听路由请求进行 CI&CD 发布请求

## 部署教程

```bash
# TODO))
```

## 使用方法

### 结合 Jenkins 使用

在 Jenkins Web 界面的 Shell 部分写入下面内容

```shell
#!/bin/bash -ilex
# TODO: 完成脚本
```

### 直接发送请求使用

1. 发布
    ```bash
    curl "http://localhost:9999/deploy"
    ```
2. 回滚
    ```bash
    curl "http://localhost:9999/rollback"
    ```
