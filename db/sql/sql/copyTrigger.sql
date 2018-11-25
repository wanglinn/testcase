--  part table
--

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
drop function if exists tgcptbl_func();


-- testcase 2: after insert for each row

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
drop function if exists tgcptbl_func();


-- testcase 3: before insert for each statement

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
drop function if exists tgcptbl_func();

-- testcase 4: after insert for each statement

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
drop function if exists tgcptbl_func();

-- no part table

-- testcase 1      before insert
CREATE TABLE emp (
    a int,
	b int
);


CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
        NEW.a := NEW.a+10;
        NEW.b := NEW.b+10;
		raise notice 'b: %', new.b;
        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;


CREATE TRIGGER emp_stamp BEFORE INSERT ON emp
    FOR EACH ROW EXECUTE PROCEDURE emp_stamp();

insert into emp values(1,2);
copy emp from stdout;
3	4
\.

select * from emp;
drop table emp;
drop function if exists emp_stamp();


-- testcase 2      after insert

CREATE TABLE emp (
    a int,
	b int
);

CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
        NEW.a := NEW.a+10;
        NEW.b := NEW.b+10;
		raise notice 'b: %', new.b;
        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;


CREATE TRIGGER emp_stamp AFTER insert ON emp
    FOR EACH ROW EXECUTE PROCEDURE emp_stamp();

insert into emp values(1,2);
copy emp from stdout;
3	4
\.

select * from emp;
drop table emp;
drop function if exists emp_stamp();


-- testcase 3      before statement

CREATE TABLE emp (
    a int,
	b int
);

CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
		raise notice 'b: %', 2;
        RETURN NULL;
    END;
$emp_stamp$ LANGUAGE plpgsql;


CREATE TRIGGER emp_stamp BEFORE insert ON emp
    FOR EACH statement EXECUTE PROCEDURE emp_stamp();

insert into emp values(1,2);
copy emp from stdout;
3	4
\.

select * from emp;
drop table emp;
drop function if exists emp_stamp();

-- testcase 4      after statement

CREATE TABLE emp (
    a int,
	b int
);

CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
		raise notice 'b: %', 2;
        RETURN NULL;
    END;
$emp_stamp$ LANGUAGE plpgsql;


CREATE TRIGGER emp_stamp AFTER insert ON emp
    FOR EACH statement EXECUTE PROCEDURE emp_stamp();

insert into emp values(1,2);
copy emp from stdout;
3	4
\.

select * from emp;
drop table emp;
drop function if exists emp_stamp();


-- testcase 5      before statement error

CREATE TABLE emp (
    a int,
	b int
);

CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
		raise notice 'b: %', NEW.b;
        RETURN NULL;
    END;
$emp_stamp$ LANGUAGE plpgsql;


CREATE TRIGGER emp_stamp BEFORE insert ON emp
    FOR EACH statement EXECUTE PROCEDURE emp_stamp();

insert into emp values(1,2);
copy emp from stdout;
3	4
\.

select * from emp;
drop table emp;
drop function if exists emp_stamp();

-- testcase 6      after statement error

CREATE TABLE emp (
    a int,
	b int
);

CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
		raise notice 'b: %', NEW.b;
        RETURN NULL;
    END;
$emp_stamp$ LANGUAGE plpgsql;


CREATE TRIGGER emp_stamp AFTER insert ON emp
    FOR EACH statement EXECUTE PROCEDURE emp_stamp();

insert into emp values(1,2);
copy emp from stdout;
3	4
\.

select * from emp;
drop table emp;
drop function if exists emp_stamp();
