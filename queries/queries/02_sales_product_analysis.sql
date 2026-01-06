-- Total Sales Summary 

select 
    ProductID, 
    sum(QuantityPurchased) as TotalUnitsSold,
    sum(QuantityPurchased * Price) as TotalSales
from sales_transaction
group by ProductID
order by TotalSales Desc;



-- Product Categories Performance

select 
    p.Category, 
    sum(s.QuantityPurchased) as TotalUnitsSold,
    sum(s.QuantityPurchased * s.Price) as TotalSales
from sales_transaction s 
join product_inventory p on p.Price = s.Price
group by p.Category
order by TotalSales desc;



-- High Sales Products

select ProductID,
sum(QuantityPurchased * Price) as TotalRevenue
from sales_transaction
group by ProductID
order by TotalRevenue desc
limit 10;



-- Low Sales Products

select ProductID, sum(QuantityPurchased) as TotalUnitsSold
from sales_transaction
group by  ProductID
having sum(QuantityPurchased) > 1
order by TotalUnitsSold asc
limit 10;



-- Sales Trend

select 
    date(TransactionDate) as DATETRANS,
    count(*) as Transaction_count,
    sum(QuantityPurchased) as TotalUnitsSold,
    sum(QuantityPurchased * Price) as TotalSales
from sales_transaction
group by DATETRANS
order by Transaction_count desc;



-- Growth Rate of Sales

with Monthly_Sales AS (
    select
        month(TransactionDate) AS month,
        sum(QuantityPurchased * Price) AS total_sales
    from sales_transaction
    group by month(TransactionDate)
)
select
    Month,
    round(total_sales, 2) AS Total_Sales,
    round(LAG(total_sales) over (order by month), 2) AS previous_month_sales,
    round(
        (total_sales - LAG(total_sales) over (order by month))
        / LAG(total_sales) over (order by Month) * 100,
        2
    ) AS mom_growth_percentage
FROM Monthly_Sales
ORDER BY month;
