列出mgr中各个node中pgxc_node中内容, 下面port = 6432是 mgr的端口号

[wln@localhost1 python]$ cat execsql.py 
#!/usr/bin/env python
import os,sys
port = 6432

#for host
cmd = "psql -d postgres -p " + str(port) + "\t-c\t'list host(name, address)'"
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
for item in res1:
   if 'coordinator' in item:
       res2 = item.split('|')
       cmd = "psql -d postgres -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select * from pgxc_node order by 1'"
       res = os.popen(cmd,'r',1).read()
       print "nodename : " + res2[0]
       print res


for item in res1:
    if 'datanode' in item:
       res2 = item.split('|')
       cmd = "psql -d postgres -p " + res2[4] + " -h " + res2[1].strip() + " -c 'select * from pgxc_node order by 1'" 
       res = os.popen(cmd,'r',1).read()
       print "nodename : " + res2[0]
       print res 
 
 
