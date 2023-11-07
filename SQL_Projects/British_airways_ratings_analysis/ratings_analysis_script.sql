select * from britishairways_data;

describe britishairways_data;

-- Set the SQL mode to allow two-digit years
SET sql_mode = 'NO_ZERO_DATE';

-- creating temporary column to convert date_flown in consistant format

alter table britishairways_data 
add column temp_date char(20);

SET SQL_SAFE_UPDATES = 0;

update britishairways_data 
set temp_date = CONCAT('01','-', 
            CASE SUBSTRING(date_flown, 1, 3)
                WHEN 'Jan' THEN '01'
                WHEN 'Feb' THEN '02'
                WHEN 'Mar' THEN '03'
                WHEN 'Apr' THEN '04'
                WHEN 'May' THEN '05'
                WHEN 'Jun' THEN '06'
                WHEN 'Jul' THEN '07'
                WHEN 'Aug' THEN '08'
                WHEN 'Sep' THEN '09'
                WHEN 'Oct' THEN '10'
                WHEN 'Nov' THEN '11'
                WHEN 'Dec' THEN '12'
            END, '-',
        SUBSTRING(date_flown, 5, 2)
    );

alter table britishairways_data 
modify column date_flown date;
   
update britishairways_data 
set date_flown = date_format(str_to_date(temp_date, '%m-%d-%y'), '%y-%d-%m')

alter table britishairways_data
drop column temp_date;

SET SQL_SAFE_UPDATES = 1;


-- EDA

describe britishairways_data;

select count(*) from britishairways_data;


-- What is the average overall rating for all the reviews in the dataset?

select * from britishairways_data bd;
select avg(overall_rating) from britishairways_data bd;


-- Can you provide a breakdown of the distribution of overall ratings (e.g., the number of reviews in each rating category)?

select overall_rating, count(title) num_reviews from britishairways_data bd
group by overall_rating
order by overall_rating;


-- Who are the top authors with the most reviews in the dataset?

select author, count(title) num_reviews from britishairways_data
group by author
order by num_reviews desc
limit 10;


-- Can you identify the most common titles or subjects of the reviews?

select title, count(title) num_title_used from britishairways_data
group by title
order by num_title_used desc
limit 10;


-- Which countries are mentioned the most in the reviews?

select country, count(country) as times_mentioned from britishairways_data
group by country 
order by times_mentioned desc
limit 10;


-- Are there any patterns in overall ratings based on the country of origin?

select country, avg(overall_rating) as avg_ratings from britishairways_data
group by country
order by country asc;

/* we can see that most of the countries have average rating of 4 or greater then 4 */


-- How does overall rating vary over time? Are there any trends or seasonal patterns?

select avg(overall_rating), year(time_published) as year_p, month(time_published) as month_p from britishairways_data
group by year_p, month_p
order by year_p, month_p;

/* we can see that over the years average rating stays consistant like most of the months from each year have average rating between 3 to 6*/



-- Can you identify the most common time periods when reviews are published?

select year(time_published) as year_p,month(time_published) as month_p, count(title) as num_titles_p from britishairways_data
group by year_p, month_p
order by num_titles_p desc
limit 10;

-- What percentage of reviews are marked as "trip verified"?

select count(*) / (select count(*) from britishairways_data) * 100 from britishairways_data
where trip_verified = 'Trip Verified';


-- Do "trip verified" reviews tend to have higher or lower ratings?

select trip_verified, avg(overall_rating) from britishairways_data
group by trip_verified;

/* trip verified have very small difference in its average rating */


-- Is there a correlation between the length of the review body and the overall rating?

select corr(char_length(body), overall_rating) from britishairways_data;



-- Which aircraft types receive the highest and lowest overall ratings on average?

select Aircraft, avg(overall_rating) as avg_rating from britishairways_data
group by Aircraft
order by avg_rating desc;

-- Can you identify patterns in ratings for specific aircraft types?

select Aircraft, avg(overall_rating) avg_rating from britishairways_data
where Aircraft <> '0'
group by Aircraft
order by avg_rating desc;


-- Are there differences in overall ratings between different types of travelers (e.g., business, leisure) and seat types (economy, business, first class)?

select type_of_traveller, seat_type , avg(overall_rating) as avg_rating from britishairways_data
where type_of_traveller <> '0' and seat_type <> '0'
group by type_of_traveller ,seat_type
order by avg_rating desc;


-- Do business travelers tend to give higher ratings than leisure travelers, for example?

select type_of_traveller, avg(overall_rating) from britishairways_data
where type_of_traveller <> '0'
group by type_of_traveller
order by type_of_traveller;

/* business travellers tend to give lower rating compared to other type of travellers like solo leisure tend to give higher average rating */


-- Are there specific routes that consistently receive higher or lower ratings?

select route, avg(overall_rating) as avg_rating from britishairways_data
group by route
order by avg_rating desc;


-- Can you identify the routes with the most reviews in the dataset?

select route, count(*) num_reviews from britishairways_data
group by route
order by num_reviews desc;


-- How do different aspects of the in-flight experience (e.g., seat comfort, cabin staff service, food and beverages) relate to the overall rating?

select overall_rating, avg(seat_comfort), avg(cabin_staff_service), avg(food_and_beverages), avg(ground_service), avg(wifi_and_connectivity), avg(value_for_money) from britishairways_data
group by overall_rating
order by overall_rating;


-- Is there a relationship between ground service, Wi-Fi/connectivity, and overall ratings?

select ground_service, wifi_and_connectivity , avg(overall_rating) as avg_rating from britishairways_data
group by ground_service , wifi_and_connectivity
order by avg_rating desc;

/* their is no positive relation between any variable */

-- Do passengers who rate connectivity poorly tend to give lower overall ratings?

select wifi_and_connectivity, avg(overall_rating) as avg_rating from britishairways_data
where wifi_and_connectivity <> 0
group by wifi_and_connectivity 
order by wifi_and_connectivity;



-- Is there a correlation between the "value for money" rating and the overall rating?

select corr(value_for_money, overall_rating) from britishairways_data;


-- Do reviews mentioning "value for money" positively or negatively correlate with overall ratings?

select case
       when body like '%value for money%' then 'Mentioned'
       else 'Not Mentioned'
       end as value_for_money_mention,
    avg(overall_rating) as average_rating
from britishairways_data
group by value_for_money_mention;



-- What percentage of reviews have a "recommended" status?

select count(*)/(select count(*) from britishairways_data) * 100 from britishairways_data
where recommended = 'yes';


-- Do reviews marked as "recommended" have higher overall ratings on average?

select recommended, avg(overall_rating) as avg_rating from britishairways_data
group by recommended;


-- Are there specific takeoff and destination locations that are mentioned more frequently in reviews?

select takeoff, destination, count(*) as num_reviews from britishairways_data
group by takeoff , destination
having num_reviews > 1
order by num_reviews desc;


