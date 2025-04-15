-- Control limit alert
WITH deviations_operators AS (
	SELECT
		operator
		,ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS position
		,height
		,AVG(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) avg_height
		,STDDEV(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) stddev_height
	FROM
		manufacturing_parts
	ORDER BY
		item_no
),

limits AS (
	SELECT
		operator
		,ROW_NUMBER() OVER(ORDER BY position) AS row_number
		,height
		,avg_height
		,stddev_height
		,avg_height+3*(stddev_height/SQRT(5)) AS ucl
		,avg_height-3*(stddev_height/SQRT(5)) AS lcl
	FROM
		deviations_operators
	WHERE
		position >=5
)

SELECT *
	,CASE
		WHEN height BETWEEN lcl AND ucl THEN FALSE
		ELSE TRUE
		END AS alert
FROM limits



-- Rolling mean deviation

WITH height_avgs AS (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS position
		,operator
		,item_no
		,height
		,AVG(height) OVER(PARTITION BY operator ORDER BY item_no) operator_avg_height
		,AVG(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) rolling_avg_height
	FROM
		manufacturing_parts
)

SELECT
	operator
	,item_no
	,height
	,operator_avg_height
	,rolling_avg_height
	,rolling_avg_height - operator_avg_height AS deviation
FROM 
	height_avgs
WHERE 
	position >= 5


  
-- Control limit violation count

WITH grouped_calculations AS (
SELECT
	ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS position
	,operator
	,height
	,AVG(height) OVER(PARTITION BY operator) AS avg_height
	,STDDEV_SAMP(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS stddev_height
FROM
	manufacturing_parts
ORDER BY
	item_no
),

limits AS (
SELECT
	operator
	,height
	,avg_height
	,avg_height+3*(stddev_height/SQRT(5)) AS ucl
	,avg_height-3*(stddev_height/SQRT(5)) AS lcl
FROM
	grouped_calculations
WHERE 
	position >= 5
),

violations AS (
SELECT
	operator
	,height
	,CASE
		WHEN height BETWEEN lcl AND ucl THEN 0
		ELSE 1 END AS violation
FROM
	limits
)

SELECT
	operator
	,SUM(violation) AS total_violations
	,COUNT(*) AS total_products_checked
	,ROUND((SUM(violation)::numeric / COUNT(*) * 100), 2) AS violation_rate
FROM
	violations
GROUP BY
	operator
ORDER BY
	LENGTH(operator)
	,operator



-- First violation detection

WITH deviations_operators AS (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS position
		,item_no
		,height
		,operator
		,AVG(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) avg_height
		,STDDEV_SAMP(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS stddev_height
	FROM
		manufacturing_parts
),

limits AS (
	SELECT
		item_no
		,height
		,operator
		,avg_height+3*(stddev_height/SQRT(5)) AS ucl
		,avg_height-3*(stddev_height/SQRT(5)) AS lcl
	FROM
		deviations_operators	
	WHERE
		position >=5
),

violations AS (
	SELECT
		item_no
		,height
		,ucl
		,lcl
		,operator
		,CASE
			WHEN height BETWEEN lcl AND ucl THEN FALSE
			ELSE TRUE END AS violation
	FROM
		limits
),

violations_numbered AS (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS row_num
		,item_no
		,operator
		,height
		,ucl
		,lcl	FROM
		violations
	WHERE 
		violation = TRUE

)

SELECT 
	operator
	,item_no
	,height
	,ucl
	,lcl
FROM
	violations_numbered
WHERE
	row_num = 1
ORDER BY
	LENGTH(operator)
	,operator



-- Operator stability check
  
WITH deviations_operators AS (
	SELECT
		operator
		,ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS position
		,item_no
		,height
		,AVG(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) avg_height
		,STDDEV(height) OVER(PARTITION BY operator ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) stddev_height
	FROM
		manufacturing_parts
),

limits AS (
	SELECT
		operator
		,ROW_NUMBER() OVER(ORDER BY position) AS row_number
		,item_no
		,height
		,avg_height
		,stddev_height
		,avg_height+3*(stddev_height/SQRT(5)) AS ucl
		,avg_height-3*(stddev_height/SQRT(5)) AS lcl
	FROM
		deviations_operators
	WHERE
		position >=5
),

violations AS (
SELECT
	operator
	,item_no
	,CASE
		WHEN height BETWEEN lcl and ucl THEN 0
		ELSE 1 END AS violation
FROM 
	limits
),

next_violation AS (
	SELECT
		operator
		,item_no
		,violation
		,LEAD(violation, 1) OVER(PARTITION BY operator ORDER BY item_no)AS violation2
	FROM 
		violations
),

consecutive_violations AS (
	SELECT
		operator
		,CASE 
			WHEN violation + violation2 = 2 THEN 1
			ELSE 0 END AS consecutive_violation
	FROM 
		next_violation
)

SELECT operator
	,MAX(consecutive_violation)::boolean AS is_unestable
FROM consecutive_violations
GROUP BY operator
		
		
