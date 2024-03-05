/*
Exploratory Data Analysis (EDA) on Newborn Sepsis Cases in MIMIC-III Database

Description:
This SQL script is designed to perform a comprehensive EDA focused on sepsis-related admissions in the MIMIC-III clinical database. The analysis covers various aspects including frequency of sepsis diagnoses, filtering ICD9 codes for sepsis and septicemia, detailed examination of neonatal sepsis cases, and comparisons with established sepsis criteria by Angus et al., and Martin et al. The goal is to derive insights into the prevalence, demographics, and outcomes of sepsis patients within the database.

Scope:
- Identification and frequency analysis of sepsis-related diagnoses.
- Filtering and analysis of ICD9 codes specifically indicating sepsis and septicemia.
- Detailed examination of admissions associated with neonatal sepsis.
- Comparison of identified neonatal sepsis cases with Angus/Martin criteria for sepsis.
- Analysis of patient demographics and outcomes, including gender and ethnicity distribution, and mortality rates among sepsis patients.
- To be added

Prerequisites:
- Access to the MIMIC-III database with appropriate permissions.
- Familiarity with SQL and the structure of the MIMIC-III database.

Notes:
- Ensure the search_path is set to mimiciii before executing the queries.
- Review and adjust the threshold values and conditions as necessary for your specific analysis needs.

References:
- Angus et al., 2001. Epidemiology of severe sepsis in the United States: Analysis of incidence, outcome, and associated costs of care. PMID: 11445675
- Martin et al., 2003. The epidemiology of sepsis in the United States from 1979 through 2000. PMID: 12700374

*/


SET search_path to mimiciii;

--0. Find Diagnoses Occurring More Than a Specified Number of Times
SELECT 
    DIAGNOSIS, 
    COUNT(*) AS Diagnosis_Frequency
FROM 
    ADMISSIONS
GROUP BY 
    DIAGNOSIS
HAVING 
    COUNT(*) > 100
Order by Diagnosis_Frequency DESC; -- Change the number based on the desired threshold

--1. Filter out ICD9 codes that have a short title including sepsis
SELECT ICD9_CODE, SHORT_TITLE
FROM D_ICD_DIAGNOSES
WHERE SHORT_TITLE LIKE '%sepsis%';

--2. Filter out ICD9 codes that have a short title including sepsis and septicemia
-- Drop the existing view if it exists to avoid errors during creation
DROP VIEW IF EXISTS v_ic_diagnoses;

-- Create a view named v_ic_diagnoses
-- This view filters and lists all ICD9 diagnosis codes specifically related to sepsis and septicemia
-- It helps in quickly identifying all records associated with these conditions for further analysis
CREATE VIEW v_ic_diagnoses AS 
SELECT 
    ICD9_CODE, -- Diagnosis code
    SHORT_TITLE -- Short title of the diagnosis
FROM 
    D_ICD_DIAGNOSES -- Source table containing ICD9 diagnosis codes and titles
WHERE 
    SHORT_TITLE LIKE '%sepsis%' -- Filter condition for 'sepsis'
    OR SHORT_TITLE LIKE '%septicemia%'; -- Filter condition for 'septicemia'


