#!/bin/sh

DUMP_FILE_DIR_NAME=dump_file_dir
DUMP_FILE_DIR_PATH=$(pwd)/dump-files
PAR_FILE_PATH=parameter-files
SQL_FILE_PATH=sql-files
SCRIPT_FILE_PATH=script-files
SOURCE_DB=TRPS
TARGET_DB=TRPSTEST

#Prepare the dump file directory

${SCRIPT_FILE_PATH}/prepare-dump-directory.sh ${DUMP_FILE_DIR_PATH}

#Run the pre-export actions on the source database.

sqlplus "sys/admin@${SOURCE_DB} as sysdba" @${SQL_FILE_PATH}/pre-export-actions.sql ${DUMP_FILE_DIR_NAME} ${DUMP_FILE_DIR_PATH}

#Export the schema objects from the source database.

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

#Run the pre schema import actions on the target database.

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/pre-schema-import-actions.sql ${DUMP_FILE_DIR_NAME} ${DUMP_FILE_DIR_PATH} ${TARGET_DB}

#Import the schema objects into target database.

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

#Run the post schema object import actions on target database.

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/post-schema-import-actions.sql

#Export schema data from the source database.

expdp \"sys/admin@${SOURCE_DB} as sysdba\" PARFILE=${PAR_FILE_PATH}/trps-data-export-cs-ttc.par

#Run the pre data import actions on the target database.

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/pre-data-import-actions.sql

#Import schema data into the target database.

impdp \"cs_ttc/cs_ttc@${TARGET_DB}\" PARFILE=${PAR_FILE_PATH}/trps-data-import-cs-ttc.par

#Run the post schema data import actions on target database.

sqlplus "sys/admin@${TARGET_DB} as sysdba" @${SQL_FILE_PATH}/post-data-import-actions.sql
