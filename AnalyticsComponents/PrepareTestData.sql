IF (OBJECT_ID('[DerivCo].[Customers]') IS NOT NULL) DROP TABLE [DerivCo].[Customers] 
GO

CREATE TABLE [DerivCo].[Customers] (
    [customerId] INT           IDENTITY (1, 1) NOT NULL,
    [firstName]  VARCHAR (255) NOT NULL,
    [lastName]   VARCHAR (255) NOT NULL,
    [city]       VARCHAR (255) NULL,
    [state]      VARCHAR (255) NULL,
    [postCode]   VARCHAR (10)  NULL
);
GO

INSERT INTO [DerivCo].Customers(firstName,lastName,city,[state],postCode)
VALUES ('John', 'Devis', 'San-Francisco', 'CA', '012389'),
('Den', 'Clam', 'Santa-Clara', 'CA', '256890'),
('Bob', 'Smith', 'New York', 'NY', '1278645'),
('Mike', 'Peterson', 'New York', 'NY', '1278645'),
('Maq', 'Samersq', 'Durban', 'DU', '6653902')

GO

IF (OBJECT_ID('[DerivCo].[Products]') IS NOT NULL) DROP TABLE [DerivCo].[Products] 
GO

CREATE TABLE [DerivCo].[Products] (
    [productId]        INT             NOT NULL,
    [parentProductId]  INT             NULL,
    [productName]      VARCHAR (1000)  NOT NULL,
    [recommendedPrice] NUMERIC (10, 2) NULL,
    [category]         VARCHAR (100)   NULL
);
GO

INSERT INTO DerivCo.[Products](productId,parentProductId,productName,recommendedPrice,category)
    VALUES
        (1, NULL,  'PC1',1.0,'C'),
        (2, NULL,  'PC2',1.0,'C'),
        (3, NULL,  'PC3',1.5,'C'),
        (4, NULL,  'PC4',2.4,'C'),
        (5, NULL,  'PA1',1.9,'A'),
        (6, NULL,  'PA2',1.2,'A'),
        (7, NULL,  'PA3',1.1,'A'),
        (8, NULL,  'PB1',1.8,'B'),
        (9, NULL,  'PB2',1.9,'B'),
        (10, NULL, 'PB3',1.9,'B'),

        (11, 1, 'PC11',2.0,'C'),
        (12, 11, 'PC111',5.0,'C'),
        (13, 2, 'PC12',3.0,'C'),
        (14, 2, 'PC13',3.0,'C'),

        (15, 4, 'PC14',2.0,'C'),
        (16, 11, 'PC112',10.0,'C'),
        (17, 5, 'PA11',3.0,'A'),
        (18, 8, 'PA12',3.0,'A'),
        (18, 18, 'PA121',15.5,'A')
GO

IF (OBJECT_ID('[DerivCo].[Sales]') IS NOT NULL) DROP TABLE [DerivCo].Sales 
GO

CREATE TABLE [DerivCo].[Sales] (
    [saleId]     INT             IDENTITY (1, 1) NOT NULL,
    [productId]  INT             NULL,
    [customerId] INT             NULL,
    [salePrice]  NUMERIC (10, 2) NULL,
    [saleDate]   DATE            NULL
);
GO

DECLARE @ClientCount INT
	,@ProductCount INT


SELECT @ClientCount = COUNT(1) FROM DerivCo.Customers
SELECT @ProductCount = COUNT(1) FROM DerivCo.Products
DECLARE @BaseDate DATE = '20180101'

TRUNCATE TABLE DerivCo.Sales

;WITH numbers AS
(
	SELECT 1 as num
	UNION ALL 
	SELECT num + 1
	FROM numbers
	WHERE num < 10000
),
randomSales AS (
SELECT 
	1+FLOOR(RAND(convert(varbinary, newid())) * @ClientCount) as clientId,
	1+FLOOR(RAND(convert(varbinary, newid())) * @ProductCount) as productId,
	DATEADD(DAY,FLOOR(RAND(convert(varbinary, newid())) * 365),@BaseDate) AS saleDateRand,
	-1.0 + RAND(convert(varbinary, newid())) * 2.0 as priceRand
FROM numbers n
)
INSERT INTO DerivCo.Sales(customerId, productId, salePrice, saleDate)
SELECT 
	r.clientId AS [customerId]
	,r.productId
	,CAST((r.priceRand + p.recommendedPrice) AS NUMERIC(10,2)) AS [salePrice]
	,r.saleDateRand AS [saleDate]
FROM randomSales r
INNER JOIN DerivCo.Products p ON p.productId = r.productId
OPTION (maxrecursion 10000)