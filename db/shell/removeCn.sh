echo "test start $0"

source `pwd`/info.conf

#### tear up ####
eval $mgrConnStr -c \"stop coordinator master $cn3MasterName mode i\"

#### tear run ####
eval $mgrConnStr -c \"remove coordinator master $cn3MasterName\"
eval $mgrConnStr -c \"clean coordinator master $cn3MasterName\"

#### tear down ####
eval $mgrConnStr -c \"$addCn3Str\"
eval $mgrConnStr -c \"append coordinator $cn3MasterName for $cn1MasterName\"
eval $mgrConnStr -c \"append activate coordinator $cn3MasterName\"

echo "test finish $0"