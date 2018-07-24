echo "test start $0"

source `pwd`/info.conf

#### tear up ####


#### tear run ####

#for gtm master
$mgrConnStr -c "show $gtmMasterName port"
$mgrConnStr -c "alter gtm master $gtmMasterName (port=$tempPort1)"
$mgrConnStr -c "show $gtmMasterName port"

#for coordinator port
$mgrConnStr -c "show $cn2MasterName port"
$mgrConnStr -c "alter coordinator master $cn2MasterName (port=$tempPort2)"
$mgrConnStr -c "show $cn2MasterName port"
$cn1ConnStr -c "select * from pgxc_node order by 1"
$cn3ConnStr -c "select * from pgxc_node order by 1"

#for datanode master dn1MasterName
$mgrConnStr -c "show $dn1MasterName port"
$mgrConnStr -c "alter datanode master $dn1MasterName (port=$tempPort3)"
$mgrConnStr -c "show $dn1MasterName port"
$cn1ConnStr -c "select * from pgxc_node order by 1"
$cn3ConnStr -c "select * from pgxc_node order by 1"

#for datanode slave
$mgrConnStr -c "show $dn2Slave1Name port"
$mgrConnStr -c "alter datanode slave $dn2Slave1Name (port=$tempPort4)"
$mgrConnStr -c "show $dn2Slave1Name port"


#### tear down ####
$mgrConnStr -c "alter gtm master $gtmMasterName (port=$gtmMasterPort)"
$mgrConnStr -c "alter coordinator master $cn2MasterName (port=$cn2MasterPort)"
$mgrConnStr -c "alter datanode master $dn1MasterName (port=$dn1MasterPort)"
$mgrConnStr -c "alter datanode slave $dn2Slave1Name (port=$dn2Slave1Port)"
$cn1ConnStr -c "select * from pgxc_node order by 1"
$cn3ConnStr -c "select * from pgxc_node order by 1"

echo "test finish $0"