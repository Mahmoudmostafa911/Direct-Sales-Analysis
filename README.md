# 📊 Direct Sales Analysis (SQL Server + Power BI)

End-to-end sales reporting pipeline: a SQL Server stored procedure cleans and aggregates sales data from several channels into one analysis-ready table, and a Power BI report sits on top of it for management reporting.

## 🔎 What it does
- Pulls raw sales figures from multiple source channels
- Clears the previous load, cleans and aggregates the KPIs, and inserts the result into a single `Direct Sales Analysis` table
- Power BI connects directly to that table for the management dashboard

## 🛠️ Tools
- **SQL Server / T-SQL** — data transformation and the stored procedure
- **Power BI + DAX** — visualisation and measures
- **Excel** — source data extract

## 📂 Files in this repo
| File | Purpose |
|---|---|
| `SQLCode.sql` | Stored procedure and table definitions (`Sales Dist`, `Direct Sales Analysis`) |
| `comp.xlsx` | Source data extract loaded into SQL Server |
| `Direct Sales Analysis.pbix` | Power BI report — open in Power BI Desktop |

## 🚀 How it works
1. Source channel data is loaded into SQL Server.
2. The stored procedure deletes the old data, cleans and aggregates the KPIs, and inserts them into `Direct Sales Analysis`.
3. Power BI reads that table and refreshes the dashboard.

## 📷 Dashboard preview
Open `Direct Sales Analysis.pbix` in Power BI Desktop to explore the report.
<!-- TODO: export a PNG of the report page and add it here: ![Direct Sales dashboard](docs/dashboard.png) -->

---
Part of my portfolio — more at [github.com/Mahmoudmostafa911](https://github.com/Mahmoudmostafa911).
