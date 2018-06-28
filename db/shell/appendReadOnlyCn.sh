echo "test start $0"

source `pwd`/info.conf

#### tear up ####
eval $mgrConnStr -c \"$addCn4Str\"

#### tear run ####
eval $mgrConnStr -c \"append coordinator $cn4MasterName for $cn1MasterName\"
eval $mgrConnStr -c \"append activate coordinator $cn4MasterName\"

#check the pgxc_node
eval $cn4ConnStr -c \"select \* from pgxc_node\"

#### tear down ####
eval $mgrConnStr -c \"stop coordinator master $cn4MasterName mode i\"
eval $mgrConnStr -c \"remove coordinator master $cn4MasterName\"
eval $mgrConnStr -c \"clean coordinator master $cn4MasterName\"
eval $mgrConnStr -c \"drop coordinator master $cn4MasterName\"

echo "test finish $0"