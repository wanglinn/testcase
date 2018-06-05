source `pwd`/info.conf

#set parallel
$mgrConnStr -c "set gtm all(force_parallel_mode=on, max_parallel_workers_per_gather=8);"
$mgrConnStr -c "set coordinator all(force_parallel_mode=on, max_parallel_workers_per_gather=8);"
$mgrConnStr -c "set datanode all(force_parallel_mode=on, max_parallel_workers_per_gather=8);"

