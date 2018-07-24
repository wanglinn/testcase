echo "test start $0"

source `pwd`/info.conf

#### tear up ####
eval $mgrConnStr -c \"monitor all\"

#### tear run ####
$cn1ConnStr -c "select pg_pause_cluster();"
$cn1ConnStr -c "select pg_unpause_cluster();"

$cn2ConnStr -c "select pg_pause_cluster();select pg_unpause_cluster();"

#### tear down ####

echo "test finish $0"