echo "test start $0"

source `pwd`/info.conf

#### tear up ####
$mgrConnStr -c "stop coordinator master $cn1MasterName mode i"
$mgrConnStr -c "flush param"
$mgrConnStr -c "start coordinator master $cn1MasterName"

#### tear run ####

#check the pgxc_node
sleep 2
$mgrConnStr -c "flush param"
$mgrConnStr -c "set datanode master $dn1MasterName (enable_hashagg=off);"
$mgrConnStr -c "set datanode master $dn1MasterName (enable_hashaggx=off);"

#### tear down ####
$mgrConnStr -c "reset datanode master $dn1MasterName (enable_hashagg=off);"

echo "test finish $0"