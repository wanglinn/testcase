echo "test start $0"

source `pwd`/info.conf

#### tear up ####
eval $mgrConnStr -c \"stop gtm slave $gtmSlave1Name mode i\"

#### tear run ####
eval $mgrConnStr -c \"remove gtm slave $gtmSlave1Name\"
eval $mgrConnStr -c \"clean gtm slave $gtmSlave1Name\"

#### tear down ####
eval $mgrConnStr -c \"append gtm slave $gtmSlave1Name\"

echo "test finish $0"