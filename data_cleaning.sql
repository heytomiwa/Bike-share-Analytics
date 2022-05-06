/*
	Data cleaning
*/

-- Combine data from all the quarters and inspect.
CREATE TABLE "2019_user_analytics".user_data_2019
AS (
	SELECT *, 'Q1' AS quarter
	FROM "2019_user_analytics".user_data_2019_q1
	UNION
	SELECT *, 'Q2'
	FROM "2019_user_analytics".user_data_2019_q2
	UNION
	SELECT *, 'Q3'
	FROM "2019_user_analytics".user_data_2019_q3
	UNION
	SELECT *, 'Q4'
	FROM "2019_user_analytics".user_data_2019_q4
);

SELECT *
FROM "2019_user_analytics".user_data_2019
LIMIT 10;

SELECT COUNT(*) -- Number of Records
FROM "2019_user_analytics".user_data_2019;

-- Removing trip_data on checking stations
SELECT DISTINCT(from_station_name)
FROM "2019_user_analytics".user_data_2019
WHERE (from_station_name LIKE '%CHECK%' or from_station_name LIKE '%B/C%') or (to_station_name LIKE '%CHECK%' or to_station_name LIKE '%B/C%');

SELECT *
FROM "2019_user_analytics".user_data_2019
WHERE (to_station_name LIKE '%CHECK%' or from_station_name LIKE '%CHECK%') or (to_station_name LIKE '%B/C%' or from_station_name LIKE '%B/C%');

DELETE FROM "2019_user_analytics".user_data_2019
WHERE (to_station_name LIKE '%CHECK%' or from_station_name LIKE '%CHECK%') or (to_station_name LIKE '%B/C%' or from_station_name LIKE '%B/C%');

-- Calculating the propotion of null values per columns.
SELECT
	user_type,
	(CAST(SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*))*100 AS GenderPercentMissing,
	(CAST(SUM(CASE WHEN birth_year IS NULL THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*))*100 AS BirthyearPercentMissing
FROM "2019_user_analytics".user_data_2019
GROUP BY user_type;

--Removing columns that do not meet quality standard for analysis.
/*
	gender: Data is incomplete and can not be used to describe difference/relationship between user types.
	birth_year: Data is inacurate and incomplete.
*/
ALTER TABLE "2019_user_analytics".user_data_2019
DROP COLUMN gender;

ALTER TABLE "2019_user_analytics".user_data_2019
DROP COLUMN birth_year;

-- Create columns: Day Month, Seson
--Day
ALTER TABLE "2019_user_analytics".user_data_2019
ADD COLUMN day VARCHAR(10);

UPDATE "2019_user_analytics".user_data_2019
SET day = to_char(start_time, 'Day')
--Month
ALTER TABLE "2019_user_analytics".user_data_2019
ADD COLUMN month VARCHAR(10);

UPDATE "2019_user_analytics".user_data_2019
SET month = TRIM(to_char(start_time, 'Month'))
--Season
ALTER TABLE "2019_user_analytics".user_data_2019
ADD COLUMN season VARCHAR(6);

UPDATE "2019_user_analytics".user_data_2019
SET season = CASE
           WHEN EXTRACT(MONTH FROM start_time)>=3 AND EXTRACT(MONTH FROM start_time)<=5 THEN 'Spring'
           WHEN EXTRACT(MONTH FROM start_time)>=6 AND EXTRACT(MONTH FROM start_time)<=8 THEN 'Summer'
           WHEN EXTRACT(MONTH FROM start_time)>=9 AND EXTRACT(MONTH FROM start_time)<=11 THEN 'Fall'
           ELSE 'Winter' -- definition for ELSE case is missing
        END;



