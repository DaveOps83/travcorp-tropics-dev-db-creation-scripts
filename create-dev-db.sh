#!/bin/sh

DUMP_FILE_DIR_NAME=dump_file_dir
DUMP_FILE_DIR_PATH=$(pwd)/dump-files
PAR_FILE_PATH=parameter-files
SQL_FILE_PATH=sql-files
SCRIPT_FILE_PATH=script-files
SOURCE_DB=TRPS
TARGET_DB=TRPSTEST

#Prepare dump directory

${SCRIPT_FILE_PATH}/prepare-dump-directory.sh ${DUMP_FILE_DIR_PATH}

#Prepare source DB

sqlplus "sys/admin@${SOURCE_DB} as sysdba" @${SQL_FILE_PATH}/prepare-source-database.sql ${DUMP_FILE_DIR_NAME} ${DUMP_FILE_DIR_PATH}

#Export database objects from source DB

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-tables-export.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-public-synonyms-export.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-prodn.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-custom-ttc.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-cs-ttc.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-rs-ttc.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-pr-ttc.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-op-ttc.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-sc-ttc.par

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-code-export-itropics.par

#Prepare target DB

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/prepare-target-database.sql ${DUMP_FILE_DIR_NAME} ${DUMP_FILE_DIR_PATH} ${TARGET_DB}

#Import database objects into target DB

impdp \"sys/admin@${TARGET_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-tables-import.par

impdp \"sys/admin@${TARGET_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-public-synonyms-import.par

impdp \"prodn/prodn@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-prodn.par

impdp \"custom_ttc/custom_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-custom-ttc.par

impdp \"cs_ttc/cs_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-cs-ttc.par

impdp \"rs_ttc/rs_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-rs-ttc.par

impdp \"pr_ttc/pr_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-pr-ttc.par

impdp \"op_ttc/op_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-op-ttc.par

impdp \"sc_ttc/sc_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-sc-ttc.par

impdp \"itropics/itropics@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-code-import-itropics.par

#Run post import actions on target DB

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/post-creation-actions.sql

#Export data from source DB

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-data-export-cs-ttc.par

#Prepare target DB for data import

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/pre-data-import-actions.sql

#Import data into target DB

impdp \"cs_ttc/cs_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-data-import-cs-ttc.par

#Run post data import actions on target DB

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/post-data-import-actions.sql
