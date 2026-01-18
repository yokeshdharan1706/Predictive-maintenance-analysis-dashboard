#Rank products by tool wear within each product type.
SELECT
  product_id,
  machine_type,
  tool_wear,
  RANK() OVER (
    PARTITION BY machine_type
    ORDER BY tool_wear DESC
  ) AS tool_wear_rank
FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
ORDER BY machine_type, tool_wear_rank;

#Calculate moving averages of torque and RPM.
select udi, torque, rotational_speed as RPM ,ROUND(AVG(torque) OVER (ORDER BY UDI ROWS BETWEEN 9 PRECEDING AND CURRENT ROW),2) AS torque_moving_avg, round(avg(rotational_speed) over(order by UDI Rows Between 9 preceding and current row),2) as RPM_Moving_Avg
from `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`


#Identify outliers in torque using percentile functions.
WITH torque_stats AS (
  SELECT
    UDI,
    torque,
    q1,
    q3,
    (q3 - q1) AS iqr
  FROM (
    SELECT
      UDI,
      torque,
      PERCENTILE_CONT(torque, 0.25) OVER () AS q1,
      PERCENTILE_CONT(torque, 0.75) OVER () AS q3
    FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
  )
)

select UDI, torque, round((q1-1.5*iqr),2) as lower_bound, round((q3+1.5*iqr),2) as upper_bound, 
case when torque> q3+1.5*iqr or torque< q1-1.5*iqr then "Outlier" else "Normal" end as status
from torque_stats
order by torque

