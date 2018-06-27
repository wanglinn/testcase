用例主要包括以下几种：
shell用例：主要用来测试数据库集群管理功能
sql: 主要测试数据库sql语法、稳定性、压力测试，也包括出问题时添加的测试用例


文件夹 db/shell 下用例说明
info.conf -- 用来搭建集群所需要的各种信息，可以根据需要进行设置及更改(在使用时把userpw 用户密码及所使用的主机ip更改下)

初始条件
sh setupCluster.sh  --  搭建集群  
sh set.sh  -- 设置并行及开启集群计划
sh unset.sh  -- 关闭并行及关闭集群计划

测试用例说明
(需要说明的是：测试用例执行后的状态 必须 和 执行前 一样，即测试用例包括以下三个部分：前置处理、执行、恢复)

sh removeGtm.sh  -- 剔除gtm 备机测试（对应命令remove gtm slave xx）
sh removeDn.sh   -- 剔除datanode 备机测试
sh removeCn.sh   -- 剔除coordinator master测试
sh failoverGtm.sh   -- 对failover gtm 备节点替换为主节点的测试
sh failoverDn.sh    -- 对failover datanode 备节点替换为主节点的测试
sh switoverGtm.sh   -- gtm 主节点与备节点互换测试
sh switoverDatanode.sh  -- datanode 主节点与备节点互换测试
sh checkHandleCoordJob.sh  --对自动剔除异常coordinator定时任务功能测试


