-- csv2mysql with arguments:
--   -o
--   1-define.sql
--   -u
--   -k
--   -p
--   -z
--   ADMISSIONS.csv
--   CALLOUT.csv
--   CAREGIVERS.csv
--   CHARTEVENTS.csv
--   CPTEVENTS.csv
--   DATETIMEEVENTS.csv
--   DIAGNOSES_ICD.csv
--   DRGCODES.csv
--   D_CPT.csv
--   D_ICD_DIAGNOSES.csv
--   D_ICD_PROCEDURES.csv
--   D_ITEMS.csv
--   D_LABITEMS.csv
--   ICUSTAYS.csv
--   INPUTEVENTS_CV.csv
--   INPUTEVENTS_MV.csv
--   LABEVENTS.csv
--   MICROBIOLOGYEVENTS.csv
--   NOTEEVENTS.csv
--   OUTPUTEVENTS.csv
--   PATIENTS.csv
--   PRESCRIPTIONS.csv
--   PROCEDUREEVENTS_MV.csv
--   PROCEDURES_ICD.csv
--   SERVICES.csv
--   TRANSFERS.csv
CREATE SCHEMA IF NOT EXISTS mimiciiiv14 COLLATE utf8mb4_0900_ai_ci;

USE mimiciiiv14;

DROP TABLE IF EXISTS ADMISSIONS;
CREATE TABLE ADMISSIONS (	-- rows=58976
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   ADMITTIME DATETIME NOT NULL,
   DISCHTIME DATETIME NOT NULL,
   DEATHTIME DATETIME,
   ADMISSION_TYPE VARCHAR(50) NOT NULL,	-- max=9
   ADMISSION_LOCATION VARCHAR(50) NOT NULL,	-- max=25
   DISCHARGE_LOCATION VARCHAR(50) NOT NULL,	-- max=25
   INSURANCE VARCHAR(255) NOT NULL,	-- max=10
   LANGUAGE VARCHAR(10),	-- max=4
   RELIGION VARCHAR(50),	-- max=22
   MARITAL_STATUS VARCHAR(50),	-- max=17
   ETHNICITY VARCHAR(200) NOT NULL,	-- max=56
   EDREGTIME DATETIME,
   EDOUTTIME DATETIME,
   DIAGNOSIS VARCHAR(255),	-- max=189
   HOSPITAL_EXPIRE_FLAG TINYINT UNSIGNED NOT NULL,
   HAS_CHARTEVENTS_DATA TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY ADMISSIONS_HADM_ID (HADM_ID)	-- nvals=58976
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'ADMISSIONS.csv' INTO TABLE ADMISSIONS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ADMITTIME,@DISCHTIME,@DEATHTIME,@ADMISSION_TYPE,@ADMISSION_LOCATION,@DISCHARGE_LOCATION,@INSURANCE,@LANGUAGE,@RELIGION,@MARITAL_STATUS,@ETHNICITY,@EDREGTIME,@EDOUTTIME,@DIAGNOSIS,@HOSPITAL_EXPIRE_FLAG,@HAS_CHARTEVENTS_DATA)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   ADMITTIME = @ADMITTIME,
   DISCHTIME = @DISCHTIME,
   DEATHTIME = IF(@DEATHTIME='', NULL, @DEATHTIME),
   ADMISSION_TYPE = @ADMISSION_TYPE,
   ADMISSION_LOCATION = @ADMISSION_LOCATION,
   DISCHARGE_LOCATION = @DISCHARGE_LOCATION,
   INSURANCE = @INSURANCE,
   LANGUAGE = IF(@LANGUAGE='', NULL, @LANGUAGE),
   RELIGION = IF(@RELIGION='', NULL, @RELIGION),
   MARITAL_STATUS = IF(@MARITAL_STATUS='', NULL, @MARITAL_STATUS),
   ETHNICITY = @ETHNICITY,
   EDREGTIME = IF(@EDREGTIME='', NULL, @EDREGTIME),
   EDOUTTIME = IF(@EDOUTTIME='', NULL, @EDOUTTIME),
   DIAGNOSIS = IF(@DIAGNOSIS='', NULL, @DIAGNOSIS),
   HOSPITAL_EXPIRE_FLAG = @HOSPITAL_EXPIRE_FLAG,
   HAS_CHARTEVENTS_DATA = @HAS_CHARTEVENTS_DATA;

