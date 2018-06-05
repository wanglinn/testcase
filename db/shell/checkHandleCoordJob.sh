echo "test start $0"
source `pwd`/info.conf

#####tear up ####
#check pgxc_node on coordinator cn1
eval $cn1ConnStr -c \"select count\(*\) \
					from pgxc_node where node_name=\'$cn2MasterName\'\"

##### tear run ####
#stop coordinator cn2
eval $mgrConnStr -c \"stop coordinator master $cn2MasterName mode i\"

#add coordinator handle job
eval $mgrConnStr -c \"drop job cnHandle\"
cnHandleJobStr="add job cnHandle (interval=2, command='select monitor_handle_coordinator()');"
eval $mgrConnStr -c \"$cnHandleJobStr\"
sleep 30
#check pgxc_node on coordinator cn1
eval $cn1ConnStr -c \"select count\(*\) \
							from pgxc_node where node_name=\'$cn2MasterName\'\"

#### tear down ####
#drop job
cnHandleJobStr="drop job cnHandle"
eval $mgrConnStr -c \"$cnHandleJobStr\"
#clean coordinator cn2
eval $mgrConnStr -c \"clean coordinator master $cn2MasterName\"
eval $mgrConnStr -c \"append coordinator $cn2MasterName for $cn1MasterName\"
eval $mgrConnStr -c \"append activate coordinator $cn2MasterName\"
sleep 3
#check pgxc_node on coordinator cn1
eval $cn1ConnStr -c \"select count\(*\) from pgxc_node where node_name=\'$cn2MasterName\'\"


echo "test stop $0"
