-- test case 1
create table pt (a int,b char, c date) partition by range(a);
create table pt1(b char, c date, a int) partition by range(a);
create table pt2 (c date, a int,b char) partition by range(a);

alter table pt attach partition pt1 for values from (1) to (11);
alter table pt attach partition pt2 for values from (11) to (21);


create table pt11(c date, a int,b char);
create table pt12(b char, c date, a int);
alter table pt1 attach partition pt11 for values from (1) to (5);
alter table pt2 attach partition pt12 for values from (11) to (15);
--create table pt11 partition of pt1 for values from (1) to (5);
--create table pt12 partition of pt2 for values from (11) to (15);

create view ptv as select * from pt;

insert into ptv values(1,'2', '2018-10-28');
insert into ptv values(11,'2', '2018-10-28');

select * from pt;
select * from pt1;
select * from pt2;
select * from pt11;
select * from pt12;

insert into ptv values(6,'2', '2018-10-28');
insert into ptv values(16,'2', '2018-10-28');

drop table pt cascade;

--test case 2
create table pt (a int,b char, c date, d text) partition by list(d);
create table pt1(b char, c date, d text, a int) partition by list(d);
create table pt2 (c date, d text, a int,b char) partition by list(d);

alter table pt attach partition pt1 for values in ('pt1');
alter table pt attach partition pt2 for values in ('pt2');

create table pt11(c date, d text, a int,b char);
create table pt12(b char, c date, d text, a int);
alter table pt1 attach partition pt11 for values in ('pt1');
alter table pt2 attach partition pt12 for values in ('pt2');
--create table pt11 partition of pt1 for values in ('pt1');
--create table pt12 partition of pt2 for values in ('pt2');

create view ptv as select * from pt;

insert into ptv values(1,'2', '2018-10-28', 'pt1');
insert into ptv values(6,'2', '2018-10-28', 'pt2');

select * from pt;
select * from pt1;
select * from pt2;
select * from pt11;
select * from pt12;

drop table pt cascade;