DROP TABLE IF EXISTS CALLOUT;
CREATE TABLE CALLOUT (	-- rows=34499
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   SUBMIT_WARDID TINYINT UNSIGNED,
   SUBMIT_CAREUNIT VARCHAR(15),	-- max=5
   CURR_WARDID TINYINT UNSIGNED,
   CURR_CAREUNIT VARCHAR(15),	-- max=5
   CALLOUT_WARDID TINYINT UNSIGNED NOT NULL,
   CALLOUT_SERVICE VARCHAR(10) NOT NULL,	-- max=5
   REQUEST_TELE TINYINT UNSIGNED NOT NULL,
   REQUEST_RESP TINYINT UNSIGNED NOT NULL,
   REQUEST_CDIFF TINYINT UNSIGNED NOT NULL,
   REQUEST_MRSA TINYINT UNSIGNED NOT NULL,
   REQUEST_VRE TINYINT UNSIGNED NOT NULL,
   CALLOUT_STATUS VARCHAR(20) NOT NULL,	-- max=8
   CALLOUT_OUTCOME VARCHAR(20) NOT NULL,	-- max=10
   DISCHARGE_WARDID TINYINT UNSIGNED,
   ACKNOWLEDGE_STATUS VARCHAR(20) NOT NULL,	-- max=14
   CREATETIME DATETIME NOT NULL,
   UPDATETIME DATETIME NOT NULL,
   ACKNOWLEDGETIME DATETIME,
   OUTCOMETIME DATETIME NOT NULL,
   FIRSTRESERVATIONTIME DATETIME,
   CURRENTRESERVATIONTIME DATETIME,
  UNIQUE KEY CALLOUT_CURRENTRESERVATIONTIME (CURRENTRESERVATIONTIME)	-- nvals=1164
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'CALLOUT.csv' INTO TABLE CALLOUT
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@SUBMIT_WARDID,@SUBMIT_CAREUNIT,@CURR_WARDID,@CURR_CAREUNIT,@CALLOUT_WARDID,@CALLOUT_SERVICE,@REQUEST_TELE,@REQUEST_RESP,@REQUEST_CDIFF,@REQUEST_MRSA,@REQUEST_VRE,@CALLOUT_STATUS,@CALLOUT_OUTCOME,@DISCHARGE_WARDID,@ACKNOWLEDGE_STATUS,@CREATETIME,@UPDATETIME,@ACKNOWLEDGETIME,@OUTCOMETIME,@FIRSTRESERVATIONTIME,@CURRENTRESERVATIONTIME)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   SUBMIT_WARDID = IF(@SUBMIT_WARDID='', NULL, @SUBMIT_WARDID),
   SUBMIT_CAREUNIT = IF(@SUBMIT_CAREUNIT='', NULL, @SUBMIT_CAREUNIT),
   CURR_WARDID = IF(@CURR_WARDID='', NULL, @CURR_WARDID),
   CURR_CAREUNIT = IF(@CURR_CAREUNIT='', NULL, @CURR_CAREUNIT),
   CALLOUT_WARDID = @CALLOUT_WARDID,
   CALLOUT_SERVICE = @CALLOUT_SERVICE,
   REQUEST_TELE = @REQUEST_TELE,
   REQUEST_RESP = @REQUEST_RESP,
   REQUEST_CDIFF = @REQUEST_CDIFF,
   REQUEST_MRSA = @REQUEST_MRSA,
   REQUEST_VRE = @REQUEST_VRE,
   CALLOUT_STATUS = @CALLOUT_STATUS,
   CALLOUT_OUTCOME = @CALLOUT_OUTCOME,
   DISCHARGE_WARDID = IF(@DISCHARGE_WARDID='', NULL, @DISCHARGE_WARDID),
   ACKNOWLEDGE_STATUS = @ACKNOWLEDGE_STATUS,
   CREATETIME = @CREATETIME,
   UPDATETIME = @UPDATETIME,
   ACKNOWLEDGETIME = IF(@ACKNOWLEDGETIME='', NULL, @ACKNOWLEDGETIME),
   OUTCOMETIME = @OUTCOMETIME,
   FIRSTRESERVATIONTIME = IF(@FIRSTRESERVATIONTIME='', NULL, @FIRSTRESERVATIONTIME),
   CURRENTRESERVATIONTIME = IF(@CURRENTRESERVATIONTIME='', NULL, @CURRENTRESERVATIONTIME);

DROP TABLE IF EXISTS CAREGIVERS;
CREATE TABLE CAREGIVERS (	-- rows=7567
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   CGID SMALLINT UNSIGNED NOT NULL,
   LABEL VARCHAR(15),	-- max=6
   DESCRIPTION VARCHAR(30),	-- max=21
  UNIQUE KEY CAREGIVERS_CGID (CGID)	-- nvals=7567
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'CAREGIVERS.csv' INTO TABLE CAREGIVERS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@CGID,@LABEL,@DESCRIPTION)
 SET
   ROW_ID = @ROW_ID,
   CGID = @CGID,
   LABEL = IF(@LABEL='', NULL, @LABEL),
   DESCRIPTION = IF(@DESCRIPTION='', NULL, @DESCRIPTION);

DROP TABLE IF EXISTS CHARTEVENTS;
CREATE TABLE CHARTEVENTS (	-- rows=263201375
   ROW_ID INT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   ITEMID MEDIUMINT UNSIGNED NOT NULL,
   CHARTTIME DATETIME NOT NULL,
   STORETIME DATETIME,
   CGID SMALLINT UNSIGNED,
   VALUE TEXT,	-- max=91
   VALUENUM DECIMAL(30, 23),
   VALUEUOM VARCHAR(50),	-- max=17
   WARNING TINYINT UNSIGNED,
   ERROR TINYINT UNSIGNED,
   RESULTSTATUS VARCHAR(50),	-- max=6
   STOPPED VARCHAR(50)	-- max=8
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'CHARTEVENTS.csv' INTO TABLE CHARTEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@ITEMID,@CHARTTIME,@STORETIME,@CGID,@VALUE,@VALUENUM,@VALUEUOM,@WARNING,@ERROR,@RESULTSTATUS,@STOPPED)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   ITEMID = @ITEMID,
   CHARTTIME = @CHARTTIME,
   STORETIME = IF(@STORETIME='', NULL, @STORETIME),
   CGID = IF(@CGID='', NULL, @CGID),
   VALUE = IF(@VALUE='', NULL, @VALUE),
   VALUENUM = IF(@VALUENUM='', NULL, @VALUENUM),
   VALUEUOM = IF(@VALUEUOM='', NULL, @VALUEUOM),
   WARNING = IF(@WARNING='', NULL, @WARNING),
   ERROR = IF(@ERROR='', NULL, @ERROR),
   RESULTSTATUS = IF(@RESULTSTATUS='', NULL, @RESULTSTATUS),
   STOPPED = IF(@STOPPED='', NULL, @STOPPED);

DROP TABLE IF EXISTS CPTEVENTS;
CREATE TABLE CPTEVENTS (	-- rows=573146
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   COSTCENTER VARCHAR(10) NOT NULL,	-- max=4
   CHARTDATE DATETIME,
   CPT_CD VARCHAR(10) NOT NULL,	-- max=5
   CPT_NUMBER MEDIUMINT UNSIGNED,
   CPT_SUFFIX VARCHAR(5),	-- max=1
   TICKET_ID_SEQ SMALLINT UNSIGNED,
   SECTIONHEADER VARCHAR(50),	-- max=25
   SUBSECTIONHEADER VARCHAR(255),	-- max=169
   DESCRIPTION VARCHAR(200)	-- max=30
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'CPTEVENTS.csv' INTO TABLE CPTEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@COSTCENTER,@CHARTDATE,@CPT_CD,@CPT_NUMBER,@CPT_SUFFIX,@TICKET_ID_SEQ,@SECTIONHEADER,@SUBSECTIONHEADER,@DESCRIPTION)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   COSTCENTER = @COSTCENTER,
   CHARTDATE = IF(@CHARTDATE='', NULL, @CHARTDATE),
   CPT_CD = @CPT_CD,
   CPT_NUMBER = IF(@CPT_NUMBER='', NULL, @CPT_NUMBER),
   CPT_SUFFIX = IF(@CPT_SUFFIX='', NULL, @CPT_SUFFIX),
   TICKET_ID_SEQ = IF(@TICKET_ID_SEQ='', NULL, @TICKET_ID_SEQ),
   SECTIONHEADER = IF(@SECTIONHEADER='', NULL, @SECTIONHEADER),
   SUBSECTIONHEADER = IF(@SUBSECTIONHEADER='', NULL, @SUBSECTIONHEADER),
   DESCRIPTION = IF(@DESCRIPTION='', NULL, @DESCRIPTION);

