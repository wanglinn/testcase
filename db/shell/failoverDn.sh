echo "test start $0"

source `pwd`/info.conf

#### tear up ####


#### tear run ####
$mgrConnStr -c "failover datanode $dn1MasterName force"

#### tear down ####
eval $mgrConnStr -c \"$addDn1MasterReverseStr\"
$mgrConnStr -c "rewind datanode slave $dn1MasterName"
$mgrConnStr -c "switchover datanode slave $dn1MasterName force"

echo "test finish $0"