--3. Filter out all admissions associated with neonatal sepsis
DROP TABLE IF EXISTS SEPSIS_NBTBL CASCADE;
SELECT *
INTO SEPSIS_NBTBL
FROM (
SELECT d.SUBJECT_ID, d.HADM_ID, d.ADMITTIME, d.DISCHTIME, d.DIAGNOSIS, c.ICD9_CODE,
c.SHORT_TITLE
FROM ADMISSIONS d
JOIN (
SELECT b.SUBJECT_ID, b.HADM_ID, b.ICD9_CODE, a.SHORT_TITLE
FROM D_ICD_DIAGNOSES a
JOIN DIAGNOSES_ICD b ON a.ICD9_CODE = b.ICD9_CODE) c ON d.HADM_ID = c.HADM_ID
WHERE ((c.SHORT_TITLE LIKE '%septicemia%' OR c.SHORT_TITLE LIKE '%sepsis%' ) AND
d.DIAGNOSIS LIKE '%NEWBORN%')
OR c.SHORT_TITLE like '%NB septicemia%
') e;

--** compare with our selection criteria with Angus/Martin criteria of newborn sepsis
-- Angus et al, 2001. Epidemiology of severe sepsis in the United States
-- http://www.ncbi.nlm.nih.gov/pubmed/11445675
-- Greg S. Martin, David M. Mannino, Stephanie Eaton, and Marc Moss. The epidemiology of
-- sepsis in the united states from 1979 through 2000. N Engl J Med, 348(16):1546–1554, Apr
-- 2003. doi: 10.1056/NEJMoa022139. URL http://dx.doi.org/10.1056/NEJMoa022139.
SELECT b.*
FROM (
    SELECT a.subject_id, a.hadm_id, b.angus, c.sepsis
    FROM admissions a
    JOIN angus b ON (a.hadm_id = b.hadm_id)
    JOIN martin c ON (a.hadm_id = c.hadm_id)
    WHERE a.DIAGNOSIS LIKE '%NEWBORN%' 
    AND (b.angus = 1 OR c.sepsis = 1)
) a
RIGHT JOIN sepsis_nbtbl b ON a.hadm_id = b.hadm_id
WHERE a.angus IS NULL AND a.sepsis IS NULL;

--4. The total number of admissions among neonatal sepsis patients
SELECT COUNT(*)
FROM (
SELECT DISTINCT HADM_ID
FROM SEPSIS_NBTBL
) a;

--5. The total number of neonatal sepsis patients
SELECT COUNT(*)
FROM(
SELECT DISTINCT SUBJECT_ID
FROM SEPSIS_NBTBL
) a;

--6. Gender distribution of neonatal sepsis patients by death outcome
SELECT A.GENDER, A.EXPIRE_FLAG, COUNT(A.GENDER) AS COUNT_BY_EPIRE_FLAG
FROM (
SELECT DISTINCT(P.SUBJECT_ID),GENDER, EXPIRE_FLAG
FROM PATIENTS P
JOIN SEPSIS_NBTBL ON P.SUBJECT_ID = SEPSIS_NBTBL.SUBJECT_ID
) A
GROUP BY EXPIRE_FLAG,GENDER;

--7. Ethnicity distribution of neonatal sepsis patients
DROP TABLE IF EXISTS ethnicity_nbtbl;
SELECT *
INTO ETHNICITY_NBTBL
FROM (
SELECT A.ETHNICITY, COUNT(A.ETHNICITY) AS COUNT_ETHNICITY
FROM (
SELECT DISTINCT(AD.SUBJECT_ID), ETHNICITY
FROM ADMISSIONS AD
JOIN SEPSIS_NBTBL ON AD.SUBJECT_ID = SEPSIS_NBTBL.SUBJECT_ID) A
GROUP BY ETHNICITY
) B;

SELECT A.ETHNICITY_VAGUE, SUM(COUNT_ETHNICITY) AS COUNT_ETHNICITY
FROM ETHNICITY_NBTBL
JOIN (
SELECT ETHNICITY,
CASE WHEN (ETHNICITY LIKE '%BLACK%') THEN 'BLACK'
	WHEN (ETHNICITY LIKE '%WHITE%') THEN 'WHITE'
	WHEN (ETHNICITY LIKE '%ASIAN%') THEN 'ASIAN'
	WHEN (ETHNICITY LIKE '%HISPANIC%') THEN 'HISPANIC'
	WHEN (ETHNICITY LIKE '%UNKNOWN%' OR ETHNICITY LIKE '%UNABLE') THEN 'UNKNOWN' ELSE 'OTHER'
END AS ETHNICITY_VAGUE
FROM ETHNICITY_NBTBL) A
ON ETHNICITY_NBTBL.ETHNICITY = A.ETHNICITY
GROUP BY ETHNICITY_VAGUE
ORDER BY (
CASE ETHNICITY_VAGUE WHEN 'WHITE' THEN 1
WHEN 'BLACK' THEN 2
WHEN 'ASIAN' THEN 3
WHEN 'HISPANIC' THEN 4
WHEN 'OTHER' THEN 5
WHEN 'UNKNOWN' THEN 6 END
) ASC;

--8. Death Rate of neonatal sepsis patients
DROP TABLE IF EXISTS deathsum_tbl;
SELECT *
INTO DEATHSUM_TBL
FROM (
SELECT EXPIRE_FLAG, COUNT (EXPIRE_FLAG) AS DIAGNOSES_COUNT
FROM (
SELECT DISTINCT(P.SUBJECT_ID), EXPIRE_FLAG
FROM PATIENTS P
JOIN SEPSIS_NBTBL ON P.SUBJECT_ID = SEPSIS_NBTBL.SUBJECT_ID ) a
GROUP BY EXPIRE_FLAG
) b;

SELECT
    *,
    TO_CHAR(
        CAST(DIAGNOSES_COUNT AS NUMERIC) / TOTAL,
        'FM999999990.0000%'
    ) AS PERCENTAGE
FROM (
    SELECT
        DEATHSUM_TBL.*,
        (SELECT SUM(DIAGNOSES_COUNT) FROM DEATHSUM_TBL) AS TOTAL
    FROM DEATHSUM_TBL
) AS c;

--9. Analysis of death outcome and ICU stay
-- * ICU stay information
SELECT 
    a.* 
FROM 
    icustay_detail a 
JOIN 
    sepsis_nbtbl b 
ON 
    a.hadm_id = b.hadm_id; 

--1) Average Length of Stay
Drop TABLE IF EXISTS AVR_STAY_TBL;
SELECT
    EXPIRE_FLAG,
    AVG(TIME_INTERVAL::INT) AS AVERAGE_STAY_IN_ICU
