#Find the average torque and rotational speed for failed vs non-failed records.
select failure_type, Round(avg(torque),2)as Avg_torque,Round(avg(rotational_speed),2)as Avg_speed
from `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
group by failure_type
order by failure_type

#Identify which failure type occurs most frequently.
select failure_type,count(case when target=1 then 1 end) as failure_count,count(case when target =0 then 1 end) as non_failure_count
from `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
where failure_type is not NULL
group by failure_type
order by failure_type

SELECT failure_type,ROUND(AVG(torque), 2) AS Avg_torque_failure_speed
FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
WHERE target = 1 AND failure_type != "No Failure"
GROUP BY failure_type
ORDER BY Avg_torque_failure_speed;

#Compare failure rates at low vs high rotational speeds.
with overall as (SELECT AVG(CASE WHEN target = 1 THEN 1 ELSE 0 END) AS overall_failure_rate
FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`)

SELECT
  machine_type AS product_type,
  COUNT(*) AS total_records,
  sum(CASE WHEN target = 1 THEN 1 ELSE 0 END) AS failures,
  ROUND(
    AVG(CASE WHEN target = 1 THEN 1 ELSE 0 END) * 100,
    2
  ) AS failure_rate_pct
FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
GROUP BY machine_type
HAVING AVG(CASE WHEN target = 1 THEN 1 ELSE 0 END) >
       (SELECT overall_failure_rate FROM overall)
ORDER BY failure_rate_pct DESC;

#Find product types with failure rates above the overall average.
with failure_per as (SELECT machine_type AS product_type,ROUND(AVG(CASE WHEN target = 1 THEN 1 ELSE 0 END) * 100) AS failure_rate
FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
GROUP BY machine_type)

select product_type, failure_rate, rank() over(order by failure_rate desc) as failure_rank
from failure_per


#Calculate a mechanical stress index (Torque × RPM) and analyze its relation to failures.
WITH stress_buckets AS (
  SELECT
    NTILE(10) OVER (ORDER BY torque * `rotational_speed`) AS stress_decile,target
  FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
)

SELECT
  stress_decile,
  COUNT(*) AS total_records,
  SUM(target) AS failures,
  ROUND(SUM(target) / COUNT(*), 3) AS failure_probability
FROM stress_buckets
GROUP BY stress_decile
ORDER BY stress_decile;


#Identify operating condition thresholds where failure probability sharply increases.
WITH thresholds AS (
  SELECT
    APPROX_QUANTILES(tool_wear, 10)[OFFSET(9)] AS toolwear_90,
    AVG(torque) AS avg_torque
  FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
),

risk_records AS (
  SELECT
    product_id,
    machine_type,
    torque,
    tool_wear,
    rotational_speed,
    ROUND(process_temperature - air_temperature, 2) AS temp_diff,
    target,
    failure_type
  FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_clean`
)

#Simulate a maintenance alert: list products that crossed defined risk thresholds.
SELECT
  r.product_id,
  r.machine_type,
  r.torque,
  r.tool_wear,
  r.rotational_speed,
  r.temp_diff,
  r.target,
  r.failure_type,
  CASE
    WHEN r.tool_wear > t.toolwear_90
     AND r.torque > t.avg_torque
     and r.temp_diff>10
    THEN 'Intermediate RISK – MAINTENANCE REQUIRED'
    WHEN r.tool_wear > t.toolwear_90
     AND r.torque > t.avg_torque
     and r.temp_diff>10
    THEN 'High RISK – MAINTENANCE REQUIRED'
    ELSE 'NORMAL'
  END AS maintenance_status
FROM risk_records r
CROSS JOIN thresholds t
WHERE r.tool_wear > t.toolwear_90
   OR r.torque > t.avg_torque
ORDER BY maintenance_status DESC, r.tool_wear DESC;
