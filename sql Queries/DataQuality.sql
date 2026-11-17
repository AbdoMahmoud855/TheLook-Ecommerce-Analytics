
USE TheLook_Ecommerce;
GO

------Data Quality Check Table Users-------------

SELECT TOP 50
    [id], [first_name], [last_name], [email], [age], [gender],
    [state], [street_address], [postal_code], [city], [country],
    [latitude], [longitude], [traffic_source], [created_at], [user_geom]
FROM [stg].[users];

---duplicate check id-----------


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



--duplicate email

SELECt

    email,
    COUNT(*) AS DuplicateCount
FROM stg.users
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;


SELECT
    [id], [first_name], [last_name], [email], [age], [gender],
    [state], [street_address], [postal_code], [city], [country],
    [latitude], [longitude], [traffic_source], [created_at], [user_geom]
FROM [stg].[users]
WHERE [email] IN (
    SELECT email
    FROM stg.users
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email;


--check duplicated emails with different user information

SELECT
    u.email,
    MIN(TRY_CONVERT(DATETIMEOFFSET, u.created_at)) AS FirstCreatedAt,
    MAX(TRY_CONVERT(DATETIMEOFFSET, u.created_at)) AS LastCreatedAt,
    COUNT(DISTINCT u.id) AS DifferentUserIDs,
    COUNT(DISTINCT u.age) AS DifferentAges
FROM stg.users AS u
WHERE u.email IS NOT NULL
  AND EXISTS (
      SELECT 1
      FROM stg.users AS u2
      WHERE u2.email = u.email
      GROUP BY u2.email
      HAVING COUNT(*) > 1
  )
GROUP BY u.email;


-----null check---------------


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
WHERE id <= 0;


------check if find empty string or space or right data

SELECT
    COUNT(CASE
        WHEN TRIM(first_name) = '' THEN 1
    END) AS EmptyOrSpacesFirstNames,

    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, TRIM(first_name)) IS NOT NULL
        THEN 1
    END) AS NumericFirstNames,

    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, TRIM(last_name)) IS NOT NULL

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

        WHEN TRIM(last_name) = '' THEN 1
    END) AS EmptyOrSpacesLastNames,

    COUNT(CASE
        WHEN email IS NOT NULL
         AND TRIM(email) <> ''
         AND email NOT LIKE '%_@_%._%'

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
        WHEN email IS NOT NULL
         AND TRIM(email) = ''
        THEN 1
    END) AS EmptyOrSpacesEmails,


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
        WHEN TRY_CONVERT(BIGINT, TRIM([state])) IS NOT NULL

	    COUNT(CASE
        WHEN TRY_CONVERT(BIGINT, [state]) IS NOT NULL

        THEN 1
    END) AS NumericState,

    COUNT(CASE

        WHEN TRIM([state]) = '' THEN 1
    END) AS EmptyOrSpacesState,

    COUNT(CASE
        WHEN [postal_code] LIKE '%[^0-9]%' THEN 1
    END) AS PostalCodeContainsNonNumericCharacters,

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

    END) AS NumericCountries,

    COUNT(CASE
        WHEN latitude NOT BETWEEN -90 AND 90 THEN 1
    END) AS InvalidLatitudes,

    COUNT(CASE
        WHEN longitude NOT BETWEEN -180 AND 180 THEN 1
    END) AS InvalidLongitudes,

    COUNT(CASE
        WHEN latitude = 0 AND longitude = 0 THEN 1
    END) AS ZeroCoordinates,

    COUNT(CASE
        WHEN created_at IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, created_at) IS NULL

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
>>>>>>> 9a64df1e03ad4da9dd2255a1ca26cbfcad1bff9f
        THEN 1
    END) AS InvalidDates,

    COUNT(CASE

        WHEN TRY_CONVERT(DATETIMEOFFSET, created_at) >
             TODATETIMEOFFSET(SYSUTCDATETIME(), '+00:00')

        WHEN TRY_CONVERT(DATETIME2, created_at) > SYSDATETIME()

        THEN 1
    END) AS FutureDates

FROM stg.users;


--to know unique value


SELECT DISTINCT [gender]
FROM [stg].[users];


------Data Quality Check Table PRODUCTS-------------

SELECT TOP 10
    [id], [cost], [category], [name], [brand],
    [retail_price], [department], [sku], [distribution_center_id]
FROM [stg].[products];


---------------------------------------------------------------------------
--check id