INTO AVR_STAY_TBL
FROM (
    SELECT
        DISTINCT P.SUBJECT_ID,
        EXPIRE_FLAG,
        (DISCHTIME::DATE - ADMITTIME::DATE) AS TIME_INTERVAL
    FROM PATIENTS P
    JOIN SEPSIS_NBTBL ON P.SUBJECT_ID = SEPSIS_NBTBL.SUBJECT_ID
) a
GROUP BY EXPIRE_FLAG;

DROP TABLE IF EXISTS death_rate_tbl;
SELECT
    c.*,
    TO_CHAR(
        CAST(DIAGNOSES_COUNT AS NUMERIC) / CAST(TOTAL AS NUMERIC),
        'FM999999990.0000%'
    ) AS PERCENTAGE
INTO DEATH_RATE_TBL
FROM (
    SELECT
        DEATHSUM_TBL.*,
        b.TOTAL
    FROM DEATHSUM_TBL
    CROSS JOIN (
        SELECT SUM(DIAGNOSES_COUNT) AS TOTAL
        FROM DEATHSUM_TBL
    ) b
) c;

SELECT a.EXPIRE_FLAG, AVERAGE_STAY_IN_ICU, DIAGNOSES_COUNT
FROM AVR_STAY_TBL a
JOIN DEATH_RATE_TBL b
ON a.EXPIRE_FLAG = b.EXPIRE_FLAG;

--2) Death outcome with 15 days after admission
DROP TABLE IF EXISTS death_rate_tbl;
SELECT
    *,
    TO_CHAR(CAST(diagnoses_count AS NUMERIC) / total, 'FM999990.0000%') AS percentage
INTO death_rate_tbl
FROM (
    SELECT
        deathsum_tbl.*,
        (SELECT SUM(diagnoses_count) FROM deathsum_tbl) AS total
    FROM deathsum_tbl
) AS c;

DROP TABLE IF EXISTS time_interval_tbl_1;
SELECT
    ad.subject_id,
    expire_flag,
    time_interval,
    CASE
        WHEN time_interval > 15 THEN 1
        ELSE 0
    END AS time_interval_15
INTO time_interval_tbl_1
FROM admissions ad
JOIN (
    SELECT
        p.subject_id,
        expire_flag,
        EXTRACT(DAY FROM (dischtime::timestamp - admittime::timestamp)) AS time_interval
    FROM patients p
    JOIN sepsis_nbtbl ON p.subject_id = sepsis_nbtbl.subject_id
) a ON ad.subject_id = a.subject_id;

SELECT
    *,
    TO_CHAR(CAST(num_time_interval_15 AS NUMERIC) / CAST(diagnoses_count AS NUMERIC), 'FM999990.0000%') AS percentage
FROM (
    SELECT
        DISTINCT a.expire_flag,
        diagnoses_count,
        num_time_interval_15
    FROM death_rate_tbl a
    JOIN (
        SELECT
            expire_flag,
            SUM(time_interval_15) AS num_time_interval_15
        FROM time_interval_tbl_1
        GROUP BY expire_flag
    ) b ON a.expire_flag = b.expire_flag
) d
WHERE expire_flag = 1;

--3) data preparation for a logistic regression on death outcome and length of stay
SELECT
    AD.SUBJECT_ID,
    A.EXPIRE_FLAG,
    (AD.DISCHTIME::DATE - AD.ADMITTIME::DATE) AS TIME_INTERVAL
FROM
    ADMISSIONS AD
