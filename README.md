## 项目说明

该项目的功能主要是结合Liqubase+Ant+Maven进行数据库可持续升级

主要功能及优点如下：

* 支持持续升级、回滚、自动化处理、数据库环境一键迁移等功能

* 目前支持MySQL、PostgreSQL数据库，其他数据库请自行添加

* 可运用于开发环境、测试环境、预发布环境、生产环境

* 可接入可持续集成环境，如集成Jenkins进行自动部署执行

* 去除了传统数据库脚本升级中的手工处理、复杂、不可回溯、环境迁移等一系列问题

* 官方还有很多功能本项目未实现的，可以持续添加

主要缺点如下：

* 只支持单数据库，分库及其他复杂环境下无法使用

* 需要熟悉Liqubase相关语法，不过也支持原生sql语句

## 版本说明

* Liqubase：3.6.3

* Ant：1.7.0

## 使用说明

首先，要使用该工程，你必须规范你们团队的可持续流程，并且专门一个人负责此事项，当然这只是建议

其次，该工程可以集成Jenkins进行自动化打包并执行，而且也建议应该这么做

### 开发环境使用

* 使用IntelliJ IDEA导入该maven工程

* dbmigration.properties文件中配置好数据库参数

* 在.xml中编写sql升级语句和回退语句（示例中有说明），这里的语句通常是按版本归类，此示例中为prod.data下的rel-1.0.0、rel-1.1.0

* 编写完所有语句，需要纳入到每个版本下的script_suite.xml中

* 以上步骤做完以后，还需要在build.xml中处理两个事项
    > 1.在db-rel升级任务中纳入升级脚本，script.dir为本次升级的脚本路径，tagVersion为本次升级的版本号（改版本号在回退时会用到），<font color=red>**升级脚本可以一直加，执行过的则不会再执行**</font>
    
    > 2.在rollback-db-rel回退任务中纳入本次回退脚本，script.dir为本次回退的脚本路径，tagVersion为本次回退的版本号，<font color=red>**回退任务在实际生产环境只要配置当前version的任务即可**</font>

* 使用Ant运行build.xml中的任务，主要是两个任务：upgrade.db表示升级任务、rollback.db表示回退任务

### 测试、预发布、生产环境使用

* 将项目打成jar包，打包命令：mvn clean package -DenvironmentProperties=xxx.properties -Dmaven.test.skip=true
    
	其中xxx.properties对应不同的环境，请自行更改，每个环境对应的配置文件如下：

    > <font color=blue>**01_local.properties：本地开发环境**</font>
    
    > <font color=blue>**02_test.properties：测试环境**</font>
    
    > <font color=blue>**03_uat.properties：预发布环境**</font>
    
    > <font color=blue>**04_prd.properties：生产环境**</font>

* 在CentOS环境安装ant，安装教程可以参考：[https://blog.csdn.net/supermao1013/article/details/88863212](https://blog.csdn.net/supermao1013/article/details/88863212 "Ant环境安装（Windows10+CentOS7）")

* 在CentOS环境解压jar包，解压命令：unzip dalomao-liqubase.jar -d dalomao-liqubase

* 进入dalomao-liqubase目录执行
    
	> <font color=blue>**升级命令：ant upgrade.db**</font>
	
    > <font color=blue>**回退命令：ant rollback.db**</font>

* 打包和执行脚本可以参看：pack_by_maven.sh

### 其他说明

* rollback-db-rel和db-rel共用同一套升级脚本，脚本中需要写入升级和回退语句

* build.xml中有相关注释说明，以及其他的无用功能的注释，可自行删除，不影响现有功能

* PostgreSQL中有schem模式功能（mysql中没有），因此在使用PostgreSQL时需要定义default_schema参数，然后在bulid.xml的my-database中纳入该参数

## 相关截图

![项目目录结构说明](https://github.com/supermao1013/all-images/blob/master/dalomao-liquibase/%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84%E8%AF%B4%E6%98%8E.png)

![changelog划分](https://github.com/supermao1013/all-images/blob/master/dalomao-liquibase/changelog%E5%88%92%E5%88%86.png)

![Ant任务说明](https://github.com/supermao1013/all-images/blob/master/dalomao-liquibase/Ant%E4%BB%BB%E5%8A%A1%E8%AF%B4%E6%98%8E.png)

## 参考

Liqubase教程：https://www.liquibase.org/documentation/index.html

Ant教程：https://www.w3cschool.cn/ant/
