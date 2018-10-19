-- https://www.postgresql.org/docs/10/static/plpgsql-cursors.html
--
--

--create table and index
drop table if exists cursor_t1 cascade;
create table cursor_t1(id1 int, id2 int);
insert into cursor_t1 select generate_series(1,10000), generate_series(10000, 1, -1);
create index i_cursor_t1 on cursor_t1(id1);
-- 1
begin;
DECLARE c1  CURSOR FOR SELECT * from cursor_t1 WHERE id1 %2 !=0 order by 1,2;
fetch 4 from c1;
MOVE FORWARD ALL FROM c1;
fetch 2 from c1;
MOVE BACKWARD ALL FROM c1;
fetch 3 from c1;
MOVE BACKWARD ALL FROM c1;
MOVE BACKWARD ALL FROM c1;
MOVE FORWARD 10 FROM c1;
fetch 4 from c1;
MOVE BACKWARD 100000 FROM c1;
fetch 4 from c1;
commit;

-- 2
begin;
DECLARE c1  SCROLL CURSOR FOR SELECT * from cursor_t1 WHERE id1 %2 !=0 order by 1,2;
fetch 4 from c1;
MOVE FORWARD ALL FROM c1;
fetch 2 from c1;
MOVE BACKWARD ALL FROM c1;
fetch 3 from c1;
MOVE BACKWARD ALL FROM c1;
MOVE BACKWARD ALL FROM c1;
MOVE FORWARD 10 FROM c1;
fetch 4 from c1;
MOVE BACKWARD 100000 FROM c1;
fetch 4 from c1;
commit;

-- 3
begin;
DECLARE c1  NO SCROLL CURSOR FOR SELECT * from cursor_t1 WHERE id1 %2 !=0 order by 1,2;
fetch 4 from c1;
MOVE FORWARD ALL FROM c1;
fetch 2 from c1;
MOVE BACKWARD ALL FROM c1;
fetch 3 from c1;
MOVE BACKWARD ALL FROM c1;
MOVE BACKWARD ALL FROM c1;
MOVE FORWARD 10 FROM c1;
fetch 4 from c1;
MOVE BACKWARD 100000 FROM c1;
fetch 4 from c1;
commit;

-- 4
begin;
DECLARE c1  SCROLL CURSOR FOR SELECT * from cursor_t1 WHERE id1 %2 !=0 order by 1,2;
fetch 4 from c1;
MOVE FORWARD ALL FROM c1;
fetch 2 from c1;
MOVE BACKWARD ALL FROM c1;
fetch 3 from c1;
MOVE BACKWARD ALL FROM c1;
MOVE BACKWARD ALL FROM c1;
MOVE FORWARD 10 FROM c1;
fetch 4 from c1;
MOVE BACKWARD 100000 FROM c1;
fetch 4 from c1;
commit;

-- drop node
drop table cursor_t1 cascade;
