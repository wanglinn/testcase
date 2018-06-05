source `pwd`/info.conf

#set unparallel
$mgrConnStr -c "reset gtm all(force_parallel_mode=on, max_parallel_workers_per_gather=8);"
$mgrConnStr -c "reset coordinator all(force_parallel_mode=on, max_parallel_workers_per_gather=8);"
$mgrConnStr -c "reset datanode all(force_parallel_mode=on, max_parallel_workers_per_gather=8);"

