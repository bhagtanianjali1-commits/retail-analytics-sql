-- Customer Purchase Frequency

select 
    CustomerID, 
    count(*) as NumberOfTransactions
from sales_transaction
group by CustomerID
order by NumberOfTransactions desc;



-- High Purchase Frequency

select 
    CustomerID, 
    count(*) as NumberOfTransactions, 
    sum(QuantityPurchased * Price) as TotalSpent
from sales_transaction
group by CustomerID
having count(*) > 10 and sum(QuantityPurchased * Price) > 1000
order by TotalSpent desc;



-- Occasional Customers

select 
    CustomerID,
    count(*) as NumberOfTransactions,
    sum(QuantityPurchased * Price) as TotalSpent
from sales_transaction
group by CustomerID
having count(*) <= 2
order by NumberOfTransactions, TotalSpent desc;



-- Repeat Purchases

SELECT
    CustomerID,
    ProductID,
    COUNT(TransactionID) AS TimesPurchased
FROM sales_transaction
GROUP BY CustomerID, ProductID
HAVING COUNT(TransactionID) > 1
ORDER BY TimesPurchased DESC;



-- Loyalty Indicators

SELECT
    CustomerID,
    DATE_FORMAT(MIN(TransactionDate_dt), '%Y-%m-%d') AS FirstPurchase,
    DATE_FORMAT(MAX(TransactionDate_dt), '%Y-%m-%d') AS LastPurchase,
    DATEDIFF(
        MAX(TransactionDate_dt),
        MIN(TransactionDate_dt)
    ) AS DaysBetweenPurchases
FROM (
    SELECT
        CustomerID,
        STR_TO_DATE(TransactionDate, '%Y-%m-%d') AS TransactionDate_dt
    FROM sales_transaction
) AS Converted_Dates
GROUP BY CustomerID
HAVING DaysBetweenPurchases > 0