SELECT
    COUNT(CASE
        WHEN [id] < 0 THEN 1
    END) AS NegativeId,

    COUNT(CASE
        WHEN [id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [id] = 0 THEN 1
    END) AS ZeroValue
FROM [stg].[products];


--check cost

SELECT
    COUNT(CASE
        WHEN [cost] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [cost] < 0 THEN 1
    END) AS NegativeCost,

    COUNT(CASE
        WHEN [cost] = 0 THEN 1
    END) AS ZeroCost
FROM [stg].[products];


--check category

SELECT
    COUNT(CASE
        WHEN TRY_CONVERT(INT, [category]) IS NOT NULL
        THEN 1
    END) AS NumericCategory,

    COUNT(CASE
        WHEN TRIM([category]) = ''
        THEN 1
    END) AS SpaceOrEmptyValue,

    COUNT(CASE
        WHEN [category] <> TRIM([category])
        THEN 1
    END) AS LeadingOrTrailingSpaces
FROM [stg].[products];


--check name

SELECT
    COUNT(CASE
        WHEN TRY_CONVERT(FLOAT, [name]) IS NOT NULL
        THEN 1
    END) AS NumericName,

    COUNT(CASE
        WHEN TRIM([name]) = ''
        THEN 1
    END) AS SpaceOrEmptyValue,

    COUNT(CASE
        WHEN [name] <> TRIM([name])
        THEN 1
    END) AS LeadingOrTrailingSpaces
FROM [stg].[products];


SELECT
    [id], [cost], [category], [name], [brand],
    [retail_price], [department], [sku], [distribution_center_id]
FROM [stg].[products]
WHERE TRY_CONVERT(FLOAT, [name]) IS NOT NULL
   OR TRIM([name]) = '';


---------------------check brand

SELECT
    COUNT(CASE
        WHEN TRIM([brand]) <> ''
         AND TRY_CONVERT(FLOAT, TRIM([brand])) IS NOT NULL
        THEN 1
    END) AS NumericName,

    COUNT(CASE
        WHEN TRIM([brand]) = ''
        THEN 1
    END) AS SpaceOrEmptyValue,

    COUNT(CASE
        WHEN [brand] <> TRIM([brand])
        THEN 1
    END) AS LeadingOrTrailingSpaces
FROM [stg].[products];


SELECT
    [id], [cost], [category], [name], [brand],
    [retail_price], [department], [sku], [distribution_center_id]
FROM [stg].[products]
WHERE TRY_CONVERT(FLOAT, [brand]) IS NOT NULL
   OR TRIM([brand]) = '';


--to show number of missing or numeric value by all category

SELECT DISTINCT
    [category],

    COUNT(CASE
        WHEN TRIM([brand]) = '' THEN 1
    END) OVER (PARTITION BY [category]) AS SpaceOrEmptyValue,

    COUNT(CASE
        WHEN TRIM([brand]) <> ''
         AND TRY_CONVERT(FLOAT, TRIM([brand])) IS NOT NULL
        THEN 1
    END) OVER (PARTITION BY [category]) AS NumericValue

FROM [stg].[products];


SELECT *
FROM [stg].[products]
WHERE TRY_CONVERT(FLOAT, TRIM([brand])) IS NOT NULL
  AND TRIM([brand]) <> '';


--check brand normalization

WITH NORMALIZEBRAND AS (
    SELECT
        UPPER(TRIM(brand)) AS NormalizedBrand,
        COUNT(DISTINCT brand COLLATE Latin1_General_100_BIN2) AS DifferentFormats
    FROM stg.products
    WHERE brand IS NOT NULL
      AND TRIM(brand) <> ''
    GROUP BY UPPER(TRIM(brand))
    HAVING COUNT(DISTINCT brand COLLATE Latin1_General_100_BIN2) > 1
)

SELECT DISTINCT
    brand COLLATE Latin1_General_100_BIN2 AS OriginalBrand,
    UPPER(TRIM(brand)) AS NormalizedBrand
FROM stg.products
WHERE UPPER(TRIM(brand)) IN (
    SELECT NormalizedBrand
    FROM NORMALIZEBRAND
)
ORDER BY NormalizedBrand, OriginalBrand;


-------------retail_price

SELECT
    COUNT(CASE WHEN retail_price IS NULL THEN 1 END) AS NullValues,
    COUNT(CASE WHEN retail_price < 0 THEN 1 END) AS NegativeValues,
    COUNT(CASE WHEN retail_price = 0 THEN 1 END) AS ZeroValues
FROM [stg].[products];


-------------------------[department]-------------------------------------

SELECT
    COUNT(CASE
        WHEN TRY_CONVERT(FLOAT, [department]) IS NOT NULL
        THEN 1
    END) AS NumericValue,

    COUNT(CASE
        WHEN [department] <> TRIM([department])
        THEN 1
    END) AS SpaceValue,

    COUNT(CASE
        WHEN TRIM([department]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [department] IS NULL
        THEN 1
    END) AS NullValue

FROM [stg].[products];


--check department normalization

SELECT
    UPPER(TRIM([department])) AS NormalizedDepartment,
    COUNT(DISTINCT [department] COLLATE Latin1_General_100_BIN2) AS NumberOfDifferentDepartmentValues
FROM [stg].[products]
WHERE [department] IS NOT NULL
  AND TRIM([department]) <> ''
GROUP BY UPPER(TRIM([department]))
HAVING COUNT(DISTINCT [department] COLLATE Latin1_General_100_BIN2) > 1;


----[sku]--------------

SELECT
    COUNT(CASE
        WHEN [sku] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([sku]) = '' THEN 1
    END) AS EmptyValue
FROM [stg].[products];


----check duplicate------

--ID

SELECT
    [id],
    COUNT(*) AS Duplicate
FROM [stg].[products]
GROUP BY [id]
HAVING COUNT(*) > 1;


--NAME / FULL PRODUCT ATTRIBUTES

SELECT
    [cost],
    [category],
    [name],
    [brand],
    [retail_price],
    [department],
    [sku],
    [distribution_center_id],
    COUNT(*) AS DuplicateCount
FROM stg.products
GROUP BY
    [cost],
    [category],
    [name],
    [brand],
    [retail_price],
    [department],
    [sku],
    [distribution_center_id]
HAVING COUNT(*) > 1;


---[distribution_center_id]

--Repeated distribution center IDs are not necessarily duplicates.
--This query shows how many products belong to each distribution center.

SELECT
    [distribution_center_id],
    COUNT(*) AS NumberOfProducts
FROM [stg].[products]
GROUP BY [distribution_center_id]
ORDER BY NumberOfProducts DESC;


----[sku]

SELECT
    [sku],
    COUNT(*) AS Duplicate
FROM [stg].[products]
WHERE [sku] IS NOT NULL
GROUP BY [sku]
HAVING COUNT(*) > 1;


----------------------------------------------------------[stg].[orders]-----------------------------------------------------------

SELECT TOP (20)
    [order_id], [user_id], [status], [gender], [created_at],
    [returned_at], [shipped_at], [delivered_at], [num_of_item]
FROM [stg].[orders];


---------[order_id]------------------

SELECT
    COUNT(CASE
        WHEN [order_id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [order_id] <= 0 THEN 1
    END) AS NegativeOrZeroValue
FROM [stg].[orders];


--DUPLICATE_ID

SELECT
    [order_id],
    COUNT(*) AS Duplicate
FROM [stg].[orders]
GROUP BY [order_id]
HAVING COUNT(*) > 1;


----------------------[user_id]----------------------------

SELECT
    COUNT(CASE
        WHEN [user_id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [user_id] <= 0 THEN 1
    END) AS NegativeOrZeroValue
FROM [stg].[orders];


------------------------[status]----------------------

SELECT DISTINCT
    [status] COLLATE Latin1_General_100_BIN2 AS STATUS
FROM [stg].[orders];


SELECT
    COUNT(CASE WHEN status IS NULL THEN 1 END) AS NullValues,
    COUNT(CASE WHEN TRIM(status) = '' THEN 1 END) AS EmptyOrSpaces,
    COUNT(CASE WHEN status <> TRIM(status) THEN 1 END) AS LeadingTrailingSpaces
FROM stg.orders;


------------------------------------[gender]--------------------------------

SELECT DISTINCT
    [gender] COLLATE Latin1_General_100_BIN2 AS GENDER
FROM [stg].[orders];


SELECT
    COUNT(CASE WHEN [gender] IS NULL THEN 1 END) AS NullValues,
    COUNT(CASE WHEN TRIM([gender]) = '' THEN 1 END) AS EmptyOrSpaces,
    COUNT(CASE WHEN [gender] <> TRIM([gender]) THEN 1 END) AS LeadingTrailingSpaces
FROM stg.orders;


--------------------------------------[created_at]-------------------------------------------

SELECT
    COUNT(CASE
        WHEN created_at IS NOT NULL
         AND TRIM(created_at) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, created_at) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN [created_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([created_at]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRY_CONVERT(DATETIMEOFFSET, created_at) >
             TODATETIMEOFFSET(SYSUTCDATETIME(), '+00:00')
        THEN 1
    END) AS FutureDates

FROM [stg].[orders];


--------------[returned_at]------------------------------------------

SELECT
    COUNT(CASE
        WHEN [returned_at] IS NOT NULL
         AND TRIM([returned_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [returned_at]) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN TRIM([returned_at]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [returned_at] IS NULL
        THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [returned_at] IS NOT NULL
         AND TRIM([returned_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [returned_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [returned_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [created_at])
        THEN 1
    END) AS WrongDate

FROM [stg].[orders];


--check returned status consistency

SELECT
    COUNT(*) AS NumberOfErrorStatus
FROM [stg].[orders]
WHERE TRIM([returned_at]) = ''
  AND [status] = 'Returned';


--------------------------------[shipped_at]-----------------------------------

SELECT
    COUNT(CASE
        WHEN [shipped_at] IS NOT NULL
         AND TRIM([shipped_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN [shipped_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([shipped_at]) = '' THEN 1
    END) AS SpaceOrEmptyValue,

    COUNT(CASE
        WHEN [shipped_at] IS NOT NULL
         AND [created_at] IS NOT NULL
         AND TRIM([shipped_at]) <> ''
         AND TRIM([created_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [created_at])
        THEN 1
    END) AS WrongDate

FROM [stg].[orders];


--check status consistency with shipped_at

SELECT
    COUNT(CASE
        WHEN [status] = 'Complete' THEN 1
    END) AS CompleteStatus,

    COUNT(CASE
        WHEN [status] = 'Shipped' THEN 1
    END) AS ShippedStatus

FROM [stg].[orders]
WHERE [shipped_at] IS NULL
   OR TRIM([shipped_at]) = '';


SELECT
    COUNT(CASE
        WHEN [status] = 'Cancelled' THEN 1
    END) AS CancelledStatus,

    COUNT(CASE
        WHEN [status] = 'Processing' THEN 1
    END) AS ProcessingStatus

FROM [stg].[orders]
WHERE [shipped_at] IS NOT NULL
  AND TRIM([shipped_at]) <> ''
  AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL;


-----------------------------[delivered_at]-------------------------------

SELECT
    COUNT(CASE
        WHEN [delivered_at] IS NOT NULL
         AND TRIM([delivered_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN [delivered_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([delivered_at]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [delivered_at] IS NOT NULL
         AND TRIM([delivered_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NOT NULL
         AND [created_at] IS NOT NULL
         AND TRIM([created_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [created_at])
        THEN 1
    END) AS WrongDate,

    COUNT(CASE
        WHEN [delivered_at] IS NOT NULL
         AND TRIM([delivered_at]) <> ''
         AND [shipped_at] IS NOT NULL
         AND TRIM([shipped_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [shipped_at])
        THEN 1
    END) AS WrongDateSequence

FROM [stg].[orders];


--show data with delivered_at but missing created_at

SELECT
    [order_id], [user_id], [status], [gender], [created_at],
    [returned_at], [shipped_at], [delivered_at], [num_of_item]
FROM [stg].[orders]
WHERE ( [created_at] IS NULL OR TRIM([created_at]) = '' )
  AND [delivered_at] IS NOT NULL
  AND TRIM([delivered_at]) <> '';


--show delivered orders with unexpected status
--Review these cases against the source business rules before treating them as errors.

SELECT
    [order_id], [user_id], [status], [gender], [created_at],
    [returned_at], [shipped_at], [delivered_at], [num_of_item]
FROM [stg].[orders]
WHERE [status] NOT IN ('Complete', 'Returned')
  AND [delivered_at] IS NOT NULL
  AND TRIM([delivered_at]) <> '';


--------------------------------------[num_of_item]----------------------------------------

SELECT
    COUNT(CASE
        WHEN [num_of_item] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [num_of_item] <= 0 THEN 1
    END) AS NegativeOrZeroValue

FROM [stg].[orders];


--#########################################################################################
---------------------------------[stg].[order_items]---------------------------------------
--#########################################################################################

SELECT TOP (20)
    [id], [order_id], [user_id], [product_id], [inventory_item_id],
    [status], [created_at], [shipped_at], [delivered_at], [returned_at], [sale_price]
FROM [stg].[order_items]
ORDER BY [order_id];


-------##[id]##-----------

SELECT
    COUNT(CASE
        WHEN [id] <= 0 THEN 1
    END) AS NegativeOrZeroValue,

    COUNT(CASE
        WHEN [id] IS NULL THEN 1
    END) AS NullValue
FROM [stg].[order_items];


----DUPLICATE

SELECT
    [id],
    COUNT(*) AS DuplicateValue
FROM [stg].[order_items]
GROUP BY [id]
HAVING COUNT(*) > 1;


------------[order_id]---------------------

SELECT
    COUNT(CASE
        WHEN [order_id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [order_id] <= 0 THEN 1
    END) AS NegativeOrZeroValue
FROM [stg].[order_items];


----------------------[user_id]----------------------------

SELECT
    COUNT(CASE
        WHEN [user_id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [user_id] <= 0 THEN 1
    END) AS NegativeOrZeroValue
FROM [stg].[order_items];


---------------------[product_id]--------------------------

SELECT
    COUNT(CASE
        WHEN [product_id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [product_id] <= 0 THEN 1
    END) AS NegativeOrZeroValue
FROM [stg].[order_items];


-------------------------[inventory_item_id]-----------------------------

SELECT
    COUNT(CASE
        WHEN [inventory_item_id] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [inventory_item_id] <= 0 THEN 1
    END) AS NegativeOrZeroValue
FROM [stg].[order_items];


-------------------------------[status]-------------------------------------

SELECT DISTINCT
    [status] COLLATE Latin1_General_100_BIN2 AS STATUS
FROM [stg].[order_items];


SELECT
    COUNT(CASE WHEN status IS NULL THEN 1 END) AS NullValues,
    COUNT(CASE WHEN TRIM(status) = '' THEN 1 END) AS EmptyOrSpaces,
    COUNT(CASE WHEN status <> TRIM(status) THEN 1 END) AS LeadingTrailingSpaces
FROM [stg].[order_items];


------------------------------[created_at]---------------------------

SELECT
    COUNT(CASE
        WHEN created_at IS NOT NULL
         AND TRIM(created_at) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, created_at) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN [created_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([created_at]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRY_CONVERT(DATETIMEOFFSET, created_at) >
             TODATETIMEOFFSET(SYSUTCDATETIME(), '+00:00')
        THEN 1
    END) AS FutureDates

FROM [stg].[order_items];


--------------------------------[shipped_at]---------------------------------

--check data

SELECT
    COUNT(CASE
        WHEN [shipped_at] IS NOT NULL
         AND TRIM([shipped_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN [shipped_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([shipped_at]) = '' THEN 1
    END) AS SpaceOrEmptyValue,

    COUNT(CASE
        WHEN [shipped_at] IS NOT NULL
         AND [created_at] IS NOT NULL
         AND TRIM([shipped_at]) <> ''
         AND TRIM([created_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [created_at])
        THEN 1
    END) AS WrongDate

FROM [stg].[order_items];


---show data have wrong data

SELECT TOP (10)
    [id], [order_id], [user_id], [product_id], [inventory_item_id],
    [status], [created_at], [shipped_at]
FROM [stg].[order_items]
WHERE [shipped_at] IS NOT NULL
  AND [created_at] IS NOT NULL
  AND TRIM([created_at]) <> ''
  AND TRIM([shipped_at]) <> ''
  AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
  AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL
  AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) <
      TRY_CONVERT(DATETIMEOFFSET, [created_at]);


---show data have wrong status

SELECT
    COUNT(CASE
        WHEN [status] = 'Complete' THEN 1
    END) AS CompleteStatus,

    COUNT(CASE
        WHEN [status] = 'Shipped' THEN 1
    END) AS ShippedStatus

FROM [stg].[order_items]
WHERE [shipped_at] IS NULL
   OR TRIM([shipped_at]) = '';


SELECT
    COUNT(CASE
        WHEN [status] = 'Cancelled' THEN 1
    END) AS CancelledStatus,

    COUNT(CASE
        WHEN [status] = 'Processing' THEN 1
    END) AS ProcessingStatus

FROM [stg].[order_items]
WHERE [shipped_at] IS NOT NULL
  AND TRIM([shipped_at]) <> ''
  AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL;


--------------------------------[delivered_at]---------------------------------

SELECT
    COUNT(CASE
        WHEN [delivered_at] IS NOT NULL
         AND TRIM([delivered_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NULL
        THEN 1
    END) AS InvalidDateTime,

    COUNT(CASE
        WHEN [delivered_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([delivered_at]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [delivered_at] IS NOT NULL
         AND TRIM([delivered_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NOT NULL
         AND [created_at] IS NOT NULL
         AND TRIM([created_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [created_at])
        THEN 1
    END) AS WrongDate,

    COUNT(CASE
        WHEN [delivered_at] IS NOT NULL
         AND TRIM([delivered_at]) <> ''
         AND [shipped_at] IS NOT NULL
         AND TRIM([shipped_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [shipped_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [shipped_at])
        THEN 1
    END) AS WrongDateSequence

FROM [stg].[order_items];


--show data have wrong date

SELECT
    [id], [order_id], [user_id], [product_id],
    [inventory_item_id], [status], [created_at], [delivered_at]
FROM [stg].[order_items]
WHERE [delivered_at] IS NOT NULL
  AND TRIM([delivered_at]) <> ''
  AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) IS NOT NULL
  AND [created_at] IS NOT NULL
  AND TRIM([created_at]) <> ''
  AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
  AND TRY_CONVERT(DATETIMEOFFSET, [delivered_at]) <
      TRY_CONVERT(DATETIMEOFFSET, [created_at]);


--show delivered items with unexpected status
--Review these cases against the source business rules before treating them as errors.

SELECT
    [id], [order_id], [user_id], [product_id],
    [inventory_item_id], [status], [created_at],
    [shipped_at], [delivered_at], [returned_at]
FROM [stg].[order_items]
WHERE [status] NOT IN ('Complete', 'Returned')
  AND [delivered_at] IS NOT NULL
  AND TRIM([delivered_at]) <> '';


---------------------------------[sale_price]-------------------------------

SELECT
    COUNT(CASE
        WHEN [sale_price] = 0 THEN 1
    END) AS ZeroValue,

    COUNT(CASE
        WHEN [sale_price] < 0 THEN 1
    END) AS NegativeValue,

    COUNT(CASE
        WHEN [sale_price] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[order_items];


-------
--check unmatched order IDs

SELECT COUNT(*) AS UnmatchedOrderIDs
FROM stg.order_items AS oi
LEFT JOIN stg.orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


--check unmatched users

SELECT COUNT(*) AS UnmatchedUserIDs
FROM stg.order_items AS oi
LEFT JOIN stg.users AS u
    ON oi.user_id = u.id
WHERE u.id IS NULL;


--check unmatched products

SELECT COUNT(*) AS UnmatchedProductIDs
FROM stg.order_items AS oi
LEFT JOIN stg.products AS p
    ON oi.product_id = p.id
WHERE p.id IS NULL;


--check unmatched inventory items

SELECT COUNT(*) AS UnmatchedInventoryItemIDs
FROM stg.order_items AS oi
LEFT JOIN stg.inventory_items AS ii
    ON oi.inventory_item_id = ii.id
WHERE ii.id IS NULL;


--#######################################################################################
---------------------------[stg].[inventory_items]-------------------------------------
--#######################################################################################

SELECT COUNT(*)
FROM [stg].[inventory_items];


--check id

SELECT
    COUNT(CASE
        WHEN [id] < 0 THEN 1
    END) AS NegativeValue,

    COUNT(CASE
        WHEN [id] = 0 THEN 1
    END) AS ZeroValue,

    COUNT(CASE
        WHEN [id] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[inventory_items];


--duplicate

SELECT
    [id],
    COUNT(*) AS Duplicate
FROM [stg].[inventory_items]
GROUP BY [id]
HAVING COUNT(*) > 1;


--------------------[product_id]--------------------

SELECT
    COUNT(CASE
        WHEN [product_id] < 0 THEN 1
    END) AS NegativeValue,

    COUNT(CASE
        WHEN [product_id] = 0 THEN 1
    END) AS ZeroValue,

    COUNT(CASE
        WHEN [product_id] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[inventory_items];


---duplicate

--A product can have multiple inventory items.
--Repeated product_id values are expected and are not necessarily duplicates.

SELECT
    [product_id],
    COUNT(*) AS NumberOfInventoryItems
FROM [stg].[inventory_items]
GROUP BY [product_id]
HAVING COUNT(*) > 1
ORDER BY NumberOfInventoryItems DESC;


------------------------[created_at]---------------------------------

SELECT
    COUNT(CASE
        WHEN TRIM([created_at]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [created_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([created_at]) <> ''
         AND [created_at] IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NULL
        THEN 1
    END) AS WrongConvertDate,

    COUNT(CASE
        WHEN TRIM([created_at]) <> ''
         AND [created_at] IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) >
             TODATETIMEOFFSET(SYSUTCDATETIME(), '+00:00')
        THEN 1
    END) AS FutureDates

FROM [stg].[inventory_items];


---------------------------------[sold_at]------------------------------------------------

SELECT
    COUNT(CASE
        WHEN TRIM([sold_at]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [sold_at] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([sold_at]) <> ''
         AND [sold_at] IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [sold_at]) IS NULL
        THEN 1
    END) AS WrongConvertDate,

    COUNT(CASE
        WHEN TRIM([created_at]) <> ''
         AND TRIM([sold_at]) <> ''
         AND [created_at] IS NOT NULL
         AND [sold_at] IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [sold_at]) IS NOT NULL
         AND TRY_CONVERT(DATETIMEOFFSET, [sold_at]) <
             TRY_CONVERT(DATETIMEOFFSET, [created_at])
        THEN 1
    END) AS WrongDate

FROM [stg].[inventory_items];


-----------------------------------------------[cost]-----------------------------------------------------------

SELECT
    COUNT(CASE
        WHEN [cost] = 0 THEN 1
    END) AS ZeroValue,

    COUNT(CASE
        WHEN [cost] < 0 THEN 1
    END) AS NegativeValue,

    COUNT(CASE
        WHEN [cost] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[inventory_items];


---------------------------------------------[product_category]----------------------------------------------------

SELECT
    COUNT(CASE
        WHEN [product_category] IS NOT NULL
         AND TRIM([product_category]) <> ''
         AND TRY_CONVERT(FLOAT, [product_category]) IS NOT NULL
        THEN 1
    END) AS WrongValue,

    COUNT(CASE
        WHEN TRIM([product_category]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [product_category] IS NULL
        THEN 1
    END) AS NullValue

FROM [stg].[inventory_items];


--------------------------------------------------------[product_name]-------------------------------------------------

SELECT
    COUNT(CASE
        WHEN [product_name] IS NOT NULL
         AND TRIM([product_name]) <> ''
         AND TRY_CONVERT(FLOAT, [product_name]) IS NOT NULL
        THEN 1
    END) AS WrongValue,

    COUNT(CASE
        WHEN TRIM([product_name]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [product_name] IS NULL
        THEN 1
    END) AS NullValue

FROM [stg].[inventory_items];


SELECT
    [id], [product_id], [created_at], [sold_at], [cost],
    [product_category], [product_name], [product_brand],
    [product_retail_price], [product_department], [product_sku],
    [product_distribution_center_id]
FROM [stg].[inventory_items]
WHERE TRIM([product_name]) = '';


--------------------------------------------------[product_brand]-------------------------------------------------------

SELECT
    COUNT(CASE
        WHEN [product_brand] IS NOT NULL
         AND TRIM([product_brand]) <> ''
         AND TRY_CONVERT(FLOAT, [product_brand]) IS NOT NULL
        THEN 1
    END) AS WrongValue,

    COUNT(CASE
        WHEN TRIM([product_brand]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [product_brand] IS NULL
        THEN 1
    END) AS NullValue

FROM [stg].[inventory_items];


--check brandname is float value

SELECT
    [id], [product_id], [cost], [product_category],
    [product_name], [product_brand], [product_retail_price]
FROM [stg].[inventory_items]
WHERE [product_brand] IS NOT NULL
  AND TRIM([product_brand]) <> ''
  AND TRY_CONVERT(FLOAT, [product_brand]) IS NOT NULL;


SELECT
    [id], [product_id], [cost], [product_category],
    [product_name], [product_brand], [product_retail_price]
FROM [stg].[inventory_items]
WHERE TRIM([product_brand]) = '';


-------------------------------------------------------[product_retail_price]-------------------------------------------------------

SELECT
    COUNT(CASE
        WHEN [product_retail_price] = 0 THEN 1
    END) AS ZeroValue,

    COUNT(CASE
        WHEN [product_retail_price] < 0 THEN 1
    END) AS NegativeValue,

    COUNT(CASE
        WHEN [product_retail_price] IS NULL THEN 1
    END) AS NullRetailPrice,

    COUNT(CASE
        WHEN [product_retail_price] < [cost] THEN 1
    END) AS RetailPriceBelowCost

FROM [stg].[inventory_items];


------------------------------------[product_department]----------------------------------------

SELECT DISTINCT [product_department]
FROM [stg].[inventory_items];


SELECT
    COUNT(CASE
        WHEN TRIM([product_department]) <> [product_department]
        THEN 1
    END) AS SpaceName,

    COUNT(CASE
        WHEN TRY_CONVERT(FLOAT, [product_department]) IS NOT NULL
        THEN 1
    END) AS ErrorType,

    COUNT(CASE
        WHEN [product_department] IS NULL
        THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([product_department]) = ''
        THEN 1
    END) AS EmptyValue

FROM [stg].[inventory_items];


SELECT
    UPPER(TRIM(product_department)) AS NormalizedValue,
    COUNT(DISTINCT product_department COLLATE Latin1_General_100_BIN2) AS DifferentFormats,
    COUNT(*) AS TotalRows
FROM stg.inventory_items
WHERE product_department IS NOT NULL
  AND TRIM(product_department) <> ''
GROUP BY UPPER(TRIM(product_department))
HAVING COUNT(DISTINCT product_department COLLATE Latin1_General_100_BIN2) > 1;


--check unmatched product IDs

SELECT COUNT(*) AS UnmatchedProductIDs
FROM stg.inventory_items AS ii
LEFT JOIN stg.products AS p
    ON ii.product_id = p.id
WHERE p.id IS NULL;


--check distribution center IDs

SELECT COUNT(*) AS UnmatchedDistributionCenterIDs
FROM stg.inventory_items AS ii
LEFT JOIN stg.distribution_centers AS dc
    ON ii.product_distribution_center_id = dc.id
WHERE ii.product_distribution_center_id IS NOT NULL
  AND dc.id IS NULL;


---#############################################################################################
--------------------------------------[stg].[events]--------------------------------------------
---##############################################################################################


-------[id]-----------

SELECT
    COUNT(CASE
        WHEN [id] IS NOT NULL
         AND TRIM([id]) <> ''
         AND TRY_CONVERT(INT, [id]) IS NULL
        THEN 1
    END) AS ErrorDataType,

    COUNT(CASE
        WHEN [id] IS NOT NULL
         AND TRIM([id]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [id] IS NOT NULL
         AND TRIM([id]) <> ''
         AND TRY_CONVERT(INT, [id]) <= 0
        THEN 1
    END) AS ErrorValue,

    COUNT(CASE
        WHEN [id] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[events];


---duplicate id

SELECT
    [id],
    COUNT(*) AS Duplicate
FROM [stg].[events]
GROUP BY [id]
HAVING COUNT(*) > 1;


------------------------------------------[user_id]--------------------------------------

SELECT
    COUNT(CASE
        WHEN [user_id] IS NOT NULL
         AND TRIM([user_id]) <> ''
         AND TRY_CONVERT(FLOAT, [user_id]) IS NULL
        THEN 1
    END) AS ErrorDataType,

    COUNT(CASE
        WHEN [user_id] IS NOT NULL
         AND TRIM([user_id]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [user_id] IS NOT NULL
         AND TRIM([user_id]) <> ''
         AND TRY_CONVERT(FLOAT, [user_id]) <= 0
        THEN 1
    END) AS ErrorValue,

    COUNT(CASE
        WHEN [user_id] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[events];


--Repeated user IDs are expected because one user can generate multiple events.

SELECT
    [user_id],
    COUNT([user_id]) AS NumberOfEvents
FROM [stg].[events]
GROUP BY [user_id]
HAVING COUNT([user_id]) > 1
ORDER BY NumberOfEvents DESC;


----------------------------------------------[sequence_number]-----------------------------

SELECT
    COUNT(CASE
        WHEN [sequence_number] IS NOT NULL
         AND TRIM([sequence_number]) <> ''
         AND TRY_CONVERT(INT, [sequence_number]) IS NULL
        THEN 1
    END) AS ErrorDataType,

    COUNT(CASE
        WHEN TRY_CONVERT(INT, [sequence_number]) <= 0
        THEN 1
    END) AS ErrorValue,

    COUNT(CASE
        WHEN TRIM([sequence_number]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [sequence_number] IS NULL
        THEN 1
    END) AS NullValue

FROM [stg].[events];


-------------------------------------[session_id]----------------------------

SELECT
    COUNT(CASE
        WHEN [session_id] IS NOT NULL
         AND TRIM([session_id]) <> ''
         AND TRY_CONVERT(INT, [session_id]) IS NULL
        THEN 1
    END) AS StringValue,

    COUNT(CASE
        WHEN [session_id] IS NULL
        THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([session_id]) = ''
        THEN 1
    END) AS EmptyValue

FROM [stg].[events];


--Repeated session IDs are expected because one session contains multiple events.

SELECT
    [session_id],
    COUNT(*) AS NumberOfEvents
FROM [stg].[events]
GROUP BY [session_id]
HAVING COUNT(*) > 1
ORDER BY NumberOfEvents DESC;


-----------------------------[created_at]------------------------

SELECT
    COUNT(CASE
        WHEN [created_at] IS NOT NULL
         AND TRIM([created_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET, [created_at]) IS NULL
        THEN 1
    END) AS ErrorConvert,

    COUNT(CASE
        WHEN [created_at] IS NULL
        THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN [created_at] IS NOT NULL
         AND TRIM([created_at]) = ''
        THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN [created_at] IS NOT NULL
         AND TRIM([created_at]) <> ''
         AND TRY_CONVERT(DATETIMEOFFSET(6), [created_at]) >
             TODATETIMEOFFSET(SYSUTCDATETIME(), '+00:00')
        THEN 1
    END) AS FutureDates

FROM [stg].[events];


--------------------------------[ip_address]-------------------------------

SELECT TOP 20 ip_address
FROM stg.events
WHERE ip_address IS NOT NULL;


SELECT
    COUNT(CASE
        WHEN [ip_address] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([ip_address]) = '' THEN 1
    END) AS EmptyValue

FROM [stg].[events];


--check IPv4 format

WITH unique_ips AS (
    SELECT DISTINCT ip_address
    FROM stg.events
    WHERE ip_address IS NOT NULL
      AND TRIM(ip_address) <> ''
),
ip_parts AS (
    SELECT
        e.ip_address,
        COUNT(*) AS parts_count,
        SUM(
            CASE
                WHEN TRY_CONVERT(INT, s.value) IS NULL
                  OR TRIM(s.value) = ''
                  OR TRY_CONVERT(INT, s.value) NOT BETWEEN 0 AND 255
                  OR s.value LIKE '%[^0-9]%'
                THEN 1
                ELSE 0
            END
        ) AS invalid_parts
    FROM unique_ips AS e
    CROSS APPLY STRING_SPLIT(e.ip_address, '.') AS s
    GROUP BY e.ip_address
)
SELECT *
FROM ip_parts
WHERE parts_count <> 4
   OR invalid_parts > 0;


----------------------------------------------[city]--------------------------------------

SELECT
    COUNT(CASE
        WHEN city IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([city]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([city]) <> [city] THEN 1
    END) AS Space

FROM [stg].[events];


SELECT
    UPPER(TRIM(city)) AS NormalizedCity,
    COUNT(DISTINCT city COLLATE Latin1_General_100_BIN2) AS DifferentFormats,
    COUNT(*) AS TotalRows
FROM stg.events
WHERE city IS NOT NULL
  AND TRIM(city) <> ''
GROUP BY UPPER(TRIM(city))
HAVING COUNT(DISTINCT city COLLATE Latin1_General_100_BIN2) > 1;


SELECT
    city COLLATE Latin1_General_100_BIN2 AS OriginalCity,
    COUNT(*) AS TotalRows
FROM stg.events
WHERE UPPER(TRIM(city)) = 'NATIONAL CITY'
GROUP BY city COLLATE Latin1_General_100_BIN2;


--------------------------------------------------[state]--------------------------------------

SELECT
    COUNT(CASE
        WHEN [state] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([state]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([state]) <> [state] THEN 1
    END) AS SpaceValue

FROM [stg].[events];


SELECT
    UPPER(TRIM([state])) AS NormalizedValue,
    COUNT(DISTINCT [state] COLLATE Latin1_General_100_BIN2) AS DifferentValue,
    COUNT(*) AS NumberOfRows
FROM [stg].[events]
WHERE [state] IS NOT NULL
  AND TRIM([state]) <> ''
GROUP BY UPPER(TRIM([state]))
HAVING COUNT(DISTINCT [state] COLLATE Latin1_General_100_BIN2) > 1;


-------------------------------------------------[postal_code]----------------------------------------

SELECT
    COUNT(CASE
        WHEN [postal_code] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([postal_code]) = '' THEN 1
    END) AS EmptyValue

FROM [stg].[events];


---------------------------------------------------[browser]------------------------------------------

SELECT
    COUNT(CASE
        WHEN [browser] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([browser]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([browser]) <> [browser] THEN 1
    END) AS Space

FROM [stg].[events];


SELECT
    UPPER(TRIM([browser])) AS NormalizeValue,
    COUNT(DISTINCT [browser] COLLATE Latin1_General_100_BIN2) AS DifferentValue,
    COUNT(*) AS NumberOfRows
FROM [stg].[events]
WHERE [browser] IS NOT NULL
  AND TRIM([browser]) <> ''
GROUP BY UPPER(TRIM([browser]))
HAVING COUNT(DISTINCT [browser] COLLATE Latin1_General_100_BIN2) > 1;


------------------------------------------------------[traffic_source]-----------------------------------------------

SELECT
    COUNT(CASE
        WHEN [traffic_source] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([traffic_source]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([traffic_source]) <> [traffic_source]
        THEN 1
    END) AS SpaceValue

FROM [stg].[events];


SELECT
    UPPER(TRIM([traffic_source])) AS NormalizedValue,
    COUNT(DISTINCT [traffic_source] COLLATE Latin1_General_100_BIN2) AS DifferentValue,
    COUNT(*) AS CountRows
FROM [stg].[events]
WHERE [traffic_source] IS NOT NULL
  AND TRIM([traffic_source]) <> ''
GROUP BY UPPER(TRIM([traffic_source]))
HAVING COUNT(DISTINCT [traffic_source] COLLATE Latin1_General_100_BIN2) > 1;


---------------------------------------------[uri]------------------------------------------

SELECT
    COUNT(CASE
        WHEN [uri] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([uri]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([uri]) <> [uri] THEN 1
    END) AS SpaceValue

FROM [stg].[events];


-----------------------------------------------------[event_type]----------------------------------------

SELECT
    COUNT(CASE
        WHEN [event_type] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([event_type]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([event_type]) <> [event_type]
        THEN 1
    END) AS SpaceValue

FROM [stg].[events];


SELECT
    UPPER(TRIM([event_type])) AS NormalizedValue,
    COUNT(DISTINCT [event_type] COLLATE Latin1_General_100_BIN2) AS DifferentValue,
    COUNT(*) AS CountRows
FROM [stg].[events]
WHERE [event_type] IS NOT NULL
  AND TRIM([event_type]) <> ''
GROUP BY UPPER(TRIM([event_type]))
HAVING COUNT(DISTINCT [event_type] COLLATE Latin1_General_100_BIN2) > 1;


--###############################################################################################
---------------------------------------[stg].[distribution_centers]----------------------------------------------
--###############################################################################################

SELECT TOP 10
    [id], [name], [latitude], [longitude], [distribution_center_geom]
FROM [stg].[distribution_centers];


------------------------------------------------------[id]--------------------------------------------------------

SELECT
    COUNT(CASE
        WHEN [id] = 0 THEN 1
    END) AS ZeroValue,

    COUNT(CASE
        WHEN [id] < 0 THEN 1
    END) AS NegativeValue,

    COUNT(CASE
        WHEN [id] IS NULL THEN 1
    END) AS NullValue

FROM [stg].[distribution_centers];


---check duplicate

SELECT
    [id],
    COUNT(*) AS Duplicate
FROM [stg].[distribution_centers]
GROUP BY [id]
HAVING COUNT(*) > 1;


-----------------------------------------------------[name]-------------------------------------------

SELECT
    COUNT(CASE
        WHEN [name] IS NULL THEN 1
    END) AS NullValue,

    COUNT(CASE
        WHEN TRIM([name]) = '' THEN 1
    END) AS EmptyValue,

    COUNT(CASE
        WHEN TRIM([name]) <> [name] THEN 1
    END) AS SpaceValue

FROM [stg].[distribution_centers];


SELECT
    UPPER(TRIM([name])) AS NormalizedValue,
    COUNT(DISTINCT [name] COLLATE Latin1_General_100_BIN2) AS DifferentValue,
    COUNT(*) AS NumberOfRows
FROM [stg].[distribution_centers]
WHERE [name] IS NOT NULL
  AND TRIM([name]) <> ''
GROUP BY UPPER(TRIM([name]))
HAVING COUNT(DISTINCT [name] COLLATE Latin1_General_100_BIN2) > 1;


------------------------------------------------[latitude]---------[longitude]----------------------------------------

SELECT
    COUNT(CASE
        WHEN [latitude] NOT BETWEEN -90 AND 90
        THEN 1
    END) AS Invalid_Latitude,

    COUNT(CASE
        WHEN [longitude] NOT BETWEEN -180 AND 180
        THEN 1
    END) AS Invalid_Longitude,

    COUNT(CASE
        WHEN [latitude] IS NULL
        THEN 1
    END) AS Null_Latitude,

    COUNT(CASE
        WHEN [longitude] IS NULL
        THEN 1
    END) AS Null_Longitude

FROM [stg].[distribution_centers];


--check zero coordinates

SELECT
    COUNT(CASE
        WHEN [latitude] = 0 AND [longitude] = 0
        THEN 1
    END) AS ZeroCoordinates
FROM [stg].[distribution_centers];


--check unmatched distribution center references in products

SELECT COUNT(*) AS UnmatchedDistributionCenterIDs
FROM stg.products AS p
LEFT JOIN stg.distribution_centers AS dc
    ON p.distribution_center_id = dc.id
WHERE p.distribution_center_id IS NOT NULL
  AND dc.id IS NULL;

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
when [id] is null then 1 end ) as nullValue

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
>>>>>>> 9a64df1e03ad4da9dd2255a1ca26cbfcad1bff9f
