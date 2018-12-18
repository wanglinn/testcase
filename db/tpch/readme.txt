打算测试下xxDB 与greenplum 性能对比情况，测试了scale 0.01x 及 1x 结果，发现多个sql 在greenplum 不正确。先给greenpum 提了一个issue.
https://github.com/greenplum-db/gpdb/issues/3557  （时间的处理问题，换个写法可以规避过去）

tpch 来自：2.17.3 http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp
dbgen 可执行文件生成：将makefile*文件重命名为makefile, 修改里面内容：
CC      = gcc
ATABASE= ORACLE
MACHINE = LINUX
WORKLOAD = TPCH
然后执行make 即可生成dbgen文件

数据生成：./degen -s N (N为float类型)
构造出的数据文件每行最后都有分隔符，不符合greenplum数据格式，需要做处理：
//deal.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    if(argc < 2)
        printf("wrong use, %d\n", argc);
    FILE *fp1 = fopen(argv[1], "r");
    FILE *fp2 = fopen(argv[2], "w");
    char str_data[1000];
    int len = 0;
    while((fgets(str_data, 1000, fp1) != NULL) && strlen(str_data) > 2)
    {
        len = strlen(str_data);
        str_data[len - 2] = '\0';
        fprintf(fp2, "%s\n", str_data);
    }
    fclose(fp1);
    fclose(fp2);
    return 0;
}

--
./deal customer.tbl bak/customer.tbl
./deal lineitem.tbl bak/lineitem.tbl
./deal nation.tbl bak/nation.tbl
./deal orders.tbl  bak/orders.tbl
./deal part.tbl bak/part.tbl
./deal partsupp.tbl bak/partsupp.tbl
./deal region.tbl bak/region.tbl
./deal  supplier.tbl bak/supplier.tbl


创建表：dbgen/dss.ddl
22个sql语句：dbgen/queries （若需要在greenplum,postgres上执行官需要修改sql语句形式）

copy.sql
COPY customer FROM '/data/tpch2173/data1x/customer.tbl' DELIMITER '|';
COPY lineitem FROM '/data/tpch2173/data1x/lineitem.tbl' DELIMITER '|';
COPY nation FROM '/data/tpch2173/data1x/nation.tbl' DELIMITER '|';
COPY orders FROM '/data/tpch2173/data1x/orders.tbl' DELIMITER '|';
COPY partsupp FROM '/data/tpch2173/data1x/partsupp.tbl' DELIMITER '|';
COPY part FROM '/data/tpch2173/data1x/part.tbl' DELIMITER '|';
COPY region FROM '/data/tpch2173/data1x/region.tbl' DELIMITER '|';
COPY supplier FROM '/data/tpch2173/data1x/supplier.tbl' DELIMITER '|';
analyze customer;
analyze lineitem;
analyze nation;
analyze orders;
analyze partsupp;
analyze part;
analyze region;
analyze supplier;

count.sql
select count(*) from customer;
select count(*) from lineitem;
select count(*) from nation;
select count(*) from orders;
select count(*) from part;
select count(*) from partsupp;
select count(*) from region;
select count(*) from supplier;
\d

drop.sql
drop table customer;
drop table lineitem;
drop table nation;
drop table orders;
drop table part;
drop table partsupp;
drop table region;
drop table supplier;
\d

greenplum 编译
命令形式如：
 ./configure --disable-orca --with-perl --with-python --with-libxml --prefix=/usr/local/gpdb
 
 有关安装参考：http://blog.sina.com.cn/s/blog_68ef18a901012b3t.html
 有效步骤如下：
 免密码输入可以使用下面的方式：
 1.rm -rf ~/.ssh
2.ssh-keygen -t dsa -f ~/.ssh/id_dsa -N ""
3.cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
4.chmod 640 ~/.ssh/authorized_keys
5.add config in .ssh
Host
    StrictHostKeyChecking=no

then,
chmod 0600 ~/.ssh/config
6.if the content shows like this:
reverse mapping checking getaddrinfo for bogon [192.168.17.130] failed - POSSIBLE BREAK-IN ATTEMPT!
it needs to modify the file /etc/ssh/ssh_config , changes "GSSAPIAuthentication yes" to "GSSAPIAuthentication no"

查看greenplum节点部署情况：
select * from gp_segment_configuration ;

22个sql 语句从网站上下载后需要改写下。
