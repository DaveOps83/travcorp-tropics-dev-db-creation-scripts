--Disable constraints
DECLARE
   CURSOR c_constraint_cur
   IS
      SELECT constraint_name, table_name, owner
        FROM dba_constraints
       WHERE owner = 'CS_TTC' AND constraint_type = 'C';

   CURSOR r_constraint_cur
   IS
      SELECT constraint_name, table_name, owner
        FROM dba_constraints
       WHERE owner = 'CS_TTC' AND constraint_type = 'R';

   CURSOR p_constraint_cur
   IS
      SELECT constraint_name, table_name, owner
        FROM dba_constraints
       WHERE owner = 'CS_TTC' AND constraint_type = 'P';


   v_disable_sql   VARCHAR2 (100);
BEGIN
   FOR cons IN c_constraint_cur
   LOOP
      v_disable_sql :=
            'ALTER TABLE '
         || cons.owner
         || '.'
         || cons.table_name
         || ' DISABLE CONSTRAINT '
         || cons.constraint_name
         || ' CASCADE';

      EXECUTE IMMEDIATE v_disable_sql;
   END LOOP;

   FOR cons IN r_constraint_cur
   LOOP
      v_disable_sql :=
            'ALTER TABLE '
         || cons.owner
         || '.'
         || cons.table_name
         || ' DISABLE CONSTRAINT '
         || cons.constraint_name
         || ' CASCADE';

      EXECUTE IMMEDIATE v_disable_sql;
   END LOOP;

   FOR cons IN p_constraint_cur
   LOOP
      v_disable_sql :=
            'ALTER TABLE '
         || cons.owner
         || '.'
         || cons.table_name
         || ' DISABLE CONSTRAINT '
         || cons.constraint_name
         || ' CASCADE';

      EXECUTE IMMEDIATE v_disable_sql;
   END LOOP;
END;
/

--Disable triggers
DECLARE
   CURSOR trigger_cur
   IS
      SELECT trigger_name, owner
        FROM dba_triggers
       WHERE owner = 'CS_TTC';

   v_disable_sql   VARCHAR2 (100);
BEGIN
   FOR trg IN trigger_cur
   LOOP
      v_disable_sql :=
            'ALTER TRIGGER '
         || trg.owner
         || '.'
         || trg.trigger_name
         || ' DISABLE';

      EXECUTE IMMEDIATE v_disable_sql;
   END LOOP;
END;

--Truncate tables
DECLARE
   CURSOR table_cur
   IS
      SELECT table_name, owner
        FROM dba_tables
       WHERE owner = 'CS_TTC';

   v_truncate_sql   VARCHAR2 (100);
BEGIN
   FOR tbl IN table_cur
   LOOP
      v_truncate_sql :=
         'TRUNCATE TABLE ' || tbl.owner || '.' || tbl.table_name;

      EXECUTE IMMEDIATE v_truncate_sql;
   END LOOP;
END;
/
EXIT;