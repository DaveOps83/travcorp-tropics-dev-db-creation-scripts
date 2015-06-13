--Enable constraints
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

   v_enable_sql   VARCHAR2 (100);
BEGIN
   FOR cons IN p_constraint_cur
   LOOP
      v_enable_sql :=
            'ALTER TABLE '
         || cons.owner
         || '.'
         || cons.table_name
         || ' ENABLE CONSTRAINT '
         || cons.constraint_name;

      EXECUTE IMMEDIATE v_enable_sql;
   END LOOP;

   FOR cons IN r_constraint_cur
   LOOP
      v_enable_sql :=
            'ALTER TABLE '
         || cons.owner
         || '.'
         || cons.table_name
         || ' ENABLE CONSTRAINT '
         || cons.constraint_name;

      EXECUTE IMMEDIATE v_enable_sql;
   END LOOP;

   FOR cons IN c_constraint_cur
   LOOP
      v_enable_sql :=
            'ALTER TABLE '
         || cons.owner
         || '.'
         || cons.table_name
         || ' ENABLE CONSTRAINT '
         || cons.constraint_name;

      EXECUTE IMMEDIATE v_enable_sql;
   END LOOP;
END;
/

--Enable triggers
DECLARE
   CURSOR trigger_cur
   IS
      SELECT trigger_name, owner
        FROM dba_triggers
       WHERE owner = 'CS_TTC';

   v_enable_sql   VARCHAR2 (100);
BEGIN
   FOR trg IN trigger_cur
   LOOP
      v_disable_sql :=
            'ALTER TRIGGER '
         || trg.owner
         || '.'
         || trg.trigger_name
         || ' ENABLE';

      EXECUTE IMMEDIATE v_enable_sql;
   END LOOP;
END;
/
EXIT;