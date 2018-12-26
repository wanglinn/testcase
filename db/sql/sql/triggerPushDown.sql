-- testcase 1

CREATE TABLE transition_table_base (id int PRIMARY KEY, id2 int);
INSERT INTO transition_table_base VALUES (1, 1);
INSERT INTO transition_table_base VALUES (2, 2);
INSERT INTO transition_table_base VALUES (3, 2);

CREATE OR REPLACE FUNCTION transition_table_base_upd_func()
  RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  t text;
  l text;
BEGIN
  t = '';
  FOR l IN EXECUTE
           $q$
             SELECT id2 FROM oldtable;
           $q$ LOOP
    t = t || l || E'\n';
  END LOOP;

  RAISE INFO '%', t;
  RETURN new;
END;
$$;

-- after delete oldtable
CREATE TRIGGER transition_table_base_upd_trig
  AFTER DELETE ON transition_table_base 
  REFERENCING OLD TABLE AS oldtable
  FOR EACH STATEMENT
  EXECUTE PROCEDURE transition_table_base_upd_func();

 explain verbose delete from transition_table_base where id=1;
 
 delete from transition_table_base where id=1;
  
 drop table transition_table_base  cascade;
 drop function transition_table_base_upd_func();

 
 
 -- testcase 2
 
CREATE TABLE transition_table_base (id int PRIMARY KEY, id2 int);
INSERT INTO transition_table_base VALUES (1, 1);
INSERT INTO transition_table_base VALUES (2, 2);
INSERT INTO transition_table_base VALUES (3, 2);

CREATE OR REPLACE FUNCTION transition_table_base_upd_func()
  RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  t text;
  l text;
BEGIN
  t = '';
  FOR l IN EXECUTE
           $q$
             SELECT id2 FROM oldtable;
           $q$ LOOP
    t = t || l || E'\n';
  END LOOP;

  RAISE INFO '%', t;
  RETURN new;
END;
$$;

-- after update oldtable
CREATE TRIGGER transition_table_base_upd_trig
  AFTER UPDATE ON transition_table_base 
  REFERENCING OLD TABLE AS oldtable
  FOR EACH STATEMENT
  EXECUTE PROCEDURE transition_table_base_upd_func();

 explain verbose update transition_table_base  set id2=3 where id2=3;
 
  update transition_table_base  set id2=3 where id2=3;
 
 drop table transition_table_base  cascade;
 drop function transition_table_base_upd_func();
 
 
 -- testcase 3

CREATE TABLE transition_table_base (id int PRIMARY KEY, id2 int);
INSERT INTO transition_table_base VALUES (1, 1);
INSERT INTO transition_table_base VALUES (2, 2);
INSERT INTO transition_table_base VALUES (3, 2);

CREATE OR REPLACE FUNCTION transition_table_base_upd_func()
  RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  t text;
  l text;
BEGIN
  t = '';
  FOR l IN EXECUTE
           $q$
             SELECT id2 FROM newtable;
           $q$ LOOP
    t = t || l || E'\n';
  END LOOP;

  RAISE INFO '%', t;
  RETURN new;
END;
$$;

-- after insert newtable
CREATE TRIGGER transition_table_base_upd_trig
  AFTER INSERT ON transition_table_base 
  REFERENCING NEW TABLE AS newtable
  FOR EACH STATEMENT
  EXECUTE PROCEDURE transition_table_base_upd_func();

 explain verbose insert into transition_table_base  values(5,5);
 
insert into transition_table_base  values(5,5);
  
 drop table transition_table_base  cascade;
 drop function transition_table_base_upd_func();

 
 
 -- testcase 4
 
CREATE TABLE transition_table_base (id int PRIMARY KEY, id2 int);
INSERT INTO transition_table_base VALUES (1, 1);
INSERT INTO transition_table_base VALUES (2, 2);
INSERT INTO transition_table_base VALUES (3, 2);

CREATE OR REPLACE FUNCTION transition_table_base_upd_func()
  RETURNS trigger
  LANGUAGE plpgsql
AS $$
DECLARE
  t text;
  l text;
BEGIN
  t = '';
  FOR l IN EXECUTE
           $q$
             SELECT id2 FROM newtable;
           $q$ LOOP
    t = t || l || E'\n';
  END LOOP;

  RAISE INFO '%', t;
  RETURN new;
END;
$$;

-- after update newtable
CREATE TRIGGER transition_table_base_upd_trig
  AFTER UPDATE ON transition_table_base 
  REFERENCING NEW TABLE AS newtable
  FOR EACH STATEMENT
  EXECUTE PROCEDURE transition_table_base_upd_func();

 explain verbose update transition_table_base  set id2=3 where id2=3;
 
  update transition_table_base  set id2=3 where id2=3;
 
 drop table transition_table_base  cascade;
 drop function transition_table_base_upd_func();
 

