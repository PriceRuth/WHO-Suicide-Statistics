Create schema WHO_Suicide_Stats;
Use WHO_Suicide_Stats;
select * from suicide_stat;

-- Creating new table
Create Table suicide_stat 
( 
country varchar(50), 
year_happened varchar(50),
sex varchar(50),
age varchar(50),
suicide_no int,
population int
);


-- load the file into the table created
Load Data Infile 'C:/who_suicide_statistics.csv' into Table suicide_stat
Fields Terminated by ','
Ignore 1 lines;

SET sql_mode = "";

select @@secure_file_priv;

select * from suicide_stat;

-- Identify the total number of suicide for each country of a certain year
select country, sum(suicide_no) total
from suicide_stat
where year_happened = 2016
group by country
order by total desc;

-- This is to know what country has the highest number of suicide in young people
select country, sum(suicide_no) total, sum(population) population
from suicide_stat
where age = '15-24 years' and year_happened < 2000
group by country
order by total desc;

-- This is to know what countries have the highest suicides per 100,000 for age 15-24
select country, sum(suicide_no) total, sum(population) population, sum(suicide_no)/sum(population) * 100 as percentage, round(sum(suicide_no)/sum(population) * 100 * 100000) as suicides_per_100k
from suicide_stat
where age = '15-24 years' and year_happened < 2000
group by country
order by percentage desc;

-- I'd like to make a stored procedure that will tell me the countries which have the highest suicide rates according to age and year from 2000 up to 2016.
Drop Procedure highest_suicide_rates;
DELIMITER $
Create Procedure highest_suicide_rates(in selected_age varchar(50), in selected_year varchar(50))
BEGIN
	select country, selected_age, sum(suicide_no) total, sum(population) population, sum(suicide_no)/sum(population) * 100 as percentage, round(sum(suicide_no)/sum(population) * 100 * 100000) as suicides_per_100k
	from suicide_stat
	where age = selected_age and year_happened = selected_year
	group by country
	order by percentage desc;
END $
DELIMITER ;

Call highest_suicide_rates('15-24 years', 2010);
Call highest_suicide_rates('15-24 years', 2011);

select * from suicide_stat;

-- Suicide Rate through the years among young people
select year_happened, sum(suicide_no) total, sum(population) population, sum(suicide_no)/sum(population) * 100 as percentage, round(sum(suicide_no)/sum(population) * 100 * 100000) as suicides_per_100k
	from suicide_stat
	where age = '15-24 years'
	group by year_happened
	order by suicides_per_100k desc;

-- Which country has the highest suicide rates among women
select country, sum(suicide_no) total
from suicide_stat
where sex = 'female'
group by country
order by total desc;


-- Which country has the highest suicide rates among men
select country, sum(suicide_no) total
from suicide_stat
where sex = 'male'
group by country
order by total desc;
