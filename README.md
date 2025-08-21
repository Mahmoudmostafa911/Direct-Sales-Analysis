📊 Direct Sales Analysis (SQL + Power BI)

## 🔎 Overview
This project analyzes **Direct Sales performance** using SQL Server and Power BI.  
The stored procedure aggregates multiple data sources (International, English, Movers, Connects) into a single analysis table for reporting.

## 🛠️ Tools
- **SQL Server** (Data Transformation & Stored Procedures)
- **Power BI** (Visualization)
- **GitHub** (Documentation & Code Hosting)

## 📂 Project Structure
- `DishSalesAnalysis.sql` → Stored procedure for data aggregation
- `Tables/` → Table definitions + Sample data
- `Dashboard/` → Screenshots of Power BI dashboard
- `README.md` → Documentation

## 📑 Tables
```sql
CREATE TABLE [dbo].[Sales Dist] (
    Name NVARCHAR(100),
    EmpNum INT
);

CREATE TABLE [dbo].[Direct Sales Analysis] (
    Date DATE,
    ID INT,
    Name NVARCHAR(100),
    KPI NVARCHAR(50),
    Component1 DECIMAL(18,2),
    Component4 DECIMAL(18,2)
);
```

## 🚀 How it Works
1. Data comes from multiple sources (International Calls, English Calls, Movers, Connects).
2. The stored procedure `DishSalesanalysis`:
   - Deletes old data.
   - Cleans & aggregates KPIs.
   - Inserts into `Direct Sales Analysis`.
3. Power BI connects directly to this table for management dashboards.

## 📷 Dashboard Preview

<img width="1140" height="806" alt="{E91C3907-C3BC-4574-A380-09C1EABEDE03}" src="https://github.com/user-attachments/assets/3f35878a-6b4b-440e-94c1-f0d037f33bdf" />
<img width="1137" height="803" alt="2" src="https://github.com/user-attachments/assets/44aea07c-efa4-4f17-9b64-14e151907ac4" />
<img width="1139" height="804" alt="3" src="https://github.com/user-attachments/assets/bc0f4bfa-4c72-4a35-a08e-d28a5d377744" />
<img width="1415" height="786" alt="4" src="https://github.com/user-attachments/assets/e5a07d25-733f-45a8-a6e2-7bbe0f605191" />


