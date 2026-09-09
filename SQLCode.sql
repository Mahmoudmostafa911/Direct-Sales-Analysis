
/*
  Direct Sales Analysis - load procedure
  ----------------------------------------
  Rebuilds [dbo].[Direct Sales Analysis] from three source channels:
    - Channel A / Channel B  (inbound sales lines, split by language queue)
    - Relocation             (move bookings)
    - Retention              (save calls)
  Table and column names have been anonymised for the public portfolio;
  the transformation logic is unchanged.
*/

USE [Sales]
GO

DECLARE @startDate AS DATE;
SET @startDate = '20240101';

-- Clear the window we are about to reload
DELETE [dbo].[Direct Sales Analysis]
WHERE [Date] >= @startDate;

;WITH CTE AS (

    -- Channel A
    SELECT CAST([Date] AS DATE)          AS [Date]
          ,A.[EmpNum]
          ,[Calls]                        AS [ChannelA Calls]
          ,0                              AS [ChannelB Calls]
          ,A.[Upgrades]                   AS [ChannelA Upgrade Calls]
          ,0                              AS [ChannelB Upgrade Calls]
          ,A.[Spend]                      AS [ChannelA Spend]
          ,0                              AS [ChannelB Spend]
          ,[Upgrade Rate]                 AS [ChannelA Upgrade Rate]
          ,0                              AS [ChannelB Upgrade Rate]
          ,CASE WHEN Spend <> 0 THEN COUNT(Spend) ELSE 0 END AS [ChannelA Number Of Spend]
          ,0                              AS [ChannelB Number Of Spend]
    FROM [dbo].[Channel_A$] AS A
    GROUP BY [Date], A.[EmpNum], [Calls], A.[Upgrades], A.[Spend], [Upgrade Rate]

    UNION ALL

    -- Channel B
    SELECT CAST([Date] AS DATE)          AS [Date]
          ,B.[EmpNum]
          ,0                              AS [ChannelA Calls]
          ,B.[Calls]                      AS [ChannelB Calls]
          ,0                              AS [ChannelA Upgrade Calls]
          ,B.[Upgrades]                   AS [ChannelB Upgrade Calls]
          ,0                              AS [ChannelA Spend]
          ,B.[Spend]                      AS [ChannelB Spend]
          ,0                              AS [ChannelA Upgrade Rate]
          ,[Upgrade Rate]                 AS [ChannelB Upgrade Rate]
          ,0                              AS [ChannelA Number Of Spend]
          ,CASE WHEN Spend <> 0 THEN COUNT(Spend) ELSE 0 END AS [ChannelB Number Of Spend]
    FROM [dbo].[Channel_B$] AS B
    GROUP BY CAST([Date] AS DATE), B.[EmpNum], B.[Upgrades], [Upgrade Rate], B.[Spend], B.[Calls]
)

INSERT INTO [dbo].[Direct Sales Analysis]

-- Inbound sales KPIs (Channel A + Channel B), unpivoted to one row per KPI
SELECT CAST([Date] AS DATE) AS [Date]
      ,[ID]
      ,[Name]
      ,KPI
      ,SUM(C1) AS [Component1]
      ,SUM(C4) AS [Component4]
FROM CTE
JOIN [dbo].[Sales Dist] ON [ID] = [EmpNum]
CROSS APPLY (
    VALUES
        ('ChannelB Calls',          0, [ChannelB Calls]),
        ('ChannelA Calls',          0, [ChannelA Calls]),
        ('Total Calls',             0, [ChannelB Calls] + [ChannelA Calls]),
        ('ChannelB Upgrade Rate',   [ChannelB Upgrade Calls], [ChannelB Calls]),
        ('ChannelA Upgrade Rate',   [ChannelA Upgrade Calls], [ChannelA Calls]),
        ('Total Upgrade Rate',      [ChannelB Upgrade Calls] + [ChannelA Upgrade Calls], [ChannelB Calls] + [ChannelA Calls]),
        ('ChannelB Upgrade Calls',  0, [ChannelB Upgrade Calls]),
        ('ChannelA Upgrade Calls',  0, [ChannelA Upgrade Calls]),
        ('Total Upgrade Calls',     0, [ChannelB Upgrade Calls] + [ChannelA Upgrade Calls]),
        ('ChannelB Protect Calls',  0, [ChannelB Upgrade Rate] * [ChannelB Calls]),
        ('ChannelA Protect Calls',  0, [ChannelA Upgrade Rate] * [ChannelA Calls]),
        ('Total Protect Calls',     0, [ChannelB Calls] + [ChannelA Calls]),
        ('ChannelB Protect Rate',   [ChannelB Upgrade Rate] * [ChannelB Calls], [ChannelB Calls]),
        ('ChannelA Protect Rate',   [ChannelA Upgrade Rate] * [ChannelA Calls], [ChannelA Calls]),
        ('Total Protect Rate',      ([ChannelB Upgrade Rate] * [ChannelB Calls]) + ([ChannelA Upgrade Rate] * [ChannelA Calls]), [ChannelB Calls] + [ChannelA Calls]),
        ('ChannelB Spend',          [ChannelB Spend] * [ChannelB Calls], [ChannelB Calls]),
        ('ChannelA Spend',          [ChannelA Spend] * [ChannelA Calls], [ChannelA Calls]),
        ('Total Spend',             ([ChannelB Spend] + [ChannelA Spend]) * ([ChannelB Calls] + [ChannelA Calls]), [ChannelB Calls] + [ChannelA Calls])
) K (KPI, C1, C4)
WHERE [Date] >= @startDate
  AND (C1 + C4) <> 0
GROUP BY [Date], [ID], [Name], KPI

UNION ALL

-- Relocation KPIs
SELECT CAST([Date] AS DATE) AS [Date]
      ,[ID]
      ,[Name]
      ,KPI
      ,SUM(C1) AS [Component1]
      ,SUM(C4) AS [Component4]
FROM [dbo].[Relocation$]
JOIN [dbo].[Sales Dist] ON [ID] = [EmpNum]
CROSS APPLY (
    VALUES
        ('Move Rate',  [Moves Booked],  [Handled Calls]),
        ('Move Calls', 0,               [Handled Calls])
) K (KPI, C1, C4)
WHERE [Date] >= @startDate
  AND (C1 + C4) <> 0
GROUP BY CAST([Date] AS DATE), [ID], [Name], [KPI]

UNION ALL

-- Retention KPIs
SELECT CAST([Date] AS DATE) AS [Date]
      ,[ID]
      ,[Name]
      ,KPI
      ,SUM(C1) AS [Component1]
      ,SUM(C4) AS [Component4]
FROM [dbo].[Retention$]
JOIN [dbo].[Sales Dist] ON [ID] = [EmpNum]
CROSS APPLY (
    VALUES
        ('Save Rate',       [Saves], [Calls]),
        ('Retention Calls', 0,       [Calls])
) K (KPI, C1, C4)
WHERE [Date] >= @startDate
  AND (C1 + C4) <> 0
GROUP BY CAST([Date] AS DATE), [ID], [Name], KPI;