JOIN (
    SELECT
        P.SUBJECT_ID,
        P.EXPIRE_FLAG,
        (DISCHTIME - ADMITTIME) AS TIME_INTERVAL
    FROM
        PATIENTS P
    JOIN SEPSIS_NBTBL ON P.SUBJECT_ID = SEPSIS_NBTBL.SUBJECT_ID
) A ON AD.SUBJECT_ID = A.SUBJECT_ID;


--10. Microbiology Test
DROP TABLE IF EXISTS MB_SEPSIS_TBL;
SELECT *
INTO MB_SEPSIS_TBL
FROM(
SELECT DISTINCT(c.SUBJECT_ID), c.HADM_ID, c.ORG_ITEMID, d.LABEL ,c.ORG_NAME
FROM D_ITEMS d
JOIN (
SELECT a.SUBJECT_ID, a.HADM_ID, b.ORG_ITEMID, b.ORG_NAME
FROM SEPSIS_NBTBL a
JOIN MICROBIOLOGYEVENTS b ON a.HADM_ID = b.HADM_ID
) c ON d.ITEMID = c.ORG_ITEMID
)e;

--1) A full list of microbiology test results of neonatal sepsis patients
DROP TABLE IF EXISTS FULL_MB_NS;
SELECT *
INTO FULL_MB_NS
FROM(
SELECT c.SUBJECT_ID, c.HADM_ID, c.ORG_ITEMID, d.LABEL ,c.ORG_NAME
FROM D_ITEMS d
RIGHT JOIN (
SELECT a.SUBJECT_ID, a.HADM_ID, b.ORG_ITEMID, b.ORG_NAME
FROM SEPSIS_NBTBL a
LEFT JOIN MICROBIOLOGYEVENTS b ON a.HADM_ID = b.HADM_ID
) c
ON d.ITEMID = c.ORG_ITEMID
) e;

--2) the distribution of numbers of microbes identified among neonatal sepsis patients
DROP TABLE IF EXISTS count_num_mb;
CREATE TEMP TABLE COUNT_NUM_MB AS
SELECT
    b.n AS num_of_microbes,
    COUNT(b.hadm_id) AS count
FROM (
    SELECT
        hadm_id,
        COUNT(DISTINCT org_name) AS n
    FROM full_mb_ns
    GROUP BY hadm_id
) AS b
GROUP BY b.n;

--3) the total number of neonatal sepsis patients with identified microbes
SELECT SUM(count) AS "Total_#_of_Patients_with_Microbes"
FROM (
    SELECT b.n, COUNT(b.hadm_id) AS count
    FROM (
        SELECT hadm_id, COUNT(DISTINCT org_name) AS n
        FROM full_mb_ns
        GROUP BY hadm_id
    ) AS b
    GROUP BY b.n
) AS c
WHERE c.n <> 0;

--4) the number of occurrences of each microbe (with frequency < 0.01 combined)
DROP TABLE IF EXISTS OCC_MB;
CREATE TABLE OCC_MB AS
WITH freq_calc AS (
    SELECT
        ORG_NAME,
        COUNT(DISTINCT HADM_ID) AS n,
        104 AS total, -- Assuming 'total' is a fixed value
        (CAST(COUNT(DISTINCT HADM_ID) AS NUMERIC) / 104) AS freq
    FROM
        FULL_MB_NS
    WHERE
        ORG_NAME <> 'None'
    GROUP BY
        ORG_NAME
)
SELECT
    CASE
        WHEN freq < 0.01 THEN 'other'
        ELSE ORG_NAME
    END AS org_name,
    SUM(n) AS count_all,
    SUM(freq) * 100 AS perc -- Multiplying by 100 to convert to percentage
FROM
    freq_calc
GROUP BY
    CASE
        WHEN freq < 0.01 THEN 'other'
        ELSE ORG_NAME
    END;

--5) Create a view to rank the sepsis patients by the number of different microbes identified
CREATE VIEW Ranked_Patients_Microbes AS
WITH Microbe_Counts AS (
    SELECT 
        SEPSIS_NBTBL.SUBJECT_ID, 
        COUNT(DISTINCT MICROBIOLOGYEVENTS.ORG_NAME) AS Microbe_Count
    FROM 
        SEPSIS_NBTBL
    JOIN MICROBIOLOGYEVENTS ON SEPSIS_NBTBL.HADM_ID = MICROBIOLOGYEVENTS.HADM_ID
    GROUP BY 
        SEPSIS_NBTBL.SUBJECT_ID
)
SELECT 
    SUBJECT_ID,
    Microbe_Count,
    RANK() OVER (ORDER BY Microbe_Count DESC) AS Microbe_Rank
FROM 
    Microbe_Counts;
	