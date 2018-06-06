echo "test start $0"

source `pwd`/info.conf

#### tear up ####


#### tear run ####
$mgrConnStr -c "failover gtm $gtmMasterName force"

#### tear down ####
eval $mgrConnStr -c \"$addGtmMasterReverseStr\"
$mgrConnStr -c "rewind gtm slave $gtmMasterName"
$mgrConnStr -c "switchover gtm slave $gtmMasterName force"

echo "test finish $0"
