-- Write a script to list the full Bill of Materials for each product 
;WITH PH AS ( -- Parse product hierarchy with CTE
    SELECT p.productId     AS [rootProductId]
        ,p.productId		,p.parentProductId        ,p.productName	       
		,0 as [level]
    FROM DerivCo.Products p
    UNION ALL
    SELECT PH.rootProductId
        ,p.productId	    ,p.parentProductId        ,p.productName
        ,PH.[level] + 1 as [level]
    FROM DerivCo.Products p
    INNER JOIN PH ON PH.parentProductId = p.productId
)
SELECT 
	rootProductId 
   ,STRING_AGG(CAST(productId as INT),'<-') WITHIN GROUP (ORDER BY level)
   ,STRING_AGG(productName,'<-') WITHIN GROUP (ORDER BY level) AS [BOM]
FROM PH
GROUP BY rootProductId


-- This task could be implemented also with Hierarchy data type 
-- or with MS SQL Graph db  that was implemented in SQL Server 2017