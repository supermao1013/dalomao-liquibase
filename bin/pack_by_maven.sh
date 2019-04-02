#!/bin/sh

### 常量
APP_NAME=dalomao-liquibase
SRC_DIR=/usr/local/src/$APP_NAME
DEST_DIR=/usr/local/$APP_NAME

### 打包
cd $SRC_DIR
/usr/local/maven/bin/mvn clean package -DenvironmentProperties=01_local.properties -Dmaven.test.skip=true

### 删除目标目录的旧包
rm -rf $DEST_DIR/$APP_NAME
rm -rf $DEST_DIR/$APP_NAME.jar

### 拷贝最新的包到指定目录
cp $SRC_DIR/target/$APP_NAME.jar $DEST_DIR

### 解压
cd $DEST_DIR
unzip dalomao-liquibase.jar -d $APP_NAME

### 执行ant升级脚本任务
cd $APP_NAME
ant upgrade.db
