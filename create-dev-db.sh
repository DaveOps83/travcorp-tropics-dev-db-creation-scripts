#!/bin/sh

DUMP-FILE-DIR-NAME=dump-file-dir
DUMP-FILE-DIR-PATH=dump-files
PAR-FILE-PATH=parameter-files
SQL-FILE-PATH=sql-files
SCRIPT-FILE-PATH=script-files
SOURCE-DB=TRPS
TARGET-DB=TRPSTEST

#Prepare dump directory

${SCRIPT-FILE-PATH}/prepare_dump_directory.sh ${DUMP-FILE-DIR-PATH}

#Prepare source DB

sqlplus "sys/admin@${SOURCE-DB} as sysdba" @${SQL-FILE-PATH}/prepare_source_database.sql ${DUMP-FILE-DIR-NAME} ${DUMP-FILE-DIR-PATH}

#Export database objects from source DB

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_tables_export.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_public_synonyms_export.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_prodn.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_custom_ttc.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_cs_ttc.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_rs_ttc.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_pr_ttc.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_op_ttc.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_sc_ttc.par

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_code_export_itropics.par

#Prepare target DB

sqlplus "sys/admin@${TARGET-DB} as sysdba" @${SQL-FILE-PATH}/prepare_target_database.sql ${DUMP-FILE-DIR-NAME} ${DUMP-FILE-DIR-PATH} ${TARGET-DB}

#Import database objects into target DB

impdp \"sys/admin@${TARGET-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_tables_import.par

impdp \"sys/admin@${TARGET-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_public_synonyms_import.par

impdp \"prodn/prodn@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_prodn.par

impdp \"custom_ttc/custom_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_custom_ttc.par

impdp \"cs_ttc/cs_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_cs_ttc.par

impdp \"rs_ttc/rs_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_rs_ttc.par

impdp \"pr_ttc/pr_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_pr_ttc.par

impdp \"op_ttc/op_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_op_ttc.par

impdp \"sc_ttc/sc_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_sc_ttc.par

impdp \"itropics/itropics@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_code_import_itropics.par

#Run post import actions on target DB

sqlplus "sys/admin@${TARGET-DB} as sysdba" @${SQL-FILE-PATH}/post_creation_actions.sql

#Export data from source DB

expdp \"sys/admin@${SOURCE-DB} as sysdba\" PARFILE=${PAR-FILE-PATH}/trps_data_export_cs_ttc.par

#Prepare target DB for data import

sqlplus "sys/admin@${TARGET-DB} as sysdba" @${SQL-FILE-PATH}/pre_data_import_actions.sql

#Import data into target DB

impdp \"cs_ttc/cs_ttc@${TARGET-DB}\" PARFILE=${PAR-FILE-PATH}/trps_data_import_cs_ttc.par

#Run post data import actions on target DB

sqlplus "sys/admin@${TARGET-DB} as sysdba" @${SQL-FILE-PATH}/post_data_import_actions.sql