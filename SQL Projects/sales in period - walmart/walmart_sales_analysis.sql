--- checking structure of all tables
--- null values are already removed using Excel

select * from inventory;
describe inventory;

select * from products;
describe products;

select * from sales;
describe sales;



--- Problem Statement: Optimize inventory levels to avoid stockouts and overstock situations.

--- What is the current quantity available for each product in each store?

select i.StoreId, i.StoreName, p.ProductId, p.ProductName, QuantityAvailable
from inventory i
join products p
on i.ProductId = p.ProductId
order by i.StoreName;

--- Which products are running low on inventory across all stores?

select I.ProductId, P.ProductName, MIN(I.QuantityAvailable) AS MinQuantityAvailable
from Inventory I
join Products P 
ON I.ProductId = P.ProductId
group by I.ProductId, P.ProductName
order by MinQuantityAvailable;

--- How does inventory vary by neighborhood or store location?

select neighborhood, i.StoreId, i.StoreName, p.ProductId, p.ProductName, i.QuantityAvailable
from inventory i
join products p
on i.ProductId = p.ProductId
order by neighborhood, StoreName;


--- Problem Statement: Understand the performance and cost-effectiveness of different products.

--- What are the names and suppliers of the top-selling products?

select s.ProductId, p.ProductName, p.Supplier, sum(s.Quantity) as Quantity_Sold
from sales s
join products p
on s.ProductId = p.ProductId
group by s.ProductId, p.ProductName, p.Supplier
order by Quantity_Sold desc
limit 10;

--- Which products have the highest and lowest unit prices?

select distinct(p.ProductId), p.ProductName, s.UnitPrice
from products p
join sales s
on p.ProductId = s.ProductId
order by s.UnitPrice desc
limit 10; --- top 10 products that has highest unit price

select distinct(p.ProductId), p.ProductName, s.UnitPrice
from products p
join sales s
on p.ProductId = s.ProductId
order by s.UnitPrice
limit 10; --- top 10 products that has lowest unit price

--- How does the cost of products vary across different suppliers?

select Supplier, avg(ProductCost), max(ProductCost), min(ProductCost)
from products p
group by Supplier
order by Supplier;


--- Problem Statement: Analyze sales data to identify trends and make informed decisions.

--- What is the total sales revenue for each product and store?

with revenue as
( select StoreId, ProductId, sum(Quantity*UnitPrice) as total_sales 
  from sales
  group by StoreId, ProductId)

select distinct(r.ProductId), p.ProductName, r.StoreId, i.StoreName, r.total_sales
from revenue r
join inventory i
on r.StoreId = i.StoreId
join products p
on r.ProductId = p.ProductId
order by total_sales desc;

--- Which products have the highest sales quantity?

select p.ProductId, p.ProductName, sum(s.Quantity) sales_quantity
from products p
join sales s
on p.ProductId = s.ProductId
group by p.ProductId, p.ProductName
order by sales_quantity desc
limit 10;

--- What is the average unit price and quantity sold per transaction?

select avg(UnitPrice) as avg_unit_price, avg(Quantity) as avg_quantity  
from sales


--- Problem Statement: Improve inventory turnover to maximize sales and minimize holding costs.

--- Calculate the inventory turnover rate for each product.

select i.ProductId, p.ProductName, avg(s.Quantity) as AverageQuantitySold, avg(i.QuantityAvailable) as AverageQuantityAvailable, avg(s.Quantity) / avg(i.QuantityAvailable) as InventoryTurnoverRate
from inventory i
join products p 
on i.ProductId = p.ProductId
join sales s 
on i.ProductId = s.ProductId
group by i.ProductId, p.ProductName
order by inventory_turnover_rate desc;

--- Identify slow-moving products with low turnover.

select i.ProductId, p.ProductName, avg(s.Quantity) / avg(i.QuantityAvailable) as inventory_turnover_rate
from inventory i
join sales s
on i.ProductId = s.ProductId
join products p
on i.ProductId = p.ProductId
group by i.ProductId, p.ProductName
order by inventory_turnover_rate;

--- Determine the average time it takes for a product to sell out.

with sell_out as 
( select s.ProductId, p.ProductName, min(s.`Date`) as first_sell_date, max(s.`Date`) as last_sell_date 
  from sales s
  join products p
  on s.ProductId = p.ProductId
  group by s.ProductId, p.ProductName)
 
select ProductId, ProductName, datediff(last_sell_date, first_sell_date) as days_sell_out 
from sell_out;


--- Problem Statement: Evaluate the effectiveness of different suppliers.

--- Which suppliers provide the most and least cost-effective products?

select Supplier, avg(ProductCost) as avg_product_cost 
from products p
group by Supplier
order by avg_product_cost desc;

--- What is the total quantity and revenue for products from each supplier?

with revenue_supplier as 
( select p.ProductId, p.ProductName, p.Supplier, sum(s.Quantity) as sell_quantity, sum(s.Quantity*s.UnitPrice) as total_sales
from products p 
join sales s
on p.ProductId = s.ProductId
group by p.ProductId, p.ProductName, p.Supplier )

select Supplier, sell_quantity, total_sales
from revenue_supplier
order by total_sales desc;

--- Identify suppliers with the highest and lowest average unit prices.

select p.Supplier, avg(s.UnitPrice) as avg_unit_price
from products p
join sales s
on p.ProductId = s.ProductId
group by Supplier
order by avg_unit_price desc;


--- Problem Statement: Identify seasonality and trends in sales to plan for future inventory needs.

--- How do sales vary across different months or seasons?

select year(`Date`) as sell_year, month(`Date`) as sell_month, sum(UnitPrice*Quantity) as total_sales
from sales s
group by sell_year, sell_month
order by sell_year, sell_month;

--- Are there specific dates with consistently high or low sales?

select `Date`, sum(UnitPrice*Quantity) as total_sales 
from sales s
group by `Date`
order by total_sales desc;

--- Identify any significant changes in sales trends over time.

--- over the days trends

select `Date`, sum(UnitPrice*Quantity) as total_sales 
from sales s
group by `Date`
order by `Date`;

--- over the years trends

select year(`Date`) as sell_year, sum(UnitPrice*Quantity) as total_sales 
from sales
group by sell_year
order by sell_year;


--- Problem Statement: Evaluate the performance of different stores.

--- What is the total sales revenue for each store?

select i.StoreName, sum(s.UnitPrice*s.Quantity) as total_sales 
from sales s
join inventory i
on s.StoreId = i.StoreId
group by i.StoreName
order by total_sales;

--- Identify stores with the highest and lowest sales.

select i.StoreName, sum(s.UnitPrice*s.Quantity) as total_sales 
from sales s
join inventory i
on s.StoreId = i.StoreId
group by i.StoreName
order by total_sales desc
limit 10; --- highest sales genrated stores

select i.StoreName, sum(s.UnitPrice*s.Quantity) as total_sales 
from sales s
join inventory i
on s.StoreId = i.StoreId
group by i.StoreName
order by total_sales
limit 10; --- lowest sales genrated stores

--- How does inventory availability vary between different stores?

select StoreId, StoreName, avg(QuantityAvailable) as avg_available_quantity 
from inventory
group by StoreId, StoreName
order by avg_available_quantity desc;

