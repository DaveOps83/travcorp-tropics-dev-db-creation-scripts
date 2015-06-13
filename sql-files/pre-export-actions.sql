SET ECHO ON;

STARTUP;

CREATE OR REPLACE DIRECTORY &1 AS '&2';

ALTER USER prodn IDENTIFIED BY prodn;

ALTER USER custom_ttc IDENTIFIED BY custom_ttc;

ALTER USER cs_ttc IDENTIFIED BY cs_ttc;

ALTER USER rs_ttc IDENTIFIED BY rs_ttc;

ALTER USER pr_ttc IDENTIFIED BY pr_ttc;

ALTER USER op_ttc IDENTIFIED BY op_ttc;

ALTER USER sc_ttc IDENTIFIED BY sc_ttc;

ALTER USER itropics IDENTIFIED BY itropics;

EXIT;