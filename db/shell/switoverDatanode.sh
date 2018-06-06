echo "test start $0"

source `pwd`/info.conf

#### tear up ####
$mgrConnStr -c "stop coordinator all mode i"
$mgrConnStr -c "start coordinator master all"
sleep 3

#### tear run ####
$mgrConnStr -c "switchover datanode slave $dn1Slave1Name force"
$mgrConnStr -c "switchover datanode slave $dn2Slave1Name force"

#### tear down ####
$mgrConnStr -c "switchover datanode slave $dn1MasterName force"
$mgrConnStr -c "switchover datanode slave $dn2MasterName force"

echo "test finish $0"