DROP TABLE IF EXISTS DATETIMEEVENTS;
CREATE TABLE DATETIMEEVENTS (	-- rows=4486049
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   ITEMID MEDIUMINT UNSIGNED NOT NULL,
   CHARTTIME DATETIME NOT NULL,
   STORETIME DATETIME NOT NULL,
   CGID SMALLINT UNSIGNED NOT NULL,
   VALUE DATETIME,
   VALUEUOM VARCHAR(50) NOT NULL,	-- max=13
   WARNING TINYINT UNSIGNED,
   ERROR TINYINT UNSIGNED,
   RESULTSTATUS VARCHAR(50),	-- max=0
   STOPPED VARCHAR(50)	-- max=8
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'DATETIMEEVENTS.csv' INTO TABLE DATETIMEEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@ITEMID,@CHARTTIME,@STORETIME,@CGID,@VALUE,@VALUEUOM,@WARNING,@ERROR,@RESULTSTATUS,@STOPPED)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   ITEMID = @ITEMID,
   CHARTTIME = @CHARTTIME,
   STORETIME = @STORETIME,
   CGID = @CGID,
   VALUE = IF(@VALUE='', NULL, @VALUE),
   VALUEUOM = @VALUEUOM,
   WARNING = IF(@WARNING='', NULL, @WARNING),
   ERROR = IF(@ERROR='', NULL, @ERROR),
   RESULTSTATUS = IF(@RESULTSTATUS='', NULL, @RESULTSTATUS),
   STOPPED = IF(@STOPPED='', NULL, @STOPPED);

