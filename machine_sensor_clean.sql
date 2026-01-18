CREATE OR REPLACE VIEW `machine-efficiency-dataset.Machinesdata.machine_sensor_clean` AS
SELECT
  UDI AS udi,
  `Product ID` AS product_id,
  Type AS machine_type,
  `Air temperature ` AS air_temperature,
  `Process temperature ` AS process_temperature,
  `Rotational speed ` AS rotational_speed,
  `Torque ` AS torque,
  `Tool wear ` AS tool_wear,
  Target AS target,
  `Failure Type` AS failure_type
FROM `machine-efficiency-dataset.Machinesdata.machine_sensor_data`;
