echo "test start $0"

source `pwd`/info.conf

#### tear up ####
eval $mgrConnStr -c \"stop datanode slave $dn1Slave1Name mode i\"

#### tear run ####
eval $mgrConnStr -c \"remove datanode slave $dn1Slave1Name\"
eval $mgrConnStr -c \"clean datanode slave $dn1Slave1Name\"

#### tear down ####
eval $mgrConnStr -c \"append datanode slave $dn1Slave1Name\"

echo "test finish $0"