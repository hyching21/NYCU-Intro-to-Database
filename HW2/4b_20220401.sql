WITH cases_220401(Date,Continent_Name,Country_Code,ConfirmedCases) AS(
	SELECT 
	cases.Date,
	continent.Continent_Name,
	country.Three_Letter_Country_Code,
	cases.ConfirmedCases
	FROM cases
		RIGHT JOIN country ON country.Three_Letter_Country_Code=cases.CountryCode
		RIGHT JOIN is_in ON is_in.Three_Letter_Country_Code=country.Three_Letter_Country_Code
		RIGHT JOIN continent ON continent.Continent_Code=is_in.Continent_Code
	WHERE Date='20220325' OR Date='20220401'
),
average_7day_220401(Continent_Name,Country_Code,Case_average) AS(
	SELECT t1.Continent_Name,t1.Country_Code,
	CASE 
	WHEN ((CAST(t2.ConfirmedCases AS FLOAT(2))-CAST(t1.ConfirmedCases AS FLOAT(2)))/7)=0 THEN 0.10
	ELSE ((CAST(t2.ConfirmedCases AS FLOAT(2))-CAST(t1.ConfirmedCases AS FLOAT(2)))/7)
	END
	FROM cases_220401 AS t1, cases_220401 AS t2
	WHERE t1.Country_Code=t2.Country_Code
	AND t2.Date='20220401' AND t1.Date='20220325'
),
overindex_220401(Date,Continent_Name,Country_Name,Over_Stringency_Index) AS(
	SELECT '20220401' AS Date, a1.Continent_Name, indices.Country_Name,
	(indices.StringencyIndex_Average_ForDisplay/a1.Case_average) AS Over_Stringency_Index,
	RANK() OVER (PARTITION BY Continent_Name ORDER BY 
				 (indices.StringencyIndex_Average_ForDisplay/a1.Case_average) DESC) AS Rank_Max,
    RANK() OVER (PARTITION BY Continent_Name ORDER BY 
				 (indices.StringencyIndex_Average_ForDisplay/a1.Case_average) ASC) AS Rank_Min
	FROM average_7day_220401 AS a1, indices
	WHERE a1.Country_Code=indices.CountryCode 
	AND indices.StringencyIndex_Average_ForDisplay IS NOT NULL
	AND indices.Date='20220401'
)
SELECT 
Date,Continent_Name,Country_Name,Over_Stringency_Index
FROM overindex_220401
WHERE Rank_Max = 1 OR Rank_Min = 1
ORDER BY Continent_Name;