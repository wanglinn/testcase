for i in {1..22}
do
 echo "set statement_timeout=120000;" > bak1/$i.sql
 cat $i.sql >> bak1/$i.sql
done
