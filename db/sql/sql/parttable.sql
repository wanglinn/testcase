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
drop table if exists pt1;
drop table if exists pt2;
drop table if exists pt11;
drop table if exists pt12;

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
create view ptv as select * from pt;

insert into ptv values(1,'2', '2018-10-28', 'pt1');
insert into ptv values(6,'2', '2018-10-28', 'pt2');

select * from pt;
select * from pt1;
select * from pt2;
select * from pt11;
select * from pt12;

drop table pt cascade;
drop table if exists pt1;
drop table if exists pt2;
drop table if exists pt11;
drop table if exists pt12;

-- test case 3
create table mlparted (a int, b int) partition by range (b);
create table mlparted1 (b int not null, a int not null) partition by range (b);
create table mlparted11 (like mlparted1);
alter table mlparted11 drop a;
alter table mlparted11 add a int;
alter table mlparted11 drop a;
alter table mlparted11 add a int not null;
alter table mlparted1 attach partition mlparted11 for values from (1) to (5);
alter table mlparted attach partition mlparted1 for values from (1) to (10);
with ins (a, b, c) as
  (insert into mlparted (b, a) select 2 , 1  returning 3, *)
  select * from ins; 

drop table mlparted cascade;
drop table if exists mlparted1;
drop table if exists mlparted11;

-- test case 4
create table mlparted (a int, b int) partition by range (b);
create table mlparted1 (b int not null, a int not null);
alter table mlparted1 drop a;
alter table mlparted1 add a int;
alter table mlparted1 drop a;
alter table mlparted1 add a int not null;
alter table mlparted attach partition mlparted1 for values from (1) to (5);
with ins (a, b, c) as
  (insert into mlparted (b, a) select 2 , 1  returning 3, *)
  select * from ins; 
drop table mlparted cascade;
drop table if exists mlparted1;
drop table if exists mlparted11;

--test case 5
create table mlparted (a int, b int) partition by range (b);
create table mlparted1 (a int, b int);
alter table mlparted1 drop a;
alter table mlparted1 add a int;
alter table mlparted1 drop a;
alter table mlparted1 add a int;
alter table mlparted attach partition mlparted1 for values from (1) to (5);
with ins (a, b, c) as
  (insert into mlparted (b, a) select 2 , 1  returning 3, *)
  select * from ins;
 
drop table mlparted cascade;
drop table if exists mlparted1;
drop table if exists mlparted11;

-- test case 6
create table mlparted (a int, b int) partition by range (b);
create table mlparted1 (b int, a int);
alter table mlparted1 drop a;
alter table mlparted1 add a int;
alter table mlparted1 drop a;
alter table mlparted1 add a int;
alter table mlparted attach partition mlparted1 for values from (1) to (5);
with ins (a, b, c) as
  (insert into mlparted (b, a) select 2 , 1  returning 3, *)
  select * from ins;  

with ins (a) as      
  (insert into mlparted (b, a) select 2 , 1  returning 3)   
  select * from ins;

drop table mlparted cascade;
drop table if exists mlparted1;
drop table if exists mlparted11;

-- test case 7
create table mlparted (a int, b int) partition by range (a, b);
create table mlparted1 (b int not null, a int not null) partition by range ((b+0));
create table mlparted11 (like mlparted1);

alter table mlparted1 attach partition mlparted11 for values from (2) to (5);
alter table mlparted attach partition mlparted1 for values from (1, 2) to (1, 10);

-- have a BR trigger modify the row such that the check_b is violated
create function mlparted11_trig_fn()
returns trigger AS
$$
begin
  NEW.b := 4;
  return NEW;
end;
$$
language plpgsql;

create trigger mlparted11_trig before insert ON mlparted11
  for each row execute procedure mlparted11_trig_fn();

insert into mlparted values (1, 2);
select * from mlparted;

drop table mlparted cascade;
drop table if exists mlparted1;
drop table if exists mlparted11;

drop function mlparted11_trig_fn();
