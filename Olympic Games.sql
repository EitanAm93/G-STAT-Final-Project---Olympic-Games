use [Final Project]

select *
from OlympicGames;


/*
======================================
			General Data
======================================
*/

--���� ���������
select count (distinct name) as 'Num_Of_Athletes'
from OlympicGames


--������ ������� ���� ���� �����������
SELECT NOC,
       COUNT(distinct games) AS UniqueGamesCount
FROM OlympicGames
GROUP BY NOC
ORDER BY UniqueGamesCount desc


--������� ������� ���� ���� �����
SELECT Name,
       COUNT(*) AS NumOfEvents
FROM OlympicGames
GROUP BY Name
ORDER BY NumOfEvents desc


--������� ������� ���� ���� �����������
SELECT Name,
       COUNT(distinct Games) AS Num_Of_Olympic_Games
FROM OlympicGames
GROUP BY Name
ORDER BY Num_Of_Olympic_Games desc


-- ������� �� ��� ���� �����
SELECT Name,
		COUNT(*) AS TotalMedals,
		SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS GoldMedals,
		SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS SilverMedals,
		SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeMedals
FROM OlympicGames
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Name
ORDER BY TotalMedals desc


-- ������ �� ��� ���� �����
SELECT NOC,
		COUNT(*) AS TotalMedals,
		SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS GoldMedals,
		SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS SilverMedals,
		SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeMedals
FROM OlympicGames
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY NOC
ORDER BY TotalMedals desc

--���� ����� �����
select count (distinct Sport) as 'Num_Of_Sports'
from OlympicGames;


/*
���� 1: ��� ��� ��� ��������� ������� �������
�	����: ���� ��� ��������� ����� �� ������ ������ �������? ��� �� ��� ����� ��� �������� ����� ������ ������ ����?
�	�����: ����� ��� ��� ��� ��������� ���� ���� ������� ���� ���, ��� ��� ������ (���, ���, ���).
�	��� �����: ��� ����� (Scatter Plot) ����� �� ���� �� ��� ��� ������, �� ��� ������ ����� �� ������� ������� ��� ������ ��� �����.
*/
WITH AgeGroups AS (
    SELECT *,
           CASE
               WHEN Age <= 35 THEN 'Young'
               WHEN Age <= 55 THEN 'Middle Age'
               ELSE 'Old'
           END AS Age_Group,
           CASE
               WHEN Medal = 'Gold' THEN 1
               WHEN Medal = 'Silver' THEN 2
               WHEN Medal = 'Bronze' THEN 3
               ELSE 4
           END AS Medal_Rank
    FROM OlympicGames
),
AgeGroupCounts AS (
    SELECT Age_Group,
           COUNT(*) AS TotalParticipations
    FROM AgeGroups
    GROUP BY Age_Group
)
SELECT AG.Age_Group,
       COUNT(*) AS Num_of_Medals,
       SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS GoldMedals,
       SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS SilverMedals,
       SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeMedals,
       (CAST(COUNT(*) AS FLOAT) / AGC.TotalParticipations) * 100 AS WinPercentage
FROM AgeGroups AG
JOIN AgeGroupCounts AGC ON AG.Age_Group = AGC.Age_Group
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY AG.Age_Group, AGC.TotalParticipations
ORDER BY Num_of_Medals DESC;



/*
���� 2: ������ ������ ��� ���� ����� �����
�	����: ����� ���� ����� �� ���� ����� ����� ������? ��� �� ���� ����� ���� �� ������ ��������� ��� ������� �������� �� ������ �������?
�	�����: ����� ���� ������� ��� ��� ����� ������� ��� ��������� ��� ���� ����� �����.
�	��� �����: ��� ������ (Bar Chart) ����� �� ���� ������� ��� ��� �����, ���� ���� (Pie Chart) ����� �� ����� ������� �������� ��� ���� ����� �����
*/

-- ��� 1: ����� ���� ������� ��� ��� �����
SELECT 
    Sport,
    COUNT(DISTINCT Event) AS Total_Events,
    COUNT(CASE WHEN Medal <> '0' THEN 1 END) AS Total_Medals
