-- testcase 1
create table mlparted (a int, b int) partition by range (a, b) distribute by random(a,b);
create table mlparted1 (b int not null, a int not null) distribute by random(b, a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 2
create table mlparted (a int, b int) partition by range (a, b) distribute by random(a,b);
create table mlparted1 (b int not null, a int not null) distribute by  random(a,b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 3
create table mlparted (a int, b int) partition by range (a, b) distribute by hash(a);
create table mlparted1 (b int not null, a int not null) distribute by hash(b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 4
create table mlparted (a int, b int) partition by range (a, b) distribute by hash(a);
create table mlparted1 (b int not null, a int not null) distribute by hash(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 5
create table mlparted (a int, b int) partition by range (a, b) distribute by modulo(a);
create table mlparted1 (b int not null, a int not null) distribute by modulo(b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 6
create table mlparted (a int, b int) partition by range (a, b) distribute by modulo(a);
create table mlparted1 (b int not null, a int not null) distribute by modulo(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 7
create table mlparted (a int, b int) partition by range (a, b) distribute by hashmap(a);
create table mlparted1 (b int not null, a int not null) distribute by hashmap(b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 8
create table mlparted (a int, b int) partition by range (a, b) distribute by hashmap(b);
create table mlparted1 (b int not null, a int not null) distribute by hashmap(b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 9
CREATE OR REPLACE FUNCTION mydistributor(id integer default 1, value integer default 2)
RETURNS integer
AS
$$
BEGIN
RETURN ( id + value ) % 2;
END;
$$
LANGUAGE plpgsql
IMMUTABLE
STRICT;

create table mlparted (a int, b int) partition by range (a, b) distribute by mydistributor(b);
create table mlparted1 (b int not null, a int not null) distribute by mydistributor(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

create table mlparted (a int, b int) partition by range (a, b) distribute by mydistributor(a, b);
create table mlparted1 (b int not null, a int not null) distribute by mydistributor(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

create table mlparted (a int, b int) partition by range (a, b) distribute by mydistributor(a,b);
create table mlparted1 (b int not null, a int not null) distribute by mydistributor(b,a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

create table mlparted (a int, b int) partition by range (a, b) distribute by mydistributor(a,b);
create table mlparted1 (b int not null, a int not null) distribute by mydistributor(a,b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

drop function mydistributor(int, int);

--testcase 10
CREATE OR REPLACE FUNCTION mydistributor(id integer default 1, value integer default 2)
RETURNS integer
AS
$$
BEGIN
RETURN ( id + value ) % 2;
END;
$$
LANGUAGE plpgsql
IMMUTABLE
STRICT;

create table mlparted (a int, b int) partition by range (a, b) distribute by random(a,b);
create table mlparted1 (b int not null, a int not null) distribute by mydistributor(a, b);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

drop function mydistributor(int, int);

--testcase 11
create table mlparted (a int, b int) partition by range (a, b) distribute by hash(b);
create table mlparted1 (b int not null, a int not null) distribute by hashmap(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 12
create table mlparted (a int, b int) partition by range (a, b) distribute by hash(b);
create table mlparted1 (b int not null, a int not null) distribute by modulo(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 13
create table mlparted (a int, b int) partition by range (a, b) distribute by replication;
create table mlparted1 (b int not null, a int not null) distribute by modulo(a);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 14
create table mlparted (a int, b int) partition by range (a, b) distribute by replication;
create table mlparted1 (b int not null, a int not null) distribute by replication;
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;

--testcase 15
create table mlparted (a int, b int) partition by range (a, b);
create table mlparted1 (a int not null, b int not null) to node (dn1);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);
drop table mlparted;
drop table mlparted1;
