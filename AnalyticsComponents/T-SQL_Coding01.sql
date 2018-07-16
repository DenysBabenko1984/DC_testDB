-- Find each customers first and last purchase of each type of product.
SELECT DISTINCT
	c.customerId,	c.firstName,	c.lastName,	p.category
	,FIRST_VALUE(s.saleDate) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [FirstDate]
	,FIRST_VALUE(s.salePrice) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [FirstSalePrice]
	,FIRST_VALUE(sp.productName) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [FirstProduct]
	,LAST_VALUE(s.saleDate) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [LastDate]
	,LAST_VALUE(s.salePrice) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [LastSalePrice]
	,LAST_VALUE(sp.productName) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [LastProduct]
FROM DerivCo.Sales s
INNER JOIN DerivCo.Products sp ON sp.productId = s.productId
RIGHT JOIN (DerivCo.Products p CROSS JOIN DerivCo.Customers c) ON p.productId = s.productId AND c.customerId = s.customerId


/*
 First INNER JOIN with Products table  recuired for retrieve  ProductName  as a description for sale record
 RIGHT JOIN (DerivCo.Products p CROSS JOIN DerivCo.Customers c)   RIGHT JOIN required because we can face a situation when Client has no purchases

 Test case for Client without purchase
BEGIN TRAN
INSERT INTO DerivCo.Customers(firstName, lastName,city)
SELECT 'Cli1', 'LastName1', 'city1'

<SELECT Query here>

ROLLBACK TRAN
 */

 -- Next one solution is more optimal from performance point of view
;WITH SPC AS (
    SELECT DISTINCT
        c.customerId,	c.firstName,	c.lastName,	p.category
        ,FIRST_VALUE(s.saleId) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [FirstSaleId]    
        ,LAST_VALUE(s.saleId) OVER (PARTITION BY c.customerId, p.category ORDER BY s.saleDate, s.saleId ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [LastSaleId]    
    FROM DerivCo.Sales s
    RIGHT JOIN (DerivCo.Products p CROSS JOIN DerivCo.Customers c) ON p.productId = s.productId AND c.customerId = s.customerId
)
SELECT SPC.customerId, SPC.firstName, SPC.lastName, SPC.category
    ,sf.saleDate AS [FirstDate]
    ,sf.salePrice AS [FirstSalePrice]
    ,pf.productName AS [FirstProductName]
    ,sl.saleDate AS [LastDate]
    ,sl.salePrice AS [LastSalePrice]
    ,pl.productName AS [LastProductName]
FROM SPC
LEFT OUTER JOIN (DerivCo.Sales sf INNER JOIN DerivCo.Products pf ON pf.productId = sf.productId) ON sf.saleId = SPC.FirstSaleId
LEFT OUTER JOIN (DerivCo.Sales sl INNER JOIN DerivCo.Products pl ON pl.productId = sl.productId) ON sl.saleId = SPC.FirstSaleId
