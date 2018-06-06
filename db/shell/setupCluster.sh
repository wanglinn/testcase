echo "test start $0"

source `pwd`/info.conf
mkpath
initMgr
startMgr
loadMgrInfo
initDbCluster


echo "test finish $0"
