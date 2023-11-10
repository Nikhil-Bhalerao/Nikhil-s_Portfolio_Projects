select * from retail_transactions rt;
describe retail_transactions;

-- converting Discount Applied columns values to boolean

alter table retail_transactions
modify column Discount_Applied bool;

-- 1 = TRUE and 0 = FALSE in Discount_Applied column

-- EDA
-- check data type of each column
describe retail_transactions;

-- total number of data rows
select count(*) from retail_transactions;


-- Retrieve the total sales, the number of transactions, and the average transaction cost for the entire dataset.

select round(sum(Total_Cost), 2) as total_sales, count(Transaction_ID) as count_of_transactions, round(avg(Total_Cost), 2) as avg_trans_cost
from retail_transactions rt;


-- Calculate monthly sales totals over the entire period covered by the dataset. Identify any noticeable trends or patterns.

select year(`Date`) as year_trans, month(`Date`) as month_trans, round(sum(Total_Cost), 2) as total_sales from retail_transactions rt
group by year_trans, month_trans
order by year_trans, month_trans;


-- Identify the top-selling products based on the total quantity sold. Include the product name, total items sold, and total revenue generated.

select trim(substring_index(Product, ',', -1)) as products, sum(Total_Items) as quantity, sum(Total_Cost) as sales 
from retail_transactions
group by products
order by quantity desc;


-- Provide a breakdown of the payment methods used by customers. Include the count and percentage of transactions for each payment method.

select Payment_Method, count(Payment_Method) as times_used, count(Payment_Method)/(select count(Payment_Method) from retail_transactions)*100 as percentage_of_use
from retail_transactions
group by Payment_Method
order by times_used desc;

-- Analyze the sales performance of different store types. Calculate total revenue, average transaction cost, and the number of transactions for each store type.

select Store_Type, round(sum(Total_Cost), 2) as total_revenue, round(avg(Total_Cost), 2) as avg_trans_cost, count(*) as number_of_trans from retail_transactions
group by Store_Type
order by total_revenue desc;

-- Assess the impact of discounts on total revenue. Compare sales with and without discounts, and calculate the percentage increase or decrease.

select Discount_Applied, round(sum(Total_Cost), 2) as total_sales, sum(Total_Cost)/(select sum(Total_Cost) from retail_transactions)*100 as percentage
from retail_transactions
group by Discount_Applied;

-- Group customers by category and analyze their purchasing behavior. Calculate the average transaction cost for each customer category.

select Customer_Category, round(avg(Total_Cost), 2) as avg_cost from retail_transactions
group by Customer_Category
order by avg_cost desc;

-- Examine the seasonal variation in sales. Calculate total sales, average transaction cost, and the number of transactions for each season.

select Season, round(sum(Total_Cost), 2) as total_sales, round(avg(Total_Cost), 2) as avg_trans_cost, count(*) as total_trans
from retail_transactions
group by Season
order by total_sales desc;

-- Evaluate the effectiveness of promotions on sales. Calculate the percentage increase in sales during promotional periods compared to non-promotional periods.

select Promotion, sum(Total_Cost) as total_sales, sum(Total_Cost)/(select sum(Total_Cost) from retail_transactions)*100 as percentage
from retail_transactions
group by Promotion
order by total_sales desc;


-- Compare total sales and average transaction cost across different cities. Identify cities with the highest and lowest sales.

select City, sum(Total_Cost) as total_sales, avg(Total_Cost) as avg_trans_cost from retail_transactions
group by City
order by total_sales desc;

-- Retrieve the transaction history for a specific customer, including Transaction_ID, Date, Product, Total_Items, Total_Cost, and Payment_Method.

select Customer_Name, Transaction_ID, `Date`, Product, Total_Items, Total_Cost, Payment_Method from retail_transactions
where Customer_Name  = 'Alexander Hall';

-- List transactions where discounts were applied, including Transaction_ID, Date, Product, Total_Items, Total_Cost, Discount_Applied, and Customer_Name.

select Transaction_ID, Customer_Name, `Date`, Product, Total_Items, Total_Cost, Discount_Applied from retail_transactions
where Discount_Applied = 1;

-- Identify high-value customers based on their total spending. List customers with total spending above a certain threshold.

select Customer_Name, sum(Total_Cost) as total_spendings from retail_transactions
group by Customer_Name
having total_spendings >= 300
order by total_spendings desc;


-- Identify and analyze any outliers in the dataset. Determine if there are any unusual patterns or transactions that require investigation.

select min(Total_Cost) from retail_transactions;

select max(Total_Cost) from retail_transactions;

select min(Total_Items) from retail_transactions 

select max(Total_Items) from retail_transactions;


