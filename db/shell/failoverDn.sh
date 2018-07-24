echo "test start $0"

source `pwd`/info.conf

#### tear up ####


#### tear run ####
$mgrConnStr -c "failover datanode $dn1MasterName force"
$cn1ConnStr -c "select * from pgxc_node order by 1"
$cn2ConnStr -c "select * from pgxc_node order by 1"

#### tear down ####
eval $mgrConnStr -c \"$addDn1MasterReverseStr\"
$mgrConnStr -c "rewind datanode slave $dn1MasterName"
$mgrConnStr -c "switchover datanode slave $dn1MasterName force"

#check the datanode port
$cn1ConnStr -c "select * from pgxc_node order by 1"
$cn2ConnStr -c "select * from pgxc_node order by 1"

echo "test finish $0"
