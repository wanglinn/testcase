source `pwd`/info.conf

#### tear up ####


#### tear run ####
$mgrConnStr -c "switchover gtm slave $gtmSlave1Name"

#### tear down ####
$mgrConnStr -c "switchover gtm slave $gtmMasterName"
