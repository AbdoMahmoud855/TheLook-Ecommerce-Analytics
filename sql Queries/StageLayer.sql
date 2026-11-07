CREATE DATABASE TheLook_Ecommerce;
GO

USE TheLook_Ecommerce;
GO

SELECT DB_NAME() AS CurrentDatabase;

CREATE SCHEMA stg;
GO

SELECT name
FROM sys.schemas
WHERE name = 'stg';

USE TheLook_Ecommerce;
GO
------------create stage UserTable--------------------
CREATE TABLE stg.users (
    id              INT,
    first_name      NVARCHAR(100),
    last_name       NVARCHAR(100),
    email           NVARCHAR(255),
    age             INT,
    gender          NVARCHAR(20),
    state           NVARCHAR(100),
    street_address  NVARCHAR(255),
    postal_code     NVARCHAR(30),
    city            NVARCHAR(100),
    country         NVARCHAR(100),
    latitude        FLOAT,
    longitude       FLOAT,
    traffic_source  NVARCHAR(50),
    created_at      DATETIME2,
    user_geom       NVARCHAR(MAX)
);
GO
ALTER TABLE stg.users
ALTER COLUMN created_at NVARCHAR(50);
GO
----------------create Products Stage--------------------------------

CREATE TABLE stg.products (
    id                      INT,
    cost                    FLOAT,
    category                NVARCHAR(100),
    name                    NVARCHAR(255),
    brand                   NVARCHAR(100),
    retail_price            FLOAT,
    department              NVARCHAR(100),
    sku                     NVARCHAR(100),
    distribution_center_id  INT
);
GO
ALTER TABLE stg.products
ALTER COLUMN name NVARCHAR(1000);
GO
select [id], [cost], [category], [name], [brand], [retail_price], [department], [sku], [distribution_center_id]
from[stg].[products]

-----------create order table---------
CREATE TABLE stg.orders (
    order_id       INT,
    user_id        INT,
    status         NVARCHAR(50),
    gender         NVARCHAR(20),
    created_at     NVARCHAR(50),
    returned_at    NVARCHAR(50),
    shipped_at     NVARCHAR(50),
    delivered_at   NVARCHAR(50),
    num_of_item    INT
);
GO

--------order_items----------

create table stg.order_items (
    id            INT,
	order_id      INT,
	user_id       INT,
	product_id    INT,
	inventory_item_id INT,
	status         NVARCHAR(50),
	created_at     NVARCHAR(50),
	shipped_at     NVARCHAR(50),
	delivered_at   NVARCHAR(50),
    returned_at    NVARCHAR(50),
	sale_price     float
	);
	go
-----------inventory_items----------

   create TABLE stg.inventory_items(
   id            INT,
   product_id    INT,
   created_at     NVARCHAR(50),
   sold_at     NVARCHAR(50),
   cost        Float,
   product_category    NVARCHAR(50),
   product_name        NVARCHAR(50), 
   product_brand       NVARCHAR(50),
   product_retail_price  float,
   product_department NVARCHAR(50),
   product_sku NVARCHAR(50),
   product_distribution_center_id NVARCHAR(50),
   );
   go
   alter table stg.inventory_items 
   alter column product_distribution_center_id  INT

   alter table stg.inventory_items 
   alter column           product_name        NVARCHAR(1000)

---------------events------------------------------

CREATE TABLE stg.events (
    id               NVARCHAR(50),
    user_id          NVARCHAR(50),
    sequence_number  NVARCHAR(50),
    session_id       NVARCHAR(100),
    created_at       NVARCHAR(50),
    ip_address       NVARCHAR(50),
    city             NVARCHAR(255),
    state            NVARCHAR(255),
    postal_code      NVARCHAR(50),
    browser          NVARCHAR(100),
    traffic_source   NVARCHAR(100),
    uri              NVARCHAR(MAX),
    event_type       NVARCHAR(50)
);
GO
----------------distribution_centers---------------
CREATE TABLE stg.distribution_centers (
    id                       INT,
    name                     NVARCHAR(255),
    latitude                 FLOAT,
    longitude                FLOAT,
    distribution_center_geom NVARCHAR(MAX)
);
GO
----------------------------------------------


