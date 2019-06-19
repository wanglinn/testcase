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
$cn1ConnStr -c "insert into t1 select generate_series(1,10);"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "insert into t2 select generate_series(1,10);"  >> ../result/$0.out  2>&1 


#### run test ####
# t1
$cn1ConnStr -c "insert into t1 values(11)"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "update t1 set id1=11 where id1=1"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "delete from t1 where id1=2"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "truncate t1"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "drop table t1"  >> ../result/$0.out  2>&1
# t2
$cn1ConnStr -c "insert into t2 values(11)"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "update t2 set id2=11 where id2=1"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "delete from t2 where id2=2"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "truncate t2"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "drop table t2"  >> ../result/$0.out  2>&1

# init t1,t2
$cn1ConnStr -c "create table t1(id1 int)"  >> ../result/$0.out 2>&1 
$cn1ConnStr -c "create table t2(id2 int)"  >> ../result/$0.out 2>&1 
$cn1ConnStr -c "insert into t1 select generate_series(1,10);"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "insert into t2 select generate_series(1,10);"  >> ../result/$0.out  2>&1

$cn1ConnStr -c "select * from t1 order by 1"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "create table t3 as select * from t1"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "drop table t3"  >> ../result/$0.out  2>&1

$mgrConnStr -c "stop datanode master all mode f"  >> ../result/$0.out  2>&1
sleep 1
$mgrConnStr -c "monitor all"  >> ../result/$0.out 2>&1 
$cn1ConnStr -c "select * from t1 order by 1"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "select pg_sleep(1)"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "select pg_is_in_recovery()"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "select * from t1,t2 where id1 > random()*10 and id1=id2 order by 1,2"  >> ../result/$0.out  2>&1
$cn1ConnStr -c "select * from t1,t2 where t1.id1 = 1 order by 1,2"  >> ../result/$0.out  2>&1

## fail
print_fail >> ../result/$0.out 2>&1 
$cn1ConnStr -c "insert into t1 values(11)"  >> ../result/$0.out  2>&1
print_fail >> ../result/$0.out 2>&1 
$cn1ConnStr -c "update t1 set id1=11 where id1=1"  >> ../result/$0.out  2>&1
print_fail >> ../result/$0.out 2>&1 
$cn1ConnStr -c "delete from t1 where id1=2"  >> ../result/$0.out  2>&1
print_fail >> ../result/$0.out 2>&1 
$cn1ConnStr -c "truncate t1"  >> ../result/$0.out  2>&1
print_fail >> ../result/$0.out 2>&1 
$cn1ConnStr -c "drop table t1"  >> ../result/$0.out  2>&1
print_fail >> ../result/$0.out 2>&1 
$cn1ConnStr -c "create table t3 as select * from t1"  >> ../result/$0.out  2>&1

#### clean ####
$mgrConnStr -c "start datanode master all"  >> ../result/$0.out  2>&1 
sleep 1
$mgrConnStr -c "monitor all"   >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t1"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t2"  >> ../result/$0.out  2>&1 
$cn1ConnStr -c "drop table if exists t3"  >> ../result/$0.out  2>&1 

