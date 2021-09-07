# pro - 一个针对macOS的快速启动项目的工具

## 下载

```bash
$ npm i @asarua/pro -g
```

## 使用方式

```bash
$ pro
# 在此输入你常用项目集合的根目录，比如我的项目都是在/Users/asarua/Desktop/others/projects目录下，此时我只需要将此目录复制到此即可
# 此提示只出现一次，后续可以直接选择项目
请输入项目文件夹的绝对路径：/Users/asarua/Desktop/others/projects
请选择项目：
 1) callapp		    14) private_npm_backup
 2) coa
#? 1
当前选中项目为：xxx
1) 打开
2) 启动
#? 2
请输入要选择启动的命令：
 1) start
 2) build
#? 1

```

## 选项

- `-r | --remove` 移除已添加的项目路径，下次pro的时候将需要重新进行输入项目路径

- `-u | --update` 更新pro版本

- `-h | --help` 输出pro的使用方式

- `-v | --version` 输出pro的版本

- `-a | --append` 增加项目根目录路径

## 项目描述

暂时只支持mac
