#!/usr/bin/env python
import os,sys
port = 6432
dbname = 'db1'

#for host
cmd = "psql -d postgres  -p " + str(port) + "\t-c\t'list host(name, address)'"
res = os.popen(cmd,'r',1).read()
#split the result
res1 = res.split('\n')
del res1[0:2]
del res1[-1:-2]
#print res1

cmd = "psql -d postgres -p " + str(port) + "\t-c\t'list node'"
res = os.popen(cmd,'r',1).read()

#split the result
res1 = res.split('\n')
del res1[0:2]
del res1[-1:4]
res1.sort()

sqlstr = ""

for item in res1:
    if 'coordinator' not in item:
       continue

    res2 = item.split('|')

    cmd1 =  "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select * from pgxc_node order by 1;'"
    cmd2 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select count(*), min(slotid), \
       max(slotid), slotstatus, slotnodename  from adb_slot  group by slotnodename, slotstatus order by 2;'"
    cmd3 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip()  + " -c 'show pgxc_node_name'"
    cmd4 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip()  + " -c 'select * from pg_prepared_xacts'"
    cmd5 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip()  + " -c 'select * from pg_prepared_statements;'"
    cmd = cmd1

    if len(sys.argv) > 1:
        if '1' == sys.argv[1]:
            cmd = cmd1
        if '2' == sys.argv[1]:
            cmd = cmd2
        if '3' == sys.argv[1]:
            cmd = cmd3
        if '4' == sys.argv[1]:
            cmd = cmd4
        if '5' == sys.argv[1]:
            cmd = cmd5
    if len(sys.argv) > 2:
           sqlstr = sys.argv[2]
           cmd6 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip()  + " -c '" + sqlstr + "'"
           cmd = cmd6

    result = os.popen(cmd,'r',1).read()
    print "nodename : " + res2[0]
    print result

for item in res1:
    if 'datanode' not in item:
       continue

    res2 = item.split('|')

    cmd1 =  "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select * from pgxc_node order by 1;'"
    cmd2 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select count(*), min(slotid), \
       max(slotid), slotstatus, slotnodename  from adb_slot  group by slotnodename, slotstatus order by 2;'"
    cmd3 = "psql -d " +  dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'show pgxc_node_name'"
    cmd4 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select * from pg_prepared_xacts'"
    cmd5 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select * from pg_prepared_statements;'"

    cmd = cmd1

    if len(sys.argv) > 1:
        if '1' == sys.argv[1]:
            cmd = cmd1
        if '2' == sys.argv[1]:
            cmd = cmd2
        if '3' == sys.argv[1]:
            cmd = cmd3
        if '4' == sys.argv[1]:
            cmd = cmd4
        if '5' == sys.argv[1]:
            cmd = cmd5

    if len(sys.argv) > 2:
        sqlstr = sys.argv[2]
        cmd6 = "psql -d " + dbname + " -p " + res2[4] + " -h " + res2[1].strip() + " -c '" + sqlstr + "'"
        cmd = cmd6


    result = os.popen(cmd,'r',1).read()
    print "nodename : " + res2[0]
    print result



 

