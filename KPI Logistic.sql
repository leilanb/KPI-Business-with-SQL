SELECT  
    od.productcode AS 'Ref', 
    p.productName AS 'Name', 
    SUM(od.quantityOrdered) as 'Total Units', 
	  p.quantityInStock AS 'Stock Unit', 
    p.quantityInStock*buyPrice as 'Stock in $', 
    
    (
        p.quantityInStock/
            (
                SELECT SUM(quantityInStock)
                FROM products
            ) * 100
    ) AS 'Percent stock globale',
    
    (
        p.quantityInStock*buyPrice /
        (
            SELECT SUM(quantityInStock*buyPrice)
            FROM products
        ) * 100
    ) AS 'Percent in $'
    
FROM orderdetails od

LEFT JOIN products p ON od.productCode = p.productCode
LEFT JOIN orders o ON od.orderNumber = o.orderNumber

WHERE od.orderNumber IS NOT NULL AND p.productCode IS NOT NULL AND o.orderNumber IS NOT NULL
GROUP BY p.productName
ORDER BY SUM(od.quantityOrdered) DESC
LIMIT 5
