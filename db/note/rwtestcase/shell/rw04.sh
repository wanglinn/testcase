cat /dev/null > ../result/$0.out

source `pwd`/info.conf  >> ../result/$0.out 2>&1

#### setup ####
$mgrConnStr -c "monitor all"  >> ../result/$0.out 2>&1 
$mgrConnStr -c "show cn1 enable_readsql"   >> ../result/$0.out 2>&1 
$cn1ConnStr -c "drop table if exists t1"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t2"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t3"  >> ../result/$0.out  2>&1 

$cn1ConnStr -c "create table t1(id1 int)"  >> ../result/$0.out 2>&1 
$cn1ConnStr -c "create table t2(id2 int)"  >> ../result/$0.out 2>&1 
$cn1ConnStr -c "insert into t1 select generate_series(1,3);"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "insert into t2 select generate_series(1,1);"  >> ../result/$0.out  2>&1


#### run test ####
$cn1ConnStr -c "explain verbose select * from t1,t2"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "select * from t1,t2 order by 1,2;"  >> ../result/$0.out  2>&1

$mgrConnStr -c "stop datanode master all mode f"  >> ../result/$0.out  2>&1
sleep 1
$mgrConnStr -c "monitor all"  >> ../result/$0.out 2>&1 

$cn1ConnStr -c "explain verbose select * from t1,t2;"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "select * from t1,t2 order by 1,2;"  >> ../result/$0.out  2>&1

$mgrConnStr -c "start datanode master all"  >> ../result/$0.out  2>&1 
sleep 1
$mgrConnStr -c "monitor all"  >> ../result/$0.out 2>&1 

$cn1ConnStr -c "insert into t2 select * from t1;"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "explain verbose select * from t1,t2;"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "select * from t1,t2 order by 1,2;"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "create table t3 as select * from t2"  >> ../result/$0.out  2>&1

#### clean ####
$cn1ConnStr -c "drop table if exists t1"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t2"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t3"  >> ../result/$0.out  2>&1 
