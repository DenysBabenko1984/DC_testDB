-- What is the total number of products sold each month? 
SELECT DATENAME(MONTH,s.saleDate) 
    ,COUNT(DISTINCT s.productId) [NumberOfProducts]  -- Amount of Products per Month
FROM DerivCo.Sales s
GROUP BY DATENAME(MONTH,s.saleDate)