-- Find all customers that live in Durban who have the character "q" in their last name 
SELECT
    c.customerId,       c.firstName,        c.lastName,
    c.city,             c.[state],          c.postCode
FROM DerivCo.Customers c
WHERE c.city = 'Durban'
AND c.lastName LIKE '%q%'