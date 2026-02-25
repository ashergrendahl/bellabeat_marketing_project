USE	Bellabeat

--Checking for null values in CaloriesBySeconds--
SELECT * FROM dbo.CaloriesByHour;
SELECT * from dbo.CaloriesByHour WHERE Id IS NULL;
SELECT * from dbo.CaloriesByHour WHERE ActivityHour IS NULL;
SELECT * from dbo.CaloriesByHour WHERE Calories IS NULL;
--No null values--
SELECT COUNT(DISTINCT Id)
FROM dbo.CaloriesByHour;

--Checking for null values in DailyActivity--
SELECT * FROM dbo.DailyActivity;
SELECT * FROM dbo.DailyActivity WHERE ActivityDate IS NULL;
SELECT * FROM dbo.DailyActivity WHERE TotalDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE TrackerDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE LoggedActivitiesDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE VeryActiveDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE ModeratelyActiveDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE LightActiveDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE SedentaryActiveDistance IS NULL;
SELECT * FROM dbo.DailyActivity WHERE VeryActiveMinutes IS NULL;
SELECT * FROM dbo.DailyActivity WHERE FairlyActiveMinutes IS NULL;
SELECT * FROM dbo.DailyActivity WHERE LightlyActiveMinutes IS NULL;
SELECT * FROM dbo.DailyActivity WHERE SedentaryMinutes IS NULL;
SELECT * FROM dbo.DailyActivity WHERE Calories IS NULL;
--No null values--
SELECT COUNT(DISTINCT Id)
FROM dbo.DailyActivity;

--Checking for null values in HeartrateBySeconds and changing column names. 
SELECT * FROM dbo.HeartrateBySeconds
EXEC sp_rename 'HeartrateBySeconds.Time', 'TrackTime', 'COLUMN';
EXEC sp_rename 'HeartrateBySeconds.Value', 'HeartRate', 'COLUMN';
SELECT * FROM dbo.HeartrateBySeconds WHERE Id IS NULL;
SELECT * FROM dbo.HeartrateBySeconds WHERE TrackTime IS NULL;
SELECT * FROM dbo.HeartrateBySeconds WHERE HeartRate IS NULL;
--No null values--
--Some fitbit models allow you to limit or disable heartrate tracking, which could be why only 14 of the 35 users are showing up-- 
SELECT COUNT(DISTINCT Id)
FROM dbo.HeartrateBySeconds;

--Checking for nulls in IntensitiesByHours--
SELECT * FROM dbo.IntensitiesByHours;
SELECT * FROM dbo.IntensitiesByHours WHERE Id IS NULL;
SELECT * FROM dbo.IntensitiesByHours WHERE ActivityHour IS NULL;
SELECT * FROM dbo.IntensitiesByHours WHERE TotalIntensity IS NULL;
SELECT * FROM dbo.IntensitiesByHours WHERE AverageIntensity IS NULL;
--No null values--
SELECT COUNT(DISTINCT Id)
FROM dbo.IntensitiesByHours;

--Checking for null values in SleepByMinutes and changing column names-- 
SELECT * FROM dbo.SleepByMinutes;
EXEC sp_rename 'SleepByMinutes.date', 'TrackDate', 'COLUMN';
EXEC sp_rename 'SleepByMinutes.value', 'SleepValue', 'COLUMN';
SELECT * FROM dbo.SleepByMinutes WHERE Id IS NULL;
SELECT * FROM dbo.SleepByMinutes WHERE TrackDate IS NULL;
SELECT * FROM dbo.SleepByMinutes WHERE SleepValue IS NULL;
SELECT * FROM dbo.SleepByMinutes WHERE logId IS NULL;
--No null values--
SELECT COUNT(DISTINCT Id)
FROM dbo.SleepByMinutes;

--Checking for nulls in StepsByHours
SELECT * FROM dbo.StepsByHours;
SELECT * FROM dbo.StepsByHours WHERE Id IS NULL;
SELECT * FROM dbo.StepsByHours WHERE ActivityHour IS NULL;
SELECT * FROM dbo.StepsByHours WHERE StepTotal IS NULL;
--No null values--
SELECT COUNT(DISTINCT Id)
FROM dbo.StepsByHours;

