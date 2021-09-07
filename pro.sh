#!/usr/bin/env bash

set -e

pr_path="$HOME/.pr_path"
is_start="false"
only_option="false"

[[ `uname` != "Darwin" ]] && echo "暂不支持当前系统！" && exit 0

toggle() {
  only_option="true"
}

usage() {
  cat <<EOF

pro
  a command line tool for macOS, to start project quickly

[Usage]
  $ pro [-hruva]

  [options]
    -h | --help    echo the usage
    -r | --remove  remove project path cache
    -u | --update  update pro
    -v | --version echo version
    -a | --append  append project path

EOF
}

check_path() {
  if ! [ -d $1 ]; then
    echo "输入路径为$1"
    echo "项目文件夹输入错误！"
    exit 1
  fi
}

if ! [ -z ${#@} ]; then
  while [ ${#@} -gt 0 ];
  do
    case $1 in
      -h|--help)
        usage && toggle
        shift
        ;;
      -r|--remove)
        rm -i $pr_path && echo "$pr_path删除成功！"
        toggle
        shift
        ;;
      -u|--update)
        npm i @asarua/pro -g
        toggle
        shift
        ;;
      -v|--version)
        cat "`dirname $0`/package.json" | grep "version" | awk -F"\"" '{print $4}'
        toggle
        shift
        ;;
      -a|--append)
        read -p "请输入项目文件夹的绝对路径：" root_path
        first=${root_path%%/*}
        if [[ $first == "~" ]]; then
          root_path="$HOME/${root_path#*/}"
        fi
        check_path $root_path
        echo -e "$root_path" >> $pr_path
        shift
        ;;
      *)
        echo "参数错误！使用方式如下"
        usage
        exit 1
        ;;
    esac
  done
fi

[[ $only_option =~ "true" ]] && exit 0

echo_pkg() {
  local pkg_path="$path/$1/package.json"
  while read line; do
    if [[ $is_start == "true" ]]; then

      if [[ $line =~ "}" ]]; then
        is_start="false"
      fi

      if [[ $is_start == "true" ]]; then
        echo $line | awk 'BEGIN {FS="\""} {print $2}'
      fi
    fi

    if [[ $line =~ "scripts" ]] && [[ $line =~ "{" ]]; then
      is_start="true"
    fi
  done < $pkg_path
}

if ! [ -f $pr_path ]; then
  read -p "请输入项目文件夹的绝对路径：" path
  first=${path%%/*}
  if [[ $first == "~" ]]; then
    path="$HOME/${path#*/}"
  fi

  check_path $path
  echo $path > $pr_path
else
  path=`cat $pr_path`
fi

if [ `cat $pr_path | grep -v "^$" | grep -c "^.*"` -gt 1 ]; then
  select project in `cat $pr_path`; do
    if [ -z `grep "$project" $pr_path` ]; then
      echo "输入错误！请重新输入："
    else
      path=$project
      break
    fi
  done
fi

cd $path

echo "请选择项目："
select i in `ls`;
do
  if [[ $i != "" ]] && [ -d "$path/$i" ] ; then
    echo "当前选中项目为：$i"
    cd "$path/$i"
    select edit in "打开" "启动"; do
      if [ $edit == "打开" ]; then
        code . && exit
      else
        if ! [ -f package.json ]; then
          echo "未发现package.json文件，请重新选择目录！"
        else
          echo "请输入要选择启动的命令："
          select c in `echo_pkg $i`; do
            echo -e "当前项目为 `pwd`\n'npm run $c'命令开始运行！"
            npm run $c
            exit
          done
        fi
      fi
    done
  else
    echo "输入错误，您选择的可能不是一个文件夹，请重新输入："
  fi
done
