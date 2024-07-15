WITH stringency_data(Date,Continent_Name,Country_Name,StringencyIndex)AS(
	SELECT 
	indices.Date,
	continent.Continent_Name,
	indices.Country_Name,
	indices.StringencyIndex_Average_ForDisplay as StringencyIndex,
	RANK() OVER (PARTITION BY Continent_Name,Date ORDER BY StringencyIndex_Average_ForDisplay DESC) AS Rank_Max,
    RANK() OVER (PARTITION BY Continent_Name,Date ORDER BY StringencyIndex_Average_ForDisplay ASC) AS Rank_Min
	FROM indices 
		RIGHT JOIN country ON country.Three_Letter_Country_Code=indices.CountryCode
		RIGHT JOIN is_in ON is_in.Three_Letter_Country_Code=country.Three_Letter_Country_Code
		RIGHT JOIN continent ON continent.Continent_Code=is_in.Continent_Code
	WHERE indices.StringencyIndex_Average_ForDisplay IS NOT NULL
	AND (indices.Date='20221201' OR indices.Date='20220401' OR indices.Date='20210401' OR indices.Date='20200401')
)
SELECT Date,Continent_Name,Country_Name,StringencyIndex
FROM stringency_data
WHERE Rank_Max = 1 OR Rank_Min = 1
ORDER BY Date,Continent_Name,StringencyIndex;

-- /*highest and lowest separately*/
-- WITH RankedCountries AS (
--     SELECT 
--         indices.Date,
--         country.Country_Name,
--         continent.Continent_Name,
--         indices.StringencyIndex_Average_ForDisplay,
--         RANK() OVER (PARTITION BY continent.Continent_Name, indices.Date ORDER BY indices.StringencyIndex_Average_ForDisplay DESC) AS Rank_Max,
--         RANK() OVER (PARTITION BY continent.Continent_Name, indices.Date ORDER BY indices.StringencyIndex_Average_ForDisplay ASC) AS Rank_Min
--     FROM indices 
--         RIGHT JOIN country ON country.Three_Letter_Country_Code = indices.CountryCode
--         RIGHT JOIN is_in ON is_in.Three_Letter_Country_Code = country.Three_Letter_Country_Code
--         RIGHT JOIN continent ON continent.Continent_Code = is_in.Continent_Code
--     WHERE indices.Date IN ('20221201', '20220401', '20210401', '20200401')
--         AND indices.StringencyIndex_Average_ForDisplay IS NOT NULL
-- )
-- SELECT 
--     Date,
-- 	Continent_Name,
--     Country_Name,
--     MAX(StringencyIndex_Average_ForDisplay) FILTER (WHERE Rank_Max = 1) AS Highest_StringencyIndex,
--     MIN(StringencyIndex_Average_ForDisplay) FILTER (WHERE Rank_Min = 1) AS Lowest_StringencyIndex
-- FROM RankedCountries
-- WHERE Rank_Max = 1 OR Rank_Min = 1
-- GROUP BY Date, Country_Name, Continent_Name
-- ORDER BY Date, Continent_Name;