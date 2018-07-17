1. String 1  ;WITH cteBase     common table expression is used 

3.On the 9th line there is a function called ROW_NUMBER() this function will give a numeric 
value to each row of the result set. These numbers will start at 1 for each combination 
of sCustomerRef and sAllowanceName ordered by dEndDate. 

4. On the 10 line there is a function called DENSE_RANK() 
This function returns the rank of each row within a result set partition (sCustomerRef), 
with no gaps in the ranking values. Values inside partition are ordered by    dEndDate.
The rank of a specific row is one plus the number of distinct rank values that come before that specific row.

5. Line 12.  Subquery is used. This subquery is used as <sq>  data source inside cteBase

6. Line 18 SUM   Agreagation for each combination of CustomerRef, [Customer Name], nDisplayOrder, sAllowanceName, [Year Month]

7. Line 19  WITH(NOLOCK) hint to duty read (READ UNCOMMITTED)  from table BusInt.Customer
8. Line 19 BusInt.Customer   Read data from Customer table in BusInt schema
9. Line 20 LEFT JOIN  ....  ON   .... COLLATE     Define collation that will affect result of string comparison result.
COLLATE is a clause applied to character string expression or column for textual data types to cast the string or column 
collation into a specified collation. 
COLLATE DATABASE_DEFAULT clause which will cast the character string expression or 
column collation into the collation of the database context where the command is executed. 

10. Join dbo.Split   user defined function is used for splitting  string into table value  . ',' is used as a delimiter.

11. WHERE sq.Cost IS NOT NULL    only rows with not null SUM(td.nResultValue)  will be returned from sq  subquery

12. LEFT(a.dEndDate, 4) AS [Year To Date] .  dEndDate is a string that contains date information.  LEFT  function will return 4 fisrt charachters  with year information
Alias [Year To Date] will be used for function result.

13. CONVERT (MONEY, a.Cost)  Cast a.Cost to MONEY data type

14. CASE WHEN   Calculate mathematical expressions and returns value  on a base of their results

15. ORDER BY Order  final resultset of a query 

16. OPTION recompile

17. [Customer Name]  use attribute name with spaces in name.