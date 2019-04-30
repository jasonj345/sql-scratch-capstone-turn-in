
WITH months AS (
SELECT
'2017-01-01' AS first_day,
'2017-01-30' AS last_day
  UNION
SELECT
  '2017-02-01' AS first_day,
  '2017-2-28' AS last_day
  UNION
SELECT
  '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
),

cross_join AS (
	SELECT *
   FROM
   subscriptions
   CROSS JOIN months),
  
status AS (
SELECT 
id, 
first_day AS month, 

			CASE
   		WHEN (subscription_start < first_day)
   		AND (subscription_end > first_day OR subscription_end IS NULL)
   		AND (segment = 87)
   		THEN 1
   		ELSE 0
   	END AS is_active_87,
   
  	 	CASE
   		WHEN (subscription_start < first_day)
   		AND (subscription_end > first_day OR subscription_end IS NULL)
   		AND (segment = 30)
   		THEN 1
   		ELSE 0
   	END AS is_active_30,
  
			CASE
   		WHEN (subscription_end BETWEEN first_day AND 					last_day)
   		AND (segment = 87)
   		THEN 1
   		ELSE 0
   	END AS is_canceled_87,
  
		  CASE
   		WHEN (subscription_end BETWEEN first_day AND 						last_day)
   		AND (segment = 30)
   		THEN 1
   		ELSE 0
   	END AS is_canceled_30
  FROM cross_join
	),
status_aggregate AS (
SELECT
  month,
	sum(is_active_87) AS active_87,
  sum(is_active_30) AS active_30,
  sum(is_canceled_87) AS canceled_87,
  sum(is_canceled_30) AS canceled_30
  FROM status
  GROUP BY month
  )



-- identifying when company has been operating
/* SELECT
	MIN(subscription_start) AS first_start, 
	MAX (subscription_start)AS last_start,
	MIN(subscription_end) AS first_end,
	MAX(subscription_end) AS last_end
FROM subscriptions; */

-- identifying user segments
 /*SELECT
	DISTINCT segment
  FROM subscriptions 
  ; */
  
-- churn rate for both segments, month over month  
/* SELECT 
	1.0 * (canceled_87 + canceled_30) / (active_87 + active_30) AS churn_rate,
  month
FROM status_aggregate
GROUP BY month;
*/

-- churn rate by month, divided by segment
/*SELECT
	month,
	(1.0 * canceled_87 / active_87 ) AS eightyseven_churn,
  
  (1.0 * canceled_30 / active_30) AS thirty_churn
  
FROM status_aggregate
GROUP BY month; */

  
  