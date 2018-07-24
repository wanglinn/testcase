echo "test start $0"

source `pwd`/info.conf

#### tear up ####


#### tear run ####
$mgrConnStr -c "failover gtm $gtmMasterName force"
#check the port
$mgrConnStr -c "show $dn1MasterName agtm"
$mgrConnStr -c "show $dn2MasterName agtm"

#### tear down ####
eval $mgrConnStr -c \"$addGtmMasterReverseStr\"
$mgrConnStr -c "rewind gtm slave $gtmMasterName"
$mgrConnStr -c "switchover gtm slave $gtmMasterName force"

#check the port
$mgrConnStr -c "show $dn1MasterName agtm"
$mgrConnStr -c "show $dn2MasterName agtm"

echo "test finish $0"
