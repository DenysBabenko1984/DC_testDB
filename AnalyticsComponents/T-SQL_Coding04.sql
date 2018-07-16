-- Flag all products sold where the recommended price is lower than the average sale price
;WITH AVGP AS (
    SELECT  productId
        ,AVG(salePrice) AS [averageSalePrice]
    FROM    DerivCo.Sales
    GROUP BY productId
)
SELECT  p.productId,            p.productName,              p.category,
        p.recommendedPrice,     AVGP.averageSalePrice
FROM    DerivCo.Products p 
INNER JOIN  AVGP ON  AVGP.productId = p.productId    
    AND p.recommendedPrice < AVGP.[averageSalePrice]
ORDER BY p.productId