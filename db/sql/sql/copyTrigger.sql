-- testcase 1 : before insert   for each row

create table test (a int, b text) partition by list (a);
create table test_1 (a int, b text);
create table test_2 (a int, b text);

create or replace function tgcptbl_func() returns trigger as $$begin raise notice 'b: %', new.b; return NULL; end$$ language plpgsql;
create trigger tg1 before insert on test_1 for each row execute procedure tgcptbl_func();
create trigger tg2 before insert on test_2 for each row execute procedure tgcptbl_func();
alter table test attach partition test_1 for values in (1);
alter table test attach partition test_2 for values in (2);
insert into test values (1, 'foo'), (2, 'bar');

copy test from stdout;
1	a
2	b
\.
select * from test;
select * from test_1;
select * from test_2;
drop table test cascade;



-- test case 2: after insert for each row

create table test (a int, b text) partition by list (a);
create table test_1 (a int, b text);
create table test_2 (a int, b text);

create or replace function tgcptbl_func() returns trigger as $$begin raise notice 'b: %', new.b; return NULL; end$$ language plpgsql;
create trigger tg1 after insert on test_1 for each row execute procedure tgcptbl_func();
create trigger tg2 after insert on test_2 for each row execute procedure tgcptbl_func();
alter table test attach partition test_1 for values in (1);
alter table test attach partition test_2 for values in (2);
insert into test values (1, 'foo'), (2, 'bar');

copy test from stdout;
1	a
2	b
\.
select * from test;
select * from test_1;
select * from test_2;
drop table test cascade;



-- test case 3: before insert for each statement

create table test (a int, b text) partition by list (a);
create table test_1 (a int, b text);
create table test_2 (a int, b text);

create or replace function tgcptbl_func() returns trigger as $$begin raise notice 'b: %', new.b; return NULL; end$$ language plpgsql;
create trigger tg1 before insert on test_1 for each statement execute procedure tgcptbl_func();
create trigger tg2 before insert on test_2 for each statement execute procedure tgcptbl_func();
alter table test attach partition test_1 for values in (1);
alter table test attach partition test_2 for values in (2);
insert into test values (1, 'foo'), (2, 'bar');

copy test from stdout;
1	a
2	b
\.
select * from test;
select * from test_1;
select * from test_2;
drop table test cascade;


-- test case 4: after insert for each statement

create table test (a int, b text) partition by list (a);
create table test_1 (a int, b text);
create table test_2 (a int, b text);

create or replace function tgcptbl_func() returns trigger as $$begin raise notice 'b: %', new.b; return NULL; end$$ language plpgsql;
create trigger tg1 after insert on test_1 for each statement execute procedure tgcptbl_func();
create trigger tg2 after insert on test_2 for each statement execute procedure tgcptbl_func();
alter table test attach partition test_1 for values in (1);
alter table test attach partition test_2 for values in (2);
insert into test values (1, 'foo'), (2, 'bar');

copy test from stdout;
1	a
2	b
\.
select * from test;
select * from test_1;
select * from test_2;
drop table test cascade;