--Checking for shared columns accross all tables--
SELECT COLUMN_NAME, STRING_AGG(TABLE_NAME, ', ') AS tables, COUNT(*) AS occurrence_count
FROM INFORMATION_SCHEMA.COLUMNS
GROUP BY COLUMN_NAME
ORDER BY occurrence_count DESC;
--Id is seen in all tables, ActivityHour is in StepsByHours, IntensitiesByHours, and CaloriesByHour. Calories is seen in CaloriesByHour and DailyActivity--

--Now I want to see what this value column means. 
SELECT 
	"SleepValue",
	COUNT(*) AS count_rows
FROM dbo.SleepByMinutes
GROUP BY "SleepValue"
ORDER BY "SleepValue";

SELECT 
	Id,
	logId,
	COUNT(*) AS minutes_logged
FROM dbo.SleepByMinutes
GROUP BY Id, logId
ORDER BY minutes_logged;

SELECT 
	logId, 
	SUM(CASE WHEN SleepValue = 3 THEN 0 ELSE 1 END) AS minutes_asleep
FROM DBO.SleepByMinutes 
GROUP BY logId
ORDER BY minutes_asleep;
--My theory for what the values mean are based on the the previous query are 1: asleep 2: restless 3: awake since i assumed the value tracked minutes and they add up to--
--Because the value is not specified, there are no concrete conclusions we can make on it. 

--Calories per day
SELECT 
	Id,
	(CAST(ActivityHour AS DATE)) AS log_date,
	SUM(calories) AS _total_calories
FROM dbo.CaloriesByHour
GROUP BY Id, CAST(ActivityHour AS DATE)
ORDER BY Id, log_date;

--Checking for average calories per Id
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityHour AS DATE) AS log_date,
        SUM(Calories) AS total_calories
    FROM dbo.CaloriesByHour
    GROUP BY Id, CAST(ActivityHour AS DATE)
)

SELECT
    Id,
    AVG(total_calories * 1.0) AS avg_daily_calories
FROM daily_totals
GROUP BY Id
ORDER BY avg_daily_calories;

--looking at average heartrate--
SELECT 
	Id, 
	AVG(Heartrate) AS avg_heartrate
FROM dbo.HeartrateBySeconds
GROUP BY Id
ORDER BY avg_heartrate

--Looking for users who use the tracking features on the fitbit--
SELECT 
    u.Id,

    CASE WHEN EXISTS (
        SELECT 1 FROM dbo.SleepByMinutes s 
        WHERE s.Id = u.Id
    ) THEN 1 ELSE 0 END AS tracks_sleep,

    CASE WHEN EXISTS (
        SELECT 1 FROM dbo.HeartrateBySeconds h 
        WHERE h.Id = u.Id
    ) THEN 1 ELSE 0 END AS tracks_heartrate,

    CASE WHEN EXISTS (
        SELECT 1 FROM dbo.CaloriesByHour c 
        WHERE c.Id = u.Id
    ) THEN 1 ELSE 0 END AS tracks_calories,

    -- Tracking Score
    (
        CASE WHEN EXISTS (
            SELECT 1 FROM dbo.SleepByMinutes s 
            WHERE s.Id = u.Id
        ) THEN 1 ELSE 0 END
        +
        CASE WHEN EXISTS (
            SELECT 1 FROM dbo.HeartrateBySeconds h 
            WHERE h.Id = u.Id
        ) THEN 1 ELSE 0 END
        +
        CASE WHEN EXISTS (
            SELECT 1 FROM dbo.CaloriesByHour c 
            WHERE c.Id = u.Id
        ) THEN 1 ELSE 0 END
    ) AS tracking_score

FROM (
    SELECT DISTINCT Id FROM dbo.DailyActivity
) u
ORDER BY tracking_score DESC;


--Tracking the total amount of engagement of the fitbit features. I found the max, min, and average in order to determine what I consider to be high medium or low engagement. 

