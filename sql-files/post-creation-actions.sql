--Recompile all PL/SQL objects
BEGIN
   UTL_RECOMP.recomp_parallel (5);
END;
/

--Check for any invalid objects
SELECT a.owner, a.object_name, a.status
  FROM all_objects a
 WHERE a.status != 'VALID';

--Drop all auditing triggers
DECLARE
   CURSOR trigger_cur
   IS
      SELECT trigger_name, owner
        FROM dba_triggers
       WHERE owner = 'CS_TTC' AND table_name LIKE '%_AUD';

   v_drop_sql   VARCHAR2 (100);
BEGIN
   FOR trg IN trigger_cur
   LOOP
      v_drop_sql := 'DROP TRIGGER ' || trg.owner || '.' || trg.trigger_name;

      EXECUTE IMMEDIATE v_drop_sql;
   END LOOP;
END;
/

--Drop all auditing and backup tables
DECLARE
   CURSOR table_cur
   IS
      SELECT table_name, owner
        FROM dba_tables
       WHERE     owner = 'CS_TTC'
             AND (table_name LIKE '%_AUD' OR table_name LIKE '%_BACKUP');

   v_drop_sql   VARCHAR2 (100);
BEGIN
   FOR tbl IN table_cur
   LOOP
      v_drop_sql := 'DROP TABLE ' || tbl.owner || '.' || tbl.table_name;

      EXECUTE IMMEDIATE v_drop_sql;
   END LOOP;
END;
/
EXIT;