DROP TABLE IF EXISTS DIAGNOSES_ICD;
CREATE TABLE DIAGNOSES_ICD (	-- rows=651047
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   SEQ_NUM TINYINT UNSIGNED,
   ICD9_CODE VARCHAR(10)	-- max=5
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'DIAGNOSES_ICD.csv' INTO TABLE DIAGNOSES_ICD
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@SEQ_NUM,@ICD9_CODE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   SEQ_NUM = IF(@SEQ_NUM='', NULL, @SEQ_NUM),
   ICD9_CODE = IF(@ICD9_CODE='', NULL, @ICD9_CODE);

DROP TABLE IF EXISTS DRGCODES;
CREATE TABLE DRGCODES (	-- rows=125557
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   DRG_TYPE VARCHAR(20) NOT NULL,	-- max=4
   DRG_CODE VARCHAR(20) NOT NULL,	-- max=4
   DESCRIPTION VARCHAR(255),	-- max=193
   DRG_SEVERITY TINYINT UNSIGNED,
   DRG_MORTALITY TINYINT UNSIGNED
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'DRGCODES.csv' INTO TABLE DRGCODES
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@DRG_TYPE,@DRG_CODE,@DESCRIPTION,@DRG_SEVERITY,@DRG_MORTALITY)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   DRG_TYPE = @DRG_TYPE,
   DRG_CODE = @DRG_CODE,
   DESCRIPTION = IF(@DESCRIPTION='', NULL, @DESCRIPTION),
   DRG_SEVERITY = IF(@DRG_SEVERITY='', NULL, @DRG_SEVERITY),
   DRG_MORTALITY = IF(@DRG_MORTALITY='', NULL, @DRG_MORTALITY);

DROP TABLE IF EXISTS D_CPT;
CREATE TABLE D_CPT (	-- rows=134
   ROW_ID TINYINT UNSIGNED NOT NULL PRIMARY KEY,
   CATEGORY TINYINT UNSIGNED NOT NULL,
   SECTIONRANGE VARCHAR(100) NOT NULL,	-- max=37
   SECTIONHEADER VARCHAR(50) NOT NULL,	-- max=25
   SUBSECTIONRANGE VARCHAR(100) NOT NULL,	-- max=11
   SUBSECTIONHEADER VARCHAR(255) NOT NULL,	-- max=169
   CODESUFFIX VARCHAR(5),	-- max=1
   MINCODEINSUBSECTION MEDIUMINT UNSIGNED NOT NULL,
   MAXCODEINSUBSECTION MEDIUMINT UNSIGNED NOT NULL,
  UNIQUE KEY D_CPT_SUBSECTIONRANGE (SUBSECTIONRANGE),	-- nvals=134
  UNIQUE KEY D_CPT_MAXCODEINSUBSECTION (MAXCODEINSUBSECTION)	-- nvals=134
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'D_CPT.csv' INTO TABLE D_CPT
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@CATEGORY,@SECTIONRANGE,@SECTIONHEADER,@SUBSECTIONRANGE,@SUBSECTIONHEADER,@CODESUFFIX,@MINCODEINSUBSECTION,@MAXCODEINSUBSECTION)
 SET
   ROW_ID = @ROW_ID,
   CATEGORY = @CATEGORY,
   SECTIONRANGE = @SECTIONRANGE,
   SECTIONHEADER = @SECTIONHEADER,
   SUBSECTIONRANGE = @SUBSECTIONRANGE,
   SUBSECTIONHEADER = @SUBSECTIONHEADER,
   CODESUFFIX = IF(@CODESUFFIX='', NULL, @CODESUFFIX),
   MINCODEINSUBSECTION = @MINCODEINSUBSECTION,
   MAXCODEINSUBSECTION = @MAXCODEINSUBSECTION;

DROP TABLE IF EXISTS D_ICD_DIAGNOSES;
CREATE TABLE D_ICD_DIAGNOSES (	-- rows=14567
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   ICD9_CODE VARCHAR(10) NOT NULL,	-- max=5
   SHORT_TITLE VARCHAR(50) NOT NULL,	-- max=24
   LONG_TITLE VARCHAR(255) NOT NULL,	-- max=222
  UNIQUE KEY D_ICD_DIAGNOSES_ICD9_CODE (ICD9_CODE)	-- nvals=14567
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'D_ICD_DIAGNOSES.csv' INTO TABLE D_ICD_DIAGNOSES
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@ICD9_CODE,@SHORT_TITLE,@LONG_TITLE)
 SET
   ROW_ID = @ROW_ID,
   ICD9_CODE = @ICD9_CODE,
   SHORT_TITLE = @SHORT_TITLE,
   LONG_TITLE = @LONG_TITLE;

DROP TABLE IF EXISTS D_ICD_PROCEDURES;
CREATE TABLE D_ICD_PROCEDURES (	-- rows=3882
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   ICD9_CODE VARCHAR(10) NOT NULL,	-- max=4
   SHORT_TITLE VARCHAR(50) NOT NULL,	-- max=24
   LONG_TITLE VARCHAR(255) NOT NULL,	-- max=163
  UNIQUE KEY D_ICD_PROCEDURES_ICD9_CODE (ICD9_CODE),	-- nvals=3882
  UNIQUE KEY D_ICD_PROCEDURES_SHORT_TITLE (SHORT_TITLE)	-- nvals=3882
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'D_ICD_PROCEDURES.csv' INTO TABLE D_ICD_PROCEDURES
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@ICD9_CODE,@SHORT_TITLE,@LONG_TITLE)
 SET
   ROW_ID = @ROW_ID,
   ICD9_CODE = @ICD9_CODE,
   SHORT_TITLE = @SHORT_TITLE,
   LONG_TITLE = @LONG_TITLE;

DROP TABLE IF EXISTS D_ITEMS;
CREATE TABLE D_ITEMS (	-- rows=12478
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   ITEMID MEDIUMINT UNSIGNED NOT NULL,
   LABEL VARCHAR(200),	-- max=95
   ABBREVIATION VARCHAR(100),	-- max=50
   DBSOURCE VARCHAR(20) NOT NULL,	-- max=10
   LINKSTO VARCHAR(50),	-- max=18
   CATEGORY VARCHAR(100),	-- max=27
   UNITNAME VARCHAR(100),	-- max=19
   PARAM_TYPE VARCHAR(30),	-- max=16
   CONCEPTID INT,	-- max=0
  UNIQUE KEY D_ITEMS_ITEMID (ITEMID)	-- nvals=12478
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'D_ITEMS.csv' INTO TABLE D_ITEMS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@ITEMID,@LABEL,@ABBREVIATION,@DBSOURCE,@LINKSTO,@CATEGORY,@UNITNAME,@PARAM_TYPE,@CONCEPTID)
 SET
   ROW_ID = @ROW_ID,
   ITEMID = @ITEMID,
   LABEL = IF(@LABEL='', NULL, @LABEL),
   ABBREVIATION = IF(@ABBREVIATION='', NULL, @ABBREVIATION),
   DBSOURCE = @DBSOURCE,
   LINKSTO = IF(@LINKSTO='', NULL, @LINKSTO),
   CATEGORY = IF(@CATEGORY='', NULL, @CATEGORY),
   UNITNAME = IF(@UNITNAME='', NULL, @UNITNAME),
   PARAM_TYPE = IF(@PARAM_TYPE='', NULL, @PARAM_TYPE),
   CONCEPTID = IF(@CONCEPTID='', NULL, @CONCEPTID);

DROP TABLE IF EXISTS D_LABITEMS;
CREATE TABLE D_LABITEMS (	-- rows=755
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   ITEMID SMALLINT UNSIGNED NOT NULL,
   LABEL VARCHAR(100) NOT NULL,	-- max=36
   FLUID VARCHAR(100) NOT NULL,	-- max=25
   CATEGORY VARCHAR(100) NOT NULL,	-- max=10
   LOINC_CODE VARCHAR(100),	-- max=7
  UNIQUE KEY D_LABITEMS_ITEMID (ITEMID)	-- nvals=755
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'D_LABITEMS.csv' INTO TABLE D_LABITEMS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@ITEMID,@LABEL,@FLUID,@CATEGORY,@LOINC_CODE)
 SET
   ROW_ID = @ROW_ID,
   ITEMID = @ITEMID,
   LABEL = @LABEL,
   FLUID = @FLUID,
   CATEGORY = @CATEGORY,
   LOINC_CODE = IF(@LOINC_CODE='', NULL, @LOINC_CODE);

DROP TABLE IF EXISTS ICUSTAYS;
CREATE TABLE ICUSTAYS (	-- rows=61532
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   ICUSTAY_ID MEDIUMINT UNSIGNED NOT NULL,
   DBSOURCE VARCHAR(20) NOT NULL,	-- max=10
   FIRST_CAREUNIT VARCHAR(20) NOT NULL,	-- max=5
   LAST_CAREUNIT VARCHAR(20) NOT NULL,	-- max=5
   FIRST_WARDID TINYINT UNSIGNED NOT NULL,
   LAST_WARDID TINYINT UNSIGNED NOT NULL,
   INTIME DATETIME NOT NULL,
   OUTTIME DATETIME,
   LOS DECIMAL(22, 10),
  UNIQUE KEY ICUSTAYS_ICUSTAY_ID (ICUSTAY_ID)	-- nvals=61532
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'ICUSTAYS.csv' INTO TABLE ICUSTAYS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@DBSOURCE,@FIRST_CAREUNIT,@LAST_CAREUNIT,@FIRST_WARDID,@LAST_WARDID,@INTIME,@OUTTIME,@LOS)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   ICUSTAY_ID = @ICUSTAY_ID,
   DBSOURCE = @DBSOURCE,
   FIRST_CAREUNIT = @FIRST_CAREUNIT,
   LAST_CAREUNIT = @LAST_CAREUNIT,
   FIRST_WARDID = @FIRST_WARDID,
   LAST_WARDID = @LAST_WARDID,
   INTIME = @INTIME,
   OUTTIME = IF(@OUTTIME='', NULL, @OUTTIME),
   LOS = IF(@LOS='', NULL, @LOS);

DROP TABLE IF EXISTS INPUTEVENTS_CV;
CREATE TABLE INPUTEVENTS_CV (	-- rows=17528894
   ROW_ID INT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   CHARTTIME DATETIME NOT NULL,
   ITEMID SMALLINT UNSIGNED NOT NULL,
   AMOUNT DECIMAL(22, 10),
   AMOUNTUOM VARCHAR(30),	-- max=3
   RATE DECIMAL(22, 10),
   RATEUOM VARCHAR(30),	-- max=8
   STORETIME DATETIME NOT NULL,
   CGID SMALLINT UNSIGNED,
   ORDERID MEDIUMINT UNSIGNED NOT NULL,
   LINKORDERID MEDIUMINT UNSIGNED NOT NULL,
   STOPPED VARCHAR(30),	-- max=8
   NEWBOTTLE TINYINT UNSIGNED DEFAULT NULL,
   ORIGINALAMOUNT DECIMAL(22, 10),
   ORIGINALAMOUNTUOM VARCHAR(30),	-- max=3
   ORIGINALROUTE VARCHAR(30),	-- max=20
   ORIGINALRATE DECIMAL(22, 10),
   ORIGINALRATEUOM VARCHAR(30),	-- max=5
   ORIGINALSITE VARCHAR(30)	-- max=20
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'INPUTEVENTS_CV.csv' INTO TABLE INPUTEVENTS_CV
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@CHARTTIME,@ITEMID,@AMOUNT,@AMOUNTUOM,@RATE,@RATEUOM,@STORETIME,@CGID,@ORDERID,@LINKORDERID,@STOPPED,@NEWBOTTLE,@ORIGINALAMOUNT,@ORIGINALAMOUNTUOM,@ORIGINALROUTE,@ORIGINALRATE,@ORIGINALRATEUOM,@ORIGINALSITE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   CHARTTIME = @CHARTTIME,
   ITEMID = @ITEMID,
   AMOUNT = IF(@AMOUNT='', NULL, @AMOUNT),
   AMOUNTUOM = IF(@AMOUNTUOM='', NULL, @AMOUNTUOM),
   RATE = IF(@RATE='', NULL, @RATE),
   RATEUOM = IF(@RATEUOM='', NULL, @RATEUOM),
   STORETIME = @STORETIME,
   CGID = IF(@CGID='', NULL, @CGID),
   ORDERID = @ORDERID,
   LINKORDERID = @LINKORDERID,
   STOPPED = IF(@STOPPED='', NULL, @STOPPED),
   NEWBOTTLE = IF(@NEWBOTTLE='', NULL, @NEWBOTTLE),
   ORIGINALAMOUNT = IF(@ORIGINALAMOUNT='', NULL, @ORIGINALAMOUNT),
   ORIGINALAMOUNTUOM = IF(@ORIGINALAMOUNTUOM='', NULL, @ORIGINALAMOUNTUOM),
   ORIGINALROUTE = IF(@ORIGINALROUTE='', NULL, @ORIGINALROUTE),
   ORIGINALRATE = IF(@ORIGINALRATE='', NULL, @ORIGINALRATE),
   ORIGINALRATEUOM = IF(@ORIGINALRATEUOM='', NULL, @ORIGINALRATEUOM),
   ORIGINALSITE = IF(@ORIGINALSITE='', NULL, @ORIGINALSITE);

DROP TABLE IF EXISTS INPUTEVENTS_MV;
CREATE TABLE INPUTEVENTS_MV (	-- rows=3618991
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   STARTTIME DATETIME NOT NULL,
   ENDTIME DATETIME NOT NULL,
   ITEMID MEDIUMINT UNSIGNED NOT NULL,
   AMOUNT DECIMAL(22, 10) NOT NULL,
   AMOUNTUOM VARCHAR(30) NOT NULL,	-- max=19
   RATE DECIMAL(22, 10),
   RATEUOM VARCHAR(30),	-- max=12
   STORETIME DATETIME NOT NULL,
   CGID SMALLINT UNSIGNED NOT NULL,
   ORDERID MEDIUMINT UNSIGNED NOT NULL,
   LINKORDERID MEDIUMINT UNSIGNED NOT NULL,
   ORDERCATEGORYNAME VARCHAR(100) NOT NULL,	-- max=24
   SECONDARYORDERCATEGORYNAME VARCHAR(100),	-- max=24
   ORDERCOMPONENTTYPEDESCRIPTION VARCHAR(200) NOT NULL,	-- max=100
   ORDERCATEGORYDESCRIPTION VARCHAR(50) NOT NULL,	-- max=14
   PATIENTWEIGHT DECIMAL(22, 10) NOT NULL,
   TOTALAMOUNT DECIMAL(22, 10),
   TOTALAMOUNTUOM VARCHAR(255),	-- max=2
   ISOPENBAG TINYINT UNSIGNED NOT NULL,
   CONTINUEINNEXTDEPT TINYINT UNSIGNED NOT NULL,
   CANCELREASON TINYINT UNSIGNED NOT NULL,
   STATUSDESCRIPTION VARCHAR(30) NOT NULL,	-- max=15
   COMMENTS_EDITEDBY VARCHAR(30),	-- max=15
   COMMENTS_CANCELEDBY VARCHAR(30),	-- max=15
   COMMENTS_DATE DATETIME,
   ORIGINALAMOUNT DECIMAL(22, 10) NOT NULL,
   ORIGINALRATE DECIMAL(22, 10) NOT NULL
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'INPUTEVENTS_MV.csv' INTO TABLE INPUTEVENTS_MV
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@STARTTIME,@ENDTIME,@ITEMID,@AMOUNT,@AMOUNTUOM,@RATE,@RATEUOM,@STORETIME,@CGID,@ORDERID,@LINKORDERID,@ORDERCATEGORYNAME,@SECONDARYORDERCATEGORYNAME,@ORDERCOMPONENTTYPEDESCRIPTION,@ORDERCATEGORYDESCRIPTION,@PATIENTWEIGHT,@TOTALAMOUNT,@TOTALAMOUNTUOM,@ISOPENBAG,@CONTINUEINNEXTDEPT,@CANCELREASON,@STATUSDESCRIPTION,@COMMENTS_EDITEDBY,@COMMENTS_CANCELEDBY,@COMMENTS_DATE,@ORIGINALAMOUNT,@ORIGINALRATE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   STARTTIME = @STARTTIME,
   ENDTIME = @ENDTIME,
   ITEMID = @ITEMID,
   AMOUNT = @AMOUNT,
   AMOUNTUOM = @AMOUNTUOM,
   RATE = IF(@RATE='', NULL, @RATE),
   RATEUOM = IF(@RATEUOM='', NULL, @RATEUOM),
   STORETIME = @STORETIME,
   CGID = @CGID,
   ORDERID = @ORDERID,
   LINKORDERID = @LINKORDERID,
   ORDERCATEGORYNAME = @ORDERCATEGORYNAME,
   SECONDARYORDERCATEGORYNAME = IF(@SECONDARYORDERCATEGORYNAME='', NULL, @SECONDARYORDERCATEGORYNAME),
   ORDERCOMPONENTTYPEDESCRIPTION = @ORDERCOMPONENTTYPEDESCRIPTION,
   ORDERCATEGORYDESCRIPTION = @ORDERCATEGORYDESCRIPTION,
   PATIENTWEIGHT = @PATIENTWEIGHT,
   TOTALAMOUNT = IF(@TOTALAMOUNT='', NULL, @TOTALAMOUNT),
   TOTALAMOUNTUOM = IF(@TOTALAMOUNTUOM='', NULL, @TOTALAMOUNTUOM),
   ISOPENBAG = @ISOPENBAG,
   CONTINUEINNEXTDEPT = @CONTINUEINNEXTDEPT,
   CANCELREASON = @CANCELREASON,
   STATUSDESCRIPTION = @STATUSDESCRIPTION,
   COMMENTS_EDITEDBY = IF(@COMMENTS_EDITEDBY='', NULL, @COMMENTS_EDITEDBY),
   COMMENTS_CANCELEDBY = IF(@COMMENTS_CANCELEDBY='', NULL, @COMMENTS_CANCELEDBY),
   COMMENTS_DATE = IF(@COMMENTS_DATE='', NULL, @COMMENTS_DATE),
   ORIGINALAMOUNT = @ORIGINALAMOUNT,
   ORIGINALRATE = @ORIGINALRATE;

DROP TABLE IF EXISTS LABEVENTS;
CREATE TABLE LABEVENTS (	-- rows=27872575
   ROW_ID INT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   ITEMID SMALLINT UNSIGNED NOT NULL,
   CHARTTIME DATETIME NOT NULL,
   VALUE VARCHAR(200),	-- max=100
   VALUENUM DECIMAL(22, 10),
   VALUEUOM VARCHAR(20),	-- max=10
   FLAG VARCHAR(20)	-- max=8
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'LABEVENTS.csv' INTO TABLE LABEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ITEMID,@CHARTTIME,@VALUE,@VALUENUM,@VALUEUOM,@FLAG)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   ITEMID = @ITEMID,
   CHARTTIME = @CHARTTIME,
   VALUE = IF(@VALUE='', NULL, @VALUE),
   VALUENUM = IF(@VALUENUM='', NULL, @VALUENUM),
   VALUEUOM = IF(@VALUEUOM='', NULL, @VALUEUOM),
   FLAG = IF(@FLAG='', NULL, @FLAG);

DROP TABLE IF EXISTS MICROBIOLOGYEVENTS;
CREATE TABLE MICROBIOLOGYEVENTS (	-- rows=328446
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   CHARTDATE DATETIME NOT NULL,
   CHARTTIME DATETIME,
   SPEC_ITEMID MEDIUMINT UNSIGNED,
   SPEC_TYPE_DESC VARCHAR(100) NOT NULL,	-- max=56
   ORG_ITEMID MEDIUMINT UNSIGNED,
   ORG_NAME VARCHAR(100),	-- max=70
   ISOLATE_NUM TINYINT UNSIGNED,
   AB_ITEMID MEDIUMINT UNSIGNED,
   AB_NAME VARCHAR(30),	-- max=20
   DILUTION_TEXT VARCHAR(10),	-- max=6
   DILUTION_COMPARISON VARCHAR(20),	-- max=2
   DILUTION_VALUE SMALLINT UNSIGNED,
   INTERPRETATION VARCHAR(5)	-- max=1
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'MICROBIOLOGYEVENTS.csv' INTO TABLE MICROBIOLOGYEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@CHARTDATE,@CHARTTIME,@SPEC_ITEMID,@SPEC_TYPE_DESC,@ORG_ITEMID,@ORG_NAME,@ISOLATE_NUM,@AB_ITEMID,@AB_NAME,@DILUTION_TEXT,@DILUTION_COMPARISON,@DILUTION_VALUE,@INTERPRETATION)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   CHARTDATE = @CHARTDATE,
   CHARTTIME = IF(@CHARTTIME='', NULL, @CHARTTIME),
   SPEC_ITEMID = IF(@SPEC_ITEMID='', NULL, @SPEC_ITEMID),
   SPEC_TYPE_DESC = @SPEC_TYPE_DESC,
   ORG_ITEMID = IF(@ORG_ITEMID='', NULL, @ORG_ITEMID),
   ORG_NAME = IF(@ORG_NAME='', NULL, @ORG_NAME),
   ISOLATE_NUM = IF(@ISOLATE_NUM='', NULL, @ISOLATE_NUM),
   AB_ITEMID = IF(@AB_ITEMID='', NULL, @AB_ITEMID),
   AB_NAME = IF(@AB_NAME='', NULL, @AB_NAME),
   DILUTION_TEXT = IF(@DILUTION_TEXT='', NULL, @DILUTION_TEXT),
   DILUTION_COMPARISON = IF(@DILUTION_COMPARISON='', NULL, @DILUTION_COMPARISON),
   DILUTION_VALUE = IF(@DILUTION_VALUE='', NULL, @DILUTION_VALUE),
   INTERPRETATION = IF(@INTERPRETATION='', NULL, @INTERPRETATION);

DROP TABLE IF EXISTS NOTEEVENTS;
CREATE TABLE NOTEEVENTS (	-- rows=2078705
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   CHARTDATE DATE NOT NULL,
   CHARTTIME DATETIME,
   STORETIME DATETIME,
   CATEGORY VARCHAR(50) NOT NULL,	-- max=17
   DESCRIPTION VARCHAR(255) NOT NULL,	-- max=80
   CGID SMALLINT UNSIGNED,
   ISERROR TINYINT UNSIGNED,
   TEXT MEDIUMTEXT	-- max=55725
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'NOTEEVENTS.csv' INTO TABLE NOTEEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@CHARTDATE,@CHARTTIME,@STORETIME,@CATEGORY,@DESCRIPTION,@CGID,@ISERROR,@TEXT)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   CHARTDATE = @CHARTDATE,
   CHARTTIME = IF(@CHARTTIME='', NULL, @CHARTTIME),
   STORETIME = IF(@STORETIME='', NULL, @STORETIME),
   CATEGORY = @CATEGORY,
   DESCRIPTION = @DESCRIPTION,
   CGID = IF(@CGID='', NULL, @CGID),
   ISERROR = IF(@ISERROR='', NULL, @ISERROR),
   TEXT = IF(@TEXT='', NULL, @TEXT);

DROP TABLE IF EXISTS OUTPUTEVENTS;
CREATE TABLE OUTPUTEVENTS (	-- rows=4349339
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   CHARTTIME DATETIME NOT NULL,
   ITEMID MEDIUMINT UNSIGNED NOT NULL,
   VALUE DECIMAL(22, 10),
   VALUEUOM VARCHAR(30),	-- max=2
   STORETIME DATETIME NOT NULL,
   CGID SMALLINT UNSIGNED NOT NULL,
   STOPPED VARCHAR(30),	-- max=0
   NEWBOTTLE CHAR(1),	-- max=0
   ISERROR TINYINT UNSIGNED	-- max=0
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'OUTPUTEVENTS.csv' INTO TABLE OUTPUTEVENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@CHARTTIME,@ITEMID,@VALUE,@VALUEUOM,@STORETIME,@CGID,@STOPPED,@NEWBOTTLE,@ISERROR)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = IF(@HADM_ID='', NULL, @HADM_ID),
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   CHARTTIME = @CHARTTIME,
   ITEMID = @ITEMID,
   VALUE = IF(@VALUE='', NULL, @VALUE),
   VALUEUOM = IF(@VALUEUOM='', NULL, @VALUEUOM),
   STORETIME = @STORETIME,
   CGID = @CGID,
   STOPPED = IF(@STOPPED='', NULL, @STOPPED),
   NEWBOTTLE = IF(@NEWBOTTLE='', NULL, @NEWBOTTLE),
   ISERROR = IF(@ISERROR='', NULL, @ISERROR);

DROP TABLE IF EXISTS PATIENTS;
CREATE TABLE PATIENTS (	-- rows=46520
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   GENDER VARCHAR(5) NOT NULL,	-- max=1
   DOB DATETIME NOT NULL,
   DOD DATETIME,
   DOD_HOSP DATETIME,
   DOD_SSN DATETIME,
   EXPIRE_FLAG TINYINT UNSIGNED NOT NULL,
  UNIQUE KEY PATIENTS_SUBJECT_ID (SUBJECT_ID)	-- nvals=46520
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'PATIENTS.csv' INTO TABLE PATIENTS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@GENDER,@DOB,@DOD,@DOD_HOSP,@DOD_SSN,@EXPIRE_FLAG)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   GENDER = @GENDER,
   DOB = @DOB,
   DOD = IF(@DOD='', NULL, @DOD),
   DOD_HOSP = IF(@DOD_HOSP='', NULL, @DOD_HOSP),
   DOD_SSN = IF(@DOD_SSN='', NULL, @DOD_SSN),
   EXPIRE_FLAG = @EXPIRE_FLAG;

DROP TABLE IF EXISTS PRESCRIPTIONS;
CREATE TABLE PRESCRIPTIONS (	-- rows=4156848
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   STARTDATE DATETIME,
   ENDDATE DATETIME,
   DRUG_TYPE VARCHAR(100) NOT NULL,	-- max=8
   DRUG VARCHAR(100),	-- max=58
   DRUG_NAME_POE VARCHAR(100),	-- max=58
   DRUG_NAME_GENERIC VARCHAR(100),	-- max=49
   FORMULARY_DRUG_CD VARCHAR(120),	-- max=17
   GSN VARCHAR(200),	-- max=125
   NDC VARCHAR(120),	-- max=11
   PROD_STRENGTH VARCHAR(120),	-- max=60
   DOSE_VAL_RX VARCHAR(120),	-- max=26
   DOSE_UNIT_RX VARCHAR(120),	-- max=32
   FORM_VAL_DISP VARCHAR(120),	-- max=47
   FORM_UNIT_DISP VARCHAR(120),	-- max=13
   ROUTE VARCHAR(120)	-- max=28
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'PRESCRIPTIONS.csv' INTO TABLE PRESCRIPTIONS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@STARTDATE,@ENDDATE,@DRUG_TYPE,@DRUG,@DRUG_NAME_POE,@DRUG_NAME_GENERIC,@FORMULARY_DRUG_CD,@GSN,@NDC,@PROD_STRENGTH,@DOSE_VAL_RX,@DOSE_UNIT_RX,@FORM_VAL_DISP,@FORM_UNIT_DISP,@ROUTE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   STARTDATE = IF(@STARTDATE='', NULL, @STARTDATE),
   ENDDATE = IF(@ENDDATE='', NULL, @ENDDATE),
   DRUG_TYPE = @DRUG_TYPE,
   DRUG = IF(@DRUG='', NULL, @DRUG),
   DRUG_NAME_POE = IF(@DRUG_NAME_POE='', NULL, @DRUG_NAME_POE),
   DRUG_NAME_GENERIC = IF(@DRUG_NAME_GENERIC='', NULL, @DRUG_NAME_GENERIC),
   FORMULARY_DRUG_CD = IF(@FORMULARY_DRUG_CD='', NULL, @FORMULARY_DRUG_CD),
   GSN = IF(@GSN='', NULL, @GSN),
   NDC = IF(@NDC='', NULL, @NDC),
   PROD_STRENGTH = IF(@PROD_STRENGTH='', NULL, @PROD_STRENGTH),
   DOSE_VAL_RX = IF(@DOSE_VAL_RX='', NULL, @DOSE_VAL_RX),
   DOSE_UNIT_RX = IF(@DOSE_UNIT_RX='', NULL, @DOSE_UNIT_RX),
   FORM_VAL_DISP = IF(@FORM_VAL_DISP='', NULL, @FORM_VAL_DISP),
   FORM_UNIT_DISP = IF(@FORM_UNIT_DISP='', NULL, @FORM_UNIT_DISP),
   ROUTE = IF(@ROUTE='', NULL, @ROUTE);

DROP TABLE IF EXISTS PROCEDUREEVENTS_MV;
CREATE TABLE PROCEDUREEVENTS_MV (	-- rows=258066
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   STARTTIME DATETIME NOT NULL,
   ENDTIME DATETIME NOT NULL,
   ITEMID MEDIUMINT UNSIGNED NOT NULL,
   VALUE DECIMAL(22, 10) NOT NULL,
   VALUEUOM VARCHAR(30) NOT NULL,	-- max=4
   LOCATION VARCHAR(30),	-- max=24
   LOCATIONCATEGORY VARCHAR(30),	-- max=19
   STORETIME DATETIME NOT NULL,
   CGID SMALLINT UNSIGNED NOT NULL,
   ORDERID MEDIUMINT UNSIGNED NOT NULL,
   LINKORDERID MEDIUMINT UNSIGNED NOT NULL,
   ORDERCATEGORYNAME VARCHAR(100) NOT NULL,	-- max=21
   SECONDARYORDERCATEGORYNAME VARCHAR(100),	-- max=0
   ORDERCATEGORYDESCRIPTION VARCHAR(50) NOT NULL,	-- max=12
   ISOPENBAG TINYINT UNSIGNED NOT NULL,
   CONTINUEINNEXTDEPT TINYINT UNSIGNED NOT NULL,
   CANCELREASON TINYINT UNSIGNED NOT NULL,
   STATUSDESCRIPTION VARCHAR(30) NOT NULL,	-- max=15
   COMMENTS_EDITEDBY VARCHAR(30),	-- max=7
   COMMENTS_CANCELEDBY VARCHAR(30),	-- max=17
   COMMENTS_DATE DATETIME,
  UNIQUE KEY PROCEDUREEVENTS_MV_ORDERID (ORDERID)	-- nvals=258066
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'PROCEDUREEVENTS_MV.csv' INTO TABLE PROCEDUREEVENTS_MV
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@STARTTIME,@ENDTIME,@ITEMID,@VALUE,@VALUEUOM,@LOCATION,@LOCATIONCATEGORY,@STORETIME,@CGID,@ORDERID,@LINKORDERID,@ORDERCATEGORYNAME,@SECONDARYORDERCATEGORYNAME,@ORDERCATEGORYDESCRIPTION,@ISOPENBAG,@CONTINUEINNEXTDEPT,@CANCELREASON,@STATUSDESCRIPTION,@COMMENTS_EDITEDBY,@COMMENTS_CANCELEDBY,@COMMENTS_DATE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   STARTTIME = @STARTTIME,
   ENDTIME = @ENDTIME,
   ITEMID = @ITEMID,
   VALUE = @VALUE,
   VALUEUOM = @VALUEUOM,
   LOCATION = IF(@LOCATION='', NULL, @LOCATION),
   LOCATIONCATEGORY = IF(@LOCATIONCATEGORY='', NULL, @LOCATIONCATEGORY),
   STORETIME = @STORETIME,
   CGID = @CGID,
   ORDERID = @ORDERID,
   LINKORDERID = @LINKORDERID,
   ORDERCATEGORYNAME = @ORDERCATEGORYNAME,
   SECONDARYORDERCATEGORYNAME = IF(@SECONDARYORDERCATEGORYNAME='', NULL, @SECONDARYORDERCATEGORYNAME),
   ORDERCATEGORYDESCRIPTION = @ORDERCATEGORYDESCRIPTION,
   ISOPENBAG = @ISOPENBAG,
   CONTINUEINNEXTDEPT = @CONTINUEINNEXTDEPT,
   CANCELREASON = @CANCELREASON,
   STATUSDESCRIPTION = @STATUSDESCRIPTION,
   COMMENTS_EDITEDBY = IF(@COMMENTS_EDITEDBY='', NULL, @COMMENTS_EDITEDBY),
   COMMENTS_CANCELEDBY = IF(@COMMENTS_CANCELEDBY='', NULL, @COMMENTS_CANCELEDBY),
   COMMENTS_DATE = IF(@COMMENTS_DATE='', NULL, @COMMENTS_DATE);

DROP TABLE IF EXISTS PROCEDURES_ICD;
CREATE TABLE PROCEDURES_ICD (	-- rows=240095
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   SEQ_NUM TINYINT UNSIGNED NOT NULL,
   ICD9_CODE VARCHAR(10) NOT NULL	-- max=4
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'PROCEDURES_ICD.csv' INTO TABLE PROCEDURES_ICD
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@SEQ_NUM,@ICD9_CODE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   SEQ_NUM = @SEQ_NUM,
   ICD9_CODE = @ICD9_CODE;

DROP TABLE IF EXISTS SERVICES;
CREATE TABLE SERVICES (	-- rows=73343
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   TRANSFERTIME DATETIME NOT NULL,
   PREV_SERVICE VARCHAR(20),	-- max=5
   CURR_SERVICE VARCHAR(20) NOT NULL	-- max=5
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'SERVICES.csv' INTO TABLE SERVICES
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@TRANSFERTIME,@PREV_SERVICE,@CURR_SERVICE)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   TRANSFERTIME = @TRANSFERTIME,
   PREV_SERVICE = IF(@PREV_SERVICE='', NULL, @PREV_SERVICE),
   CURR_SERVICE = @CURR_SERVICE;

DROP TABLE IF EXISTS TRANSFERS;
CREATE TABLE TRANSFERS (	-- rows=261897
   ROW_ID MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
   SUBJECT_ID MEDIUMINT UNSIGNED NOT NULL,
   HADM_ID MEDIUMINT UNSIGNED NOT NULL,
   ICUSTAY_ID MEDIUMINT UNSIGNED,
   DBSOURCE VARCHAR(20),	-- max=10
   EVENTTYPE VARCHAR(20),	-- max=9
   PREV_CAREUNIT VARCHAR(20),	-- max=5
   CURR_CAREUNIT VARCHAR(20),	-- max=5
   PREV_WARDID TINYINT UNSIGNED,
   CURR_WARDID TINYINT UNSIGNED,
   INTIME DATETIME,
   OUTTIME DATETIME,
   LOS DECIMAL(22, 10)
  )
  CHARACTER SET = UTF8;

LOAD DATA LOCAL INFILE 'TRANSFERS.csv' INTO TABLE TRANSFERS
   FIELDS TERMINATED BY ',' ESCAPED BY '\\' OPTIONALLY ENCLOSED BY '"'
   LINES TERMINATED BY '\n'
   IGNORE 1 LINES
   (@ROW_ID,@SUBJECT_ID,@HADM_ID,@ICUSTAY_ID,@DBSOURCE,@EVENTTYPE,@PREV_CAREUNIT,@CURR_CAREUNIT,@PREV_WARDID,@CURR_WARDID,@INTIME,@OUTTIME,@LOS)
 SET
   ROW_ID = @ROW_ID,
   SUBJECT_ID = @SUBJECT_ID,
   HADM_ID = @HADM_ID,
   ICUSTAY_ID = IF(@ICUSTAY_ID='', NULL, @ICUSTAY_ID),
   DBSOURCE = IF(@DBSOURCE='', NULL, @DBSOURCE),
   EVENTTYPE = IF(@EVENTTYPE='', NULL, @EVENTTYPE),
   PREV_CAREUNIT = IF(@PREV_CAREUNIT='', NULL, @PREV_CAREUNIT),
   CURR_CAREUNIT = IF(@CURR_CAREUNIT='', NULL, @CURR_CAREUNIT),
   PREV_WARDID = IF(@PREV_WARDID='', NULL, @PREV_WARDID),
   CURR_WARDID = IF(@CURR_WARDID='', NULL, @CURR_WARDID),
   INTIME = IF(@INTIME='', NULL, @INTIME),
   OUTTIME = IF(@OUTTIME='', NULL, @OUTTIME),
   LOS = IF(@LOS='', NULL, @LOS);