/*
	Queries used in Analysis.
	Columns: trip_id, start_time, end_time, bike_id, trip_duration, from_station_id, from_station_name, to_station_id, to_station_name, user_type, quarter, day, month, season
*/

-- Overview of User Data
SELECT *
from "2019_user_analytics".user_data_2019
order by trip_id
limit 100
-----------------------------------------------------------------------------------------------------------

-- Total Number of Trips
SELECT COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
--- Number of trips by user type
SELECT user_type, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY  user_type

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-- Summary statistics/Descriptive Analysis on trip duration
SELECT
	PERCENTILE_DISC(0) WITHIN GROUP(ORDER BY trip_duration) MINIMUM,
	PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY trip_duration) "2ndPercentile",
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY trip_duration) MEDIAN,
	PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY trip_duration) "3rdPercentile",
	PERCENTILE_DISC(1) WITHIN GROUP(ORDER BY trip_duration) MAXIMUM,
	AVG(trip_duration) AVERAGE,
	STDDEV(trip_duration) StandardDeviation
FROM "2019_user_analytics".user_data_2019

-----------------------------------------------------------------------------------------------------------
-- Deep dive:
-----------------------------------------------------------------------------------------------------------
-- Looking for differences between user types

-- trip duration information by user_type
SELECT 
		user_type,
		PERCENTILE_DISC(0) WITHIN GROUP(ORDER BY trip_duration) MINIMUM,
		PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY trip_duration) "2ndPercentile",
		PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY trip_duration) MEDIAN,
		PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY trip_duration) "3rdPercentile",
		PERCENTILE_DISC(1) WITHIN GROUP(ORDER BY trip_duration) MAXIMUM,
		AVG(trip_duration) AVERAGE,
		STDDEV(trip_duration) StandardDeviation
FROM "2019_user_analytics".user_data_2019
GROUP BY user_type

-----------------------------------------------------------------------------------------------------------
-- Weekly Breakdown

--- Number of trips by user type per weeekday
SELECT day, user_type, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY day, user_type
ORDER BY user_type, TotalNumberOfTrips DESC

--- Number of trips by user type per weeekday
SELECT day, user_type, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY day, user_type
ORDER BY user_type, TotalNumberOfTrips DESC

--Average and standard deviation of trip duration by user_type per weekday
SELECT day, user_type, AVG(trip_duration) Average, STDDEV(trip_duration) StandardDeviation
FROM "2019_user_analytics".user_data_2019
GROUP BY day, user_type
ORDER BY 
		user_type,
		average DESC
		
--Count, Average and standard deviation of trip duration by user_type per weekday
SELECT day, user_type, count(*) NumberOfTrips, AVG(trip_duration) Average, STDDEV(trip_duration) StandardDeviation
FROM "2019_user_analytics".user_data_2019
GROUP BY day, user_type
ORDER BY 
		user_type,
-- 		average DESC
		NumberOfTrips DESC
-----------------------------------------------------------------------------------------------------------
-- Monthly Breakdown

--- Number of trips by month
SELECT month, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY month
ORDER BY TotalNumberOfTrips DESC

--- Number of trips by user type per month
SELECT user_type, month, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY user_type, month
ORDER BY user_type, TotalNumberOfTrips DESC

--Average and standard deviation of trip duration by user_type per month
SELECT month, user_type, AVG(trip_duration) Average, STDDEV(trip_duration) StandardDeviation
FROM "2019_user_analytics".user_data_2019
GROUP BY month, user_type
ORDER BY user_type, average DESC
-----------------------------------------------------------------------------------------------------------
-- Seasonal Breakdown
--- Number of trips by season
SELECT season, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY season
ORDER BY TotalNumberOfTrips DESC

--- Number of trips by user type per season
SELECT season, user_type, COUNT(*) TotalNumberOfTrips
FROM "2019_user_analytics".user_data_2019
GROUP BY season, user_type
ORDER BY user_type, TotalNumberOfTrips DESC

-- Average and standard deviation of trip duration by user_type per season
SELECT season, user_type, AVG(trip_duration) average, STDDEV(trip_duration) StandardDeviation
FROM "2019_user_analytics".user_data_2019
GROUP BY season, user_type
--ORDER BY user_type, average DESC
-----------------------------------------------------------------------------------------------------------







-- -- trips that are lsted more than a month
-- select *
-- from "2019_user_analytics".user_data_2019
-- --where trip_duration last for more long periods.
-- where (cast(extract(month from end_time) as integer)-cast(extract(month from start_time) as integer))>1
-- order by trip_duration

-- select quarter, user_type, avg(trip_duration)
-- from "2019_user_analytics".user_data_2019
-- -- where quarter='Q3'
-- group by quarter, user_type

-- select from_station_name, user_type, avg(trip_duration) as avg_, count(*) as count_
-- from "2019_user_analytics".user_data_2019
-- group by from_station_name, user_type
-- order by avg_ desc
-- limit 10



-- LAG ( value anycompatible [, offset integer [, default anycompatible ]] )