CREATE VIEW dbo.UserEngagement AS
WITH 
sleep_days AS (
    SELECT 
        Id, 
        COUNT(DISTINCT CAST(TrackDate AS DATE)) AS sleep_days
    FROM dbo.SleepByMinutes
    WHERE TrackDate IS NOT NULL
    GROUP BY Id 
), 
heartrate_days AS (
    SELECT
        Id, 
        COUNT(DISTINCT CAST(TrackTime AS DATE)) AS hr_days
    FROM dbo.HeartrateBySeconds
    GROUP BY Id 
), 
calorie_days AS (
    SELECT
        Id, 
        COUNT(DISTINCT CAST(ActivityHour AS DATE)) AS cal_days
    FROM dbo.CaloriesByHour
    GROUP BY Id
)

SELECT 
    u.Id,

    COALESCE(s.sleep_days, 0) AS sleep_days,
    COALESCE(h.hr_days, 0) AS hr_days,
    COALESCE(c.cal_days, 0) AS cal_days,

    -- Total Engagement
    COALESCE(s.sleep_days, 0)
    + COALESCE(h.hr_days, 0)
    + COALESCE(c.cal_days, 0) AS total_engagement_days,

    -- Engagement Group
    CASE 
        WHEN (
            COALESCE(s.sleep_days, 0)
            + COALESCE(h.hr_days, 0)
            + COALESCE(c.cal_days, 0)
        ) >= 60 THEN 'High'

        WHEN (
            COALESCE(s.sleep_days, 0)
            + COALESCE(h.hr_days, 0)
            + COALESCE(c.cal_days, 0)
        ) >= 40 THEN 'Medium'

        ELSE 'Low'
    END AS engagement_group

FROM (SELECT DISTINCT Id FROM dbo.DailyActivity) u
LEFT JOIN sleep_days s ON u.Id = s.Id
LEFT JOIN heartrate_days h ON u.Id = h.Id
LEFT JOIN calorie_days c ON u.Id = c.Id;

SELECT 
MAX(total_engagement_days) AS max_eng,
MIN(total_engagement_days) AS min_eng,
AVG(total_engagement_days) AS avg_eng
FROM dbo.UserEngagement

SELECT 
	id, engagement_group
FROM dbo.UserEngagement
GROUP BY engagement_group, Id
ORDER BY engagement_group

--Checking for correlation between engagement and heartrate--
WITH AvgHeartrate AS (
	SELECT 
		Id,
		AVG(HeartRate) AS avg_heartrate
	FROM dbo.HeartrateBySeconds
	GROUP BY Id
	)
SELECT 
	a.Id,
	a.avg_heartrate,
	ue.engagement_group
FROM AvgHeartrate a
LEFT JOIN dbo.UserEngagement ue
ON a.Id = ue.Id
ORDER BY a.avg_heartrate

