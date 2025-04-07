--netflix project
DROP TABLE IF EXISTS netflix;
create table netflix(
show_id varchar(10),
type varchar(10),	
title varchar(150),
director varchar(250),
casts varchar(1000),
country	varchar(150),
date_added varchar(50),
release_year int,
rating	varchar(10),
duration varchar(15),
listed_in varchar(150),
description varchar(250)
);
select * from netflix;
select count(*) as total_content from netflix;
--q1
select type, count(type) as types from netflix group by type;
--q2
select type,rating from
(select type,rating,count(*),rank() over(partition by type order by count(*) desc) as ranking from netflix group by type,rating)
where ranking=1;
--q3
select * from netflix where type='Movie' and release_year=2020;
--q4
select trim(unnest(string_to_array(country,','))) as new_country,count(show_id) as total_content
from netflix group by new_country order by total_content desc limit 5;
--q5
select title,  substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflix
where type = 'Movie' and duration is not null
order by 2 desc
limit 1
--q6
SELECT *
FROM netflix
WHERE date_added ~ '^\d{1,2}/\d{1,2}/\d{4}'
  AND TO_DATE(date_added, 'FMMM/FMDD/YYYY') >= CURRENT_DATE - INTERVAL '5 years';
--q7
select * from netflix where director like '%Rajiv Chilaka%';
--q8
select * from netflix where type='TV Show' and split_part(duration,' ',1)::int>5;
--q9
select trim(unnest(string_to_array(listed_in,','))) as genre,count(show_id) from
netflix group by genre;
--q10
select release_year, count(*),
count(*)::numeric/(select count(*) from netflix where country='India')::numeric
*100
as average_content from netflix
where country='India'
group by release_year;
--q11
select * from netflix where listed_in ilike '%Documentaries%';
--q12
select * from netflix where director is null;
--q13
select * from netflix where casts ilike '%Salman Khan%' and 
release_year>extract(year from current_date)-10;
--q14
select trim(unnest(string_to_array(casts,','))) as actors,
count(show_id) from netflix where country ilike '%india%'
group by actors order by count(*) desc
limit 10;
--q15
with new_table
as(
select *,
case
   when description ilike '%kill%' or description
   ilike '%violence%' then 'bad_content'
   else 'good_content'
   end category
from netflix)
select category,count(*)
from new_table group by category