#Machine Failure & Efficiency Analysis Dashboard
📌 Project Overview

This project focuses on analyzing manufacturing machine sensor data to understand failure patterns, operational efficiency, and maintenance risks. It follows an end-to-end analytics workflow, where:

BigQuery SQL is used for KPI computation and data modeling

Looker Studio is used for interactive dashboards and visual storytelling

The goal is to support preventive maintenance decisions and reduce unplanned machine downtime.

🏗️ Architecture & Data Flow
Raw Sensor Data (CSV / Excel)
        ↓
Google BigQuery
  - Data cleaning
  - KPI calculations
  - Aggregated views
        ↓
Looker Studio
  - Interactive dashboards
  - Filters & drill-downs
        ↓
Business Insights & Decisions
🛠️ Tools & Technologies

Google BigQuery – Data storage, SQL transformations, KPI views

Looker Studio – Dashboarding & visualization

SQL – KPI logic and dashboard-level queries

GitHub – Version control & project documentation

📂 Repository Structure
/sql
 ├── bigquery_kpi/
 │    ├── machine_sensor_clean.sql
 │    ├── machine_efficiency_project.sql
 │
 ├── dashboard_sql/
 │    ├── window_query.sql
 │    └── visualization_queries.sql


/dashboard
 ├── machine_efficiency_dashboard.png


README.md
🧮 Data Modeling Approach
1️⃣ BigQuery (Data Layer)

Used to clean raw sensor data

Created KPI-level SQL queries for:

Failure rate

Average tool wear

Torque and rotational speed metrics

Machine efficiency indicators

These queries act as a single source of truth for reporting.

2️⃣ Dashboard SQL (Visualization Layer)

Used only for:

Chart-specific transformations

Bucketing & grouping for visuals

Filters and breakdowns

Heavy aggregations are intentionally avoided at this layer for better performance and consistency.

📊 Key KPIs & Metrics

Total Machines Analyzed

Failure Rate (%)

Average Tool Wear

Average Torque

Machine Efficiency Score

Failure Distribution by Machine Type

📈 Looker Studio Dashboard

🔗 Live Dashboard (View Access): (Add your Looker Studio link here)

Dashboard Pages:

Overview – High-level KPIs and machine performance summary

Failure Analysis – Failure type and machine category breakdown

Operational Metrics – Tool wear, torque, and speed relationships

📷 Dashboard preview images are available in the /dashboard folder.

🔍 Key Insights

Certain machine types show higher failure concentration under increased tool wear

Torque and tool wear demonstrate strong correlation in failure cases

Machines operating beyond optimal efficiency thresholds should be prioritized for maintenance

💡 Business Recommendations

Implement preventive maintenance for high tool-wear machines

Monitor torque thresholds to reduce overstrain failures

Use KPI views to automate alerts for high-risk machines

🚀 Future Enhancements

Machine learning–based failure prediction

Real-time data ingestion and monitoring

Maintenance cost impact analysis

Automated alerting using BigQuery + Looker

🎯 Skills Demonstrated

SQL-based data modeling (BigQuery)

KPI engineering & analytics design

Dashboard development (Looker Studio)

End-to-end analytics workflow

Business-focused data storytelling

📬 Contact

Yokesh Dharan
Data Analyst | Analytics Engineer (Aspirant)

Feel free to connect or raise issues for feedback and improvements.

I’ve created a complete, professional README.md for your project in the canvas 👈
This README is portfolio-ready and matches exactly what you’ve done:

✅ BigQuery for KPI queries
✅ Separate dashboard SQL for visualization
✅ Looker Studio dashboard integration
✅ Analytics-engineer–style architecture
