-- Remove Duplicates

SELECT TransactionID, count(*) FROM sales_transaction
GROUP BY TransactionID
HAVING COUNT(*)>1;
 
CREATE TABLE sales_transaction_unique AS
SELECT distinct TransactionID, CustomerID, ProductID, QuantityPurchased, TransactionDate, Price
FROM sales_transaction;

SELECT *
FROM sales_transaction_unique;

DROP TABLE sales_transaction;
RENAME TABLE sales_transaction_unique TO sales_transaction;



-- Fix Incorrect Prices

SELECT 
    st.TransactionID,
    st.Price AS TransactionPrice,
    pi.Price AS InventoryPrice
FROM sales_transaction st
JOIN product_inventory pi
    ON st.ProductID = pi.ProductID
WHERE st.Price <> pi.Price;

UPDATE sales_transaction st
JOIN product_inventory pi
    ON st.ProductID = pi.ProductID
SET st.Price = pi.Price
WHERE st.Price <> pi.Price;

SELECT * from sales_transaction;



-- Fixing Null Values

SELECT 
    COUNT(*) 
FROM customer_profiles
WHERE Gender IS NULL
   OR Location IS NULL;

UPDATE customer_profiles
SET 
    Gender = COALESCE(Gender, 'Unknown'),
    Location = COALESCE(Location, 'Unknown');

SELECT *
FROM customer_profiles;



-- Cleaning Date

CREATE TABLE sales_transaction_cleaned AS
SELECT
    TransactionID,
    CustomerID,
    ProductID,
    QuantityPurchased,
    TransactionDate,
    Price,
    STR_TO_DATE(TransactionDate, '%Y-%m-%d') AS TransactionDate_updated
FROM sales_transaction;

DROP TABLE sales_transaction;

RENAME TABLE sales_transaction_cleaned TO sales_transaction;

SELECT * FROM sales_transaction;
