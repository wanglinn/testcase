使用pgbench 大致操作流程：

export port=55100
psql -p $port -c "CREATE USER benchmarksql WITH SUPERUSER PASSWORD 'password';"
psql -p $port -c "GRANT ALL PRIVILEGES ON DATABASE postgres TO benchmarksql"
psql -p $port -c "CREATE schema benchmarksql"

--创建表
./runSQL.sh props.wln sqlTableCreates


#./runLoader.sh props.wln numWarehouses 200

--生成数据 50w 大约  3.4G
mkdir -p /home/wln/csv/50/
./runLoader.sh props.wln numWarehouses 50 fileLocation /home/wln/csv/50/

--导入数据
./runSQL.sh props.wln sqlTableCopies

--清空表数据
./runSQL.sh props.wln sqlTableTruncates
--创建索引
 ./runSQL.sh props.wln sqlIndexCreates

--执行测试
 ./runBenchmark.sh props.wln
 
 
set gtm master gtm (max_connections=200, max_prepared_transactions=200,lock_timeout=20000);
 set datanode all (max_connections=200, max_prepared_transactions=200,lock_timeout=20000);
set coordinator all (max_connections=200, max_prepared_transactions=200,lock_timeout=20000);



生成表数据
------------- LoadJDBC Statistics --------------------
     Start Time = Tue May 08 17:13:26 CST 2018
       End Time = Tue May 08 17:27:39 CST 2018
       Run Time = 853 Seconds
    Rows Loaded = 25059610 Rows
Rows Per Second = 29378 Rows/Sec
------------------------------------------------------


---------------------
10.1.226.201
^H^H^H^H^H^H^H^H2018-05-09 06:14:28,602  INFO - Term-00,  
2018-05-09 06:14:28,602  INFO - Term-00, 
2018-05-09 06:14:28,602  INFO - Term-00, Measured tpmC (NewOrders) = 2.81
2018-05-09 06:14:28,602  INFO - Term-00, Measured tpmTOTAL = 5.19
2018-05-09 06:14:28,602  INFO - Term-00, Session Start     = 2018-05-09 06:00:59
2018-05-09 06:14:28,603  INFO - Term-00, Session End       = 2018-05-09 06:14:28
2018-05-09 06:14:28,603  INFO - Term-00, Transaction Count = 69