--Checking for correlation between engagement and calories--
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityHour AS DATE) AS log_date,
        SUM(Calories) AS total_calories
    FROM dbo.CaloriesByHour
    GROUP BY Id, CAST(ActivityHour AS DATE)
),
avg_daily_calories AS (
    SELECT
        Id,
        AVG(total_calories * 1.0) AS avg_daily_calories
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    a.Id,
    a.avg_daily_calories,
    ue.engagement_group
FROM avg_daily_calories a
LEFT JOIN dbo.UserEngagement ue
    ON a.Id = ue.Id
ORDER BY a.avg_daily_calories;

--Checking for correlation between engagement and intensity--
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityHour AS DATE) AS log_date,
        SUM(TotalIntensity) AS total_intensity
    FROM dbo.IntensitiesByHours
    GROUP BY Id, CAST(ActivityHour AS DATE)
),
avg_daily_intensity AS (
    SELECT
        Id,
        AVG(total_intensity * 1.0) AS avg_daily_intensity
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    a.Id,
    a.avg_daily_intensity,
    ue.engagement_group
FROM avg_daily_intensity a
LEFT JOIN dbo.UserEngagement ue
    ON a.Id = ue.Id
ORDER BY a.avg_daily_intensity;

--Checking for correlation between sleep and engagement levels--
WITH sleep_per_night AS (
    SELECT
        Id,
        CAST(TrackDate AS DATE) AS log_date,
        SUM(CASE WHEN SleepValue = 1 THEN 1 ELSE 0 END) AS minutes_asleep
    FROM dbo.SleepByMinutes
    GROUP BY Id, CAST(TrackDate AS DATE)
), 
avg_sleep AS (
    SELECT
        Id,
        AVG(minutes_asleep * 1.0) AS avg_minutes_asleep
    FROM sleep_per_night
    GROUP BY Id
)
SELECT
    s.Id,
    s.avg_minutes_asleep,
    ue.engagement_group
FROM avg_sleep s
LEFT JOIN dbo.UserEngagement ue
    ON s.Id = ue.Id
ORDER BY s.avg_minutes_asleep DESC; 

--Checking for correlation between steps and engagement levels--
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityHour AS DATE) AS log_date,
        SUM(StepTotal) AS total_steps
    FROM dbo.StepsByHours
    GROUP BY Id, CAST(ActivityHour AS DATE)
),
avg_daily_steps AS (
    SELECT
        Id,
        AVG(total_steps * 1.0) AS avg_daily_steps
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    s.Id,
    s.avg_daily_steps,
    ue.engagement_group
FROM avg_daily_steps s
LEFT JOIN dbo.UserEngagement ue
    ON s.Id = ue.Id
ORDER BY s.avg_daily_steps;

--Checking for corelation between very, fairly, lightly, and sedentary active minutes and engagement--
--Very Active Minutes-
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityDate AS DATE) AS log_date,
        SUM(VeryActiveMinutes) AS total_minutes
    FROM dbo.DailyActivity
    GROUP BY Id, CAST(ActivityDate AS DATE)
),
avg_daily_activity AS (
    SELECT
        Id,
        AVG(total_minutes * 1.0) AS avg_daily_activity
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    a.Id,
    a.avg_daily_activity,
    ue.engagement_group
FROM avg_daily_activity a
LEFT JOIN dbo.UserEngagement ue
    ON a.Id = ue.Id
ORDER BY a.avg_daily_activity;

--Fairly Active Minutes--
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityDate AS DATE) AS log_date,
        SUM(FairlyActiveMinutes) AS total_minutes
    FROM dbo.DailyActivity
    GROUP BY Id, CAST(ActivityDate AS DATE)
),
avg_daily_activity AS (
    SELECT
        Id,
        AVG(total_minutes * 1.0) AS avg_daily_activity
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    a.Id,
    a.avg_daily_activity,
    ue.engagement_group
FROM avg_daily_activity a
LEFT JOIN dbo.UserEngagement ue
    ON a.Id = ue.Id
ORDER BY a.avg_daily_activity;

--Lightly Active Minutes-
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityDate AS DATE) AS log_date,
        SUM(LightlyActiveMinutes) AS total_minutes
    FROM dbo.DailyActivity
    GROUP BY Id, CAST(ActivityDate AS DATE)
),
avg_daily_activity AS (
    SELECT
        Id,
        AVG(total_minutes * 1.0) AS avg_daily_activity
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    a.Id,
    a.avg_daily_activity,
    ue.engagement_group
FROM avg_daily_activity a
LEFT JOIN dbo.UserEngagement ue
    ON a.Id = ue.Id
ORDER BY a.avg_daily_activity;

--Sedentary Minutes--
WITH daily_totals AS (
    SELECT 
        Id,
        CAST(ActivityDate AS DATE) AS log_date,
        SUM(SedentaryMinutes) AS total_minutes
    FROM dbo.DailyActivity
    GROUP BY Id, CAST(ActivityDate AS DATE)
),
avg_daily_activity AS (
    SELECT
        Id,
        AVG(total_minutes * 1.0) AS avg_daily_activity
    FROM daily_totals
    GROUP BY Id
)
SELECT 
    a.Id,
    a.avg_daily_activity,
    ue.engagement_group
FROM avg_daily_activity a
LEFT JOIN dbo.UserEngagement ue
    ON a.Id = ue.Id
ORDER BY a.avg_daily_activity;