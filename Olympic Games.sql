use [Final Project]

select *
from OlympicGames;


/*
======================================
			General Data
======================================
*/

--מספר המתמודדים
select count (distinct name) as 'Num_Of_Athletes'
from OlympicGames


--המדינה שהשתתפה בהכי הרבה אולימפיאדות
SELECT NOC,
       COUNT(distinct games) AS UniqueGamesCount
FROM OlympicGames
GROUP BY NOC
ORDER BY UniqueGamesCount desc


--המתמודד שהשתתפף בהכי הרבה מקצים
SELECT Name,
       COUNT(*) AS NumOfEvents
FROM OlympicGames
GROUP BY Name
ORDER BY NumOfEvents desc


--המתמודד שהשתתפף בהכי הרבה אולימפיאדות
SELECT Name,
       COUNT(distinct Games) AS Num_Of_Olympic_Games
FROM OlympicGames
GROUP BY Name
ORDER BY Num_Of_Olympic_Games desc


-- המתמודד עם הכי הרבה זכיות
SELECT Name,
		COUNT(*) AS TotalMedals,
		SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS GoldMedals,
		SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS SilverMedals,
		SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeMedals
FROM OlympicGames
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Name
ORDER BY TotalMedals desc


-- המדינה עם הכי הרבה זכיות
SELECT NOC,
		COUNT(*) AS TotalMedals,
		SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS GoldMedals,
		SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS SilverMedals,
		SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeMedals
FROM OlympicGames
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY NOC
ORDER BY TotalMedals desc

--מספר תחומי ספורט
select count (distinct Sport) as 'Num_Of_Sports'
from OlympicGames;


/*
שאלה 1: קשר בין גיל הספורטאים להישגים במדליות
•	שאלה: כיצד גיל הספורטאים משפיע על סיכויי הזכייה במדליות? האם יש גיל מסוים שבו הסיכויים לזכות במדליה גבוהים יותר?
•	ניתוח: ניתוח קשר בין גיל הספורטאים לבין מספר המדליות שזכו בהן, לפי סוג המדליה (זהב, כסף, ארד).
•	גרף מומלץ: גרף פיזור (Scatter Plot) המציג את הגיל אל מול סוג המדליה, או גרף עמודות המציג את התפלגות המדליות לפי קבוצות גיל שונות.
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
שאלה 2: השוואת הישגים בין ענפי ספורט שונים
•	שאלה: באילו ענפי ספורט יש יותר סיכוי לזכות במדליה? האם יש ענפי ספורט שבהם יש הבדלים משמעותיים בין הגילאים הממוצעים של הזוכים במדליות?
•	ניתוח: ניתוח מספר המדליות בכל ענף ספורט והשוואת גיל הספורטאים בין ענפי ספורט שונים.
•	גרף מומלץ: גרף עמודות (Bar Chart) המציג את מספר המדליות בכל ענף ספורט, וגרף עוגה (Pie Chart) המציג את חלוקת הגילאים הממוצעים בין ענפי ספורט שונים
*/

-- שלב 1: חישוב מספר המדליות בכל ענף ספורט
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

-- שלב 2: חישוב הגיל הממוצע של הזוכים במדליות בכל ענף ספורט
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
שאלה 3: הבדלים בהישגים בין עונות שונות (קיץ וחורף)
•	שאלה: האם יש הבדלים משמעותיים בהישגים בין האולימפיאדות של הקיץ והחורף? האם יש מדינות שמצטיינות בעונות מסוימות?
•	ניתוח: ניתוח מספר המדליות לפי עונות (קיץ וחורף) והשוואת הישגים בין מדינות שונות בעונות שונות.
•	גרף מומלץ: גרף עמודות (Bar Chart) המציג את מספר המדליות בכל עונה, וגרף קווי (Line Chart) המציג את ההשוואה בין מדינות בעונות שונות.
*/
-- שלב 1: חישוב מספר המדליות בכל עונה (קיץ וחורף)
SELECT 
    Season,
    COUNT(CASE WHEN Medal <> '0' THEN 1 END) AS Total_Medals
FROM 
    OlympicGames
GROUP BY 
    Season
ORDER BY 
    Total_Medals DESC;

-- שלב 2: השוואת הישגים של מדינות שונות בעונות שונות, מסנן מדינות ללא מדליות
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
שאלה 4: הבדלים מגדריים בהישגים לפי ענפי ספורט
שאלה: האם יש הבדלים מגדריים בהישגים במדליות לפי ענפי ספורט? האם יש ענפים בהם ספורטאיות מצליחות יותר מספורטאים, ולהיפך?
ניתוח: ניתוח השוואתי של מספר המדליות לפי מין הספורטאים וענפי הספורט.
גרף מומלץ: גרף עמודות מקובץ (Clustered Bar Chart) המציג את מספר המדליות לפי מין וענף ספורט.
*/
--השוואת הישגים במדליות לפי ענפי ספורט ומגדר 
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


--השוואת כמות ענפי הספורט בהם מגדר מנצח באופן יחסי 
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
שאלה 5: השפעת התחרויות הקודמות על ההישגים הנוכחיים
שאלה: האם ספורטאים שהשתתפו בתחרויות קודמות מצליחים יותר בתחרויות הנוכחיות? האם יש הבדל בין סוגי הספורט?
ניתוח: ניתוח מספר המדליות של ספורטאים שהשתתפו ביותר מאולימפיאדה אחת והשוואת ההצלחה שלהם לענפי ספורט שונים.
*/
-- שלב 1: חישוב מספר האולימפיאדות של כל ספורטאי
WITH Athlete_Olympics AS (
    SELECT 
        ID,
        COUNT(DISTINCT Year) AS Num_Olympics
    FROM 
        OlympicGames
    GROUP BY 
        ID
),

-- שלב 2: צירוף נתוני מספר האולימפיאדות לכל ספורטאי לנתוני האולימפיאדה
Olympic_Data_With_Num_Olympics AS (
    SELECT 
        o.*,
        a.Num_Olympics
    FROM 
        OlympicGames o
    JOIN 
        Athlete_Olympics a ON o.ID = a.ID
)

-- שלב 3: חישוב מספר המדליות של ספורטאים שהשתתפו ביותר מאולימפיאדה אחת והשוואת ההצלחה שלהם לענפי ספורט שונים
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
שאלה 6: השפעת המדינה המארחת על ההישגים
שאלה: האם מדינות שמארחות את האולימפיאדה נוטות לזכות ביותר מדליות? האם יש הבדל משמעותי במספר המדליות בהן זוכות המדינות המארחות בהשוואה לשנים שהן לא מארחות?
ניתוח: ניתוח מספר המדליות של המדינות המארחות לאורך השנים והשוואה למספר המדליות שלהן בשנים שהן לא אירחו את האולימפיאדה.
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