FROM 
    OlympicGames
GROUP BY 
    Sport
ORDER BY 
    Total_Medals DESC;

-- ��� 2: ����� ���� ������ �� ������ ������� ��� ��� �����
SELECT 
Sport,
COUNT(DISTINCT Event) AS TotalEvents,
AVG(Age) AS Average_Age,
COUNT(CASE WHEN Medal <> '0' THEN 1 END) AS Total_Medals,
COUNT(DISTINCT ID) AS Total_Participants
FROM 
    OlympicGames
GROUP BY 
    Sport
ORDER BY 
    Total_Medals DESC;




/*
���� 3: ������ ������� ��� ����� ����� (��� �����)
�	����: ��� �� ������ ��������� ������� ��� ������������ �� ���� ������? ��� �� ������ ��������� ������ �������?
�	�����: ����� ���� ������� ��� ����� (��� �����) ������� ������ ��� ������ ����� ������ �����.
�	��� �����: ��� ������ (Bar Chart) ����� �� ���� ������� ��� ����, ���� ���� (Line Chart) ����� �� ������� ��� ������ ������ �����.
*/
-- ��� 1: ����� ���� ������� ��� ���� (��� �����)
SELECT 
    Season,
    COUNT(CASE WHEN Medal <> '0' THEN 1 END) AS Total_Medals
FROM 
    OlympicGames
GROUP BY 
    Season
ORDER BY 
    Total_Medals DESC;

-- ��� 2: ������ ������ �� ������ ����� ������ �����, ���� ������ ��� ������
SELECT 
    Country,
    ISNULL([Summer], 0) AS Summer_Medals,
    ISNULL([Winter], 0) AS Winter_Medals,
    ISNULL([Summer], 0) + ISNULL([Winter], 0) AS Total_Medals
FROM 
    (SELECT 
         NOC AS Country,
         Season,
         COUNT(CASE WHEN Medal <> '0' THEN 1 END) AS Total_Medals
     FROM 
         OlympicGames
     GROUP BY 
         NOC, Season) AS SourceTable
PIVOT 
    (SUM(Total_Medals) 
     FOR Season IN ([Summer], [Winter])
    ) AS PivotTable
WHERE 
    ISNULL([Summer], 0) + ISNULL([Winter], 0) > 0
ORDER BY 
    Total_Medals DESC;




/*
���� 4: ������ ������� ������� ��� ���� �����
����: ��� �� ������ ������� ������� ������� ��� ���� �����? ��� �� ����� ��� ��������� ������� ���� ���������, ������?
�����: ����� ������� �� ���� ������� ��� ��� ��������� ����� ������.
��� �����: ��� ������ ����� (Clustered Bar Chart) ����� �� ���� ������� ��� ��� ���� �����.
*/
--������ ������ ������� ��� ���� ����� ����� 
select Sport
		,count(case when Medal <> '0' and Sex = 'M' then 1 end) as 'Male_Medals'
		,count(case when Medal <> '0' and Sex = 'F' then 1 end) as 'Female_Medals'
		,count(case when Medal <> '0' then 1 end) as 'Total_Medals'
		,isnull(count(case when Medal <> '0' and Sex = 'M' then 1 end)*1.0 / (select count(*)
																   from OlympicGames as in_q
																   where out_q.Sport = in_q.Sport and
																		 in_q.Sex = 'M'
																   having count(*) > 0	 
																   ),0)*100 as 'Male_Win_Pct'
		,isnull(count(case when Medal <> '0' and Sex = 'F' then 1 end)*1.0 / (select count(*)
																   from OlympicGames as in_q
																   where out_q.Sport = in_q.Sport and
																		 in_q.Sex = 'F'
																   having count(*) > 0	 
																   ),0)*100 as 'Female_Win_Pct'
from OlympicGames as out_q
group by Sport
order by Total_Medals desc


