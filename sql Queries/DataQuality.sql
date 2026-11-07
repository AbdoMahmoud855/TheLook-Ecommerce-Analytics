USE TheLook_Ecommerce;
GO
------Data Quality Check Table Users-------------
select top 50 [id], [first_name], [last_name], [email], [age], [gender], [state], [street_address], [postal_code], [city], [country], [latitude], [longitude], [traffic_source], [created_at], [user_geom]
from[stg].[users]
---duplicate check id-----------
SELECT
    id,
    COUNT(*) AS DuplicateCount
FROM stg.users
GROUP BY id
HAVING COUNT(*) > 1;


SELECt
    email,
    COUNT(*) AS DuplicateCount
FROM stg.users
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
order by  DuplicateCount DESC;

select  [id], [first_name], [last_name], [email], [age], [gender], [state], [street_address], [postal_code], [city], [country], [latitude], [longitude], [traffic_source], [created_at], [user_geom]
from[stg].[users]
where [email] IN (SELECT
    email
FROM stg.users
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1)
order by  email

SELECT
    MIN(TRY_CONVERT(DATETIMEOFFSET, created_at)) AS FirstCreatedAt,
    MAX(TRY_CONVERT(DATETIMEOFFSET, created_at)) AS LastCreatedAt,
    COUNT(DISTINCT id) AS DifferentUserIDs,
    COUNT(DISTINCT age) AS DifferentAges
FROM stg.users as u 
WHERE EXISTS (
    SELECT 1
    FROM stg.users u2
    WHERE u2.email = u.email
    GROUP BY u2.email
    HAVING COUNT(*) > 1
)
  GROUP BY u.email

-----null check---------------
SELECT
    COUNT(*) - COUNT(id) AS id_Null,
    COUNT(*) - COUNT(first_name) AS first_name_Null,
    COUNT(*) - COUNT(last_name) AS last_name_Null,
    COUNT(*) - COUNT(email) AS email_Null,
    COUNT(*) - COUNT(age) AS age_Null,
    COUNT(*) - COUNT(gender) AS gender_Null,
    COUNT(*) - COUNT(state) AS state_Null,
    COUNT(*) - COUNT(street_address) AS street_address_Null,
    COUNT(*) - COUNT(postal_code) AS postal_code_Null,
    COUNT(*) - COUNT(city) AS city_Null,
    COUNT(*) - COUNT(country) AS country_Null,
    COUNT(*) - COUNT(latitude) AS latitude_Null,
    COUNT(*) - COUNT(longitude) AS longitude_Null,
    COUNT(*) - COUNT(traffic_source) AS traffic_source_Null,
    COUNT(*) - COUNT(created_at) AS created_at_Null,
    COUNT(*) - COUNT(user_geom) AS user_geom_Null
FROM stg.users;
-------------if all data is true or not----------------
--check outlier id------
SELECT COUNT(*) AS WrongData
FROM stg.users
WHERE id <0;
------check if find empty string or space or right data

SELECT
    

    COUNT(CASE
        WHEN TRIM(first_name) = '' THEN 1
    END) AS EmptyOrSpaces,

    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, first_name) IS not NULL
             
        THEN 1
    END) AS NumericFirstNames,

    
    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, last_name) IS NOT NULL
        THEN 1
    END) AS NumericLastNames,

    COUNT(CASE
        WHEN TRIM(last_name) = ''
        THEN 1
    END) AS EmptyOrSpacesLastNames,

   
    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, last_name) IS NOT NULL
		AND TRIM(email) <> ''
             AND email NOT LIKE '%_@_%._%'
        THEN 1
    END) AS InvalidEmailFormat,

    COUNT(CASE
        WHEN TRIM(email) = ''
        THEN 1
    END) AS EmptyOrSpacesEmails,

 
    COUNT(CASE
        WHEN age < 0 THEN 1
    END) AS NegativeAges,

    COUNT(CASE
        WHEN age > 120 THEN 1
    END) AS AgesAbove120,

	    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, [state]) IS NOT NULL
        THEN 1
    END) AS NumericState,

    COUNT(CASE
        WHEN TRIM([state]) = ''
        THEN 1
    END) AS EmptyOrSpacesState,

	Count(CASE
	WHEN [postal_code]  like '%[^0-9]%' then 1
	 END ) as containString,

	     COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, TRIM(city)) IS NOT NULL
        THEN 1
    END) AS NumericCities,

    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, TRIM(country)) IS NOT NULL
        THEN 1
    END) AS NumericCountries ,
	   COUNT(CASE
        WHEN latitude NOT BETWEEN -90 AND 90
        THEN 1
    END) AS InvalidLatitudes,

    COUNT(CASE
        WHEN longitude NOT BETWEEN -180 AND 180
        THEN 1
    END) AS InvalidLongitudes,

    COUNT(CASE
        WHEN latitude = 0 AND longitude = 0
        THEN 1
    END) AS ZeroCoordinates,
	   COUNT(CASE
        WHEN TRY_CONVERT(DATETIMEOFFSET, created_at) IS NULL
        THEN 1
    END) AS InvalidDates,

    COUNT(CASE
        WHEN TRY_CONVERT(DATETIME2, created_at) > SYSDATETIME()
        THEN 1
    END) AS FutureDates

FROM stg.users;


--to know unique value
select distinct [gender]
from [stg].[users]

------Data Quality Check Table PRODUCTS-------------

select top 10 [id], [cost], [category], [name], [brand], [retail_price], [department], [sku], [distribution_center_id]
from [stg].[products]
---------------------------------------------------------------------------
--check id
select 
count ( case 
when [id] < 0 then 1 end ) as NegativeId,

count(case
when [id] is null then 1 end ) as nullValue,

from [stg].[products]

--check cost 

select 
count( case 
when [cost] is null then 1 end ) as nullValue,

count ( case 
when [cost] <= 0 then 1 end ) as negativeoorZeroCost

from [stg].[products]

--check category
select 
COUNT(case
when TRY_CONVERT(int,[category]) is not null then 1 end ) as numericCategory,

COUNT( case 
when trim([category] ) = '' then 1 end ) as spaceoremptyValue,

COUNT(case 
    when category <> TRIM(category)
    THEN 1
END) AS LeadingOrTrailingSpaces

from [stg].[products]


--check name 

select 
COUNT(case
when TRY_CONVERT(int,[name]) is not null then 1 end ) as numericName,

COUNT( case 
when trim( [name]) = '' then 1 end ) as spaceoremptyValue,
COUNT(CASE
    WHEN [name] <> TRIM([name])
    THEN 1
END) AS LeadingOrTrailingSpaces

from [stg].[products]


select [id], [cost], [category], [name], [brand], [retail_price], [department], [sku], [distribution_center_id]
from [stg].[products]
where TRY_CONVERT(int,[name]) is not null ;
----check duplicate------
select [id],COUNT(*) as dublicate
from [stg].[products]
group by [id]
having COUNT(*) > 1


SELECT
    cost,
    category,
    [name],
    brand,
    retail_price,
    department,
   
    COUNT(*) AS DuplicateCount,
    COUNT(DISTINCT sku) AS DifferentSKUs
FROM stg.products
GROUP BY
    cost,
    category,
    [name],
    brand,
    retail_price,
    department
HAVING COUNT(*) > 1;