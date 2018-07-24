echo "test start $0"

source `pwd`/info.conf

#### tear up ####

#### tear run ####
$mgrConnStr -c "monitor ha"

#check the pgxc_node

#### tear down ####

echo "test finish $0"