--������ ���� ���� ������ ��� ���� ���� ����� ���� 
with GenderMedals as
(
select Sport
		,count(case when Medal <> '0' and Sex = 'M' then 1 end) as 'Male_Medals'
		,count(case when Medal <> '0' and Sex = 'F' then 1 end) as 'Female_Medals'
		,count(case when Medal <> '0' then 1 end) as 'Total_Medals'
		,isnull(count(case when Medal <> '0' and Sex = 'M' then 1 end)*1.0 / (select count(*)
																   from OlympicGames as in_q
																   where out_q.Sport = in_q.Sport and
																		 in_q.Sex = 'M'
																   having count(*) > 0	 
																   ),0)*100 as 'Male_Win_Pct'
		,isnull(count(case when Medal <> '0' and Sex = 'F' then 1 end)*1.0 / (select count(*)
																   from OlympicGames as in_q
																   where out_q.Sport = in_q.Sport and
																		 in_q.Sex = 'F'
																   having count(*) > 0	 
																   ),0)*100 as 'Female_Win_Pct'
from OlympicGames as out_q
group by Sport
)
select sum(case when Male_Win_Pct > Female_Win_Pct then 1 end) as 'Male_Win'
		,sum(case when Male_Win_Pct < Female_Win_Pct then 1 end) as 'Female_Win'
from GenderMedals;





/*
���� 5: ����� �������� ������� �� ������� ��������
����: ��� �������� ������� �������� ������ ������� ���� �������� ��������? ��� �� ���� ��� ���� ������?
�����: ����� ���� ������� �� �������� ������� ����� ����������� ��� ������� ������ ���� ����� ����� �����.
*/
-- ��� 1: ����� ���� ������������ �� �� �������
WITH Athlete_Olympics AS (
    SELECT 
        ID,
        COUNT(DISTINCT Year) AS Num_Olympics
    FROM 
        OlympicGames
    GROUP BY 
        ID
),

-- ��� 2: ����� ����� ���� ������������ ��� ������� ������ �����������
Olympic_Data_With_Num_Olympics AS (
    SELECT 
        o.*,
        a.Num_Olympics
    FROM 
        OlympicGames o
    JOIN 
        Athlete_Olympics a ON o.ID = a.ID
)

-- ��� 3: ����� ���� ������� �� �������� ������� ����� ����������� ��� ������� ������ ���� ����� ����� �����
SELECT 
    Sport,
    COUNT(CASE WHEN Num_Olympics > 1 AND Medal <> '0' THEN 1 END) AS Medals_By_Experienced_Athletes,
    COUNT(CASE WHEN Num_Olympics = 1 AND Medal <> '0' THEN 1 END) AS Medals_By_First_Time_Athletes,
    COUNT(CASE WHEN Medal <> '0' THEN 1 END) AS Total_Medals
FROM 
    Olympic_Data_With_Num_Olympics
GROUP BY 
    Sport
ORDER BY 
    Total_Medals DESC;




/*
���� 6: ����� ������ ������ �� �������
����: ��� ������ ������� �� ����������� ����� ����� ����� ������? ��� �� ���� ������� ����� ������� ��� ����� ������� ������� ������� ����� ��� �� ������?
�����: ����� ���� ������� �� ������� ������� ����� ����� ������� ����� ������� ���� ����� ��� �� ����� �� �����������.
*/
WITH Hosting_Medals AS (
    SELECT 
        Games,
        Country,
        sum(case when Medal <> '0' and Country = NOC then 1 else 0 end) AS Hosting_Medals
    FROM 
        OlympicGames 
    GROUP BY 
        Games, 
        Country
),
Total_Medals AS (
    SELECT
		Games,
        COUNT(Medal) AS Total_Medals
    FROM 
        OlympicGames
    WHERE 
        Medal <> '0'
    GROUP BY
		Games
)
SELECT 
    h.Games,
    h.Country,
    h.Hosting_Medals,
    t.Total_Medals,
	h.Hosting_Medals * 1.0 / t.Total_Medals *100 as 'Hosting_Win_Pct'
FROM 
    Hosting_Medals h
	JOIN 
    Total_Medals t
ON 
    h.Games = t.Games
ORDER BY Games;















