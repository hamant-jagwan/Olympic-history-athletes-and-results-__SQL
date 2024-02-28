-----------------------------------------------------------------------------------------
-- crearting olympics_history
-----------------------------------------------------------------------------------------

Drop Table If Exists Olympics_History;
Create Table if not exists Olympics_History 
( id  int ,
 name varchar,
 sex varchar, 
 age varchar,
 height varchar, 
 weight varchar, 
 team varchar, 
 noc varchar,
 games varchar, 
 year int,
 season varchar, 
 city varchar,
 sport varchar, 
 event varchar, 
 medal varchar)
---------------------------------------------------------------------------------------
-- creating Olympics_history_noc_regions
----------------------------------------------------------------------------------------

Drop Table If Exists Olympics_History_NOC_Regions;
Create Table if not exists Olympics_History_NOC_Regions 
( noc varchar,
 regions varchar,
 notes varchar)
-----------------------------------------------------------------------------------------
-- First view of Data 
-----------------------------------------------------------------------------------------
select * from olympics_history;
select * from olympics_history_noc_regions;

-----------------------------------------------------------------------------------------
-- Let start the analysis from the data 
-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
/* 1. How many olypics games have been held?
   Write a SQL query to find the total no of Olympic Games held as per the dataset. */
   
select count(distinct(games)) from olympics_history;

-------------------------------------------------------------------------------------------
/* 2. List down all Olypics games held so far
	Write a SQL query to list down all the Olympic Games held so far */

select  distinct year, season , city from olympics_history
order by year
-------------------------------------------------------------------------------------------
/* 3. Mention the total no. of nations who participated in each olympics games ? 
	SQL query to fetch total no. of countries participated in each olympic games.*/

with all_countries as
        (select games, nr.regions
        from olympics_history oh
        join olympics_history_noc_regions nr ON nr.noc = oh.noc
        group by games, nr.regions)
    select games, count(1) as total_countries
    from all_countries
    group by games
    order by games;

--------------------------------------------------------------------------------------------
/* 4. Which year saw the highest and lowest no. of countries participating in olympics ? 
	Write a SQL query to return the Olympic Games which had the highest participating countries
	and the lowest participating countries */

with 
	all_countries as
	  (select games, nr.regions
	  from olympics_history oh
	  join olympics_history_noc_regions nr ON nr.noc=oh.noc
	  group by games, nr.regions),
	tot_countries as
	  (select games, count(1) as total_countries
	  from all_countries
	  group by games)
select distinct
concat(first_value(games) over(order by total_countries), ' - ', first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
concat(first_value(games) over(order by total_countries desc), ' - ', first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
from tot_countries
order by 1;
---------------------------------------------------------------------------------------------
/* 5. Which nation has participated in all of the olympic games ? 
	SQL query to return the list of countries who have been part of every Olympics games */

with temp1 as
	(select distinct nr.regions , games from olympics_history oh
	join olympics_history_noc_regions nr
	on nr.noc = oh.noc
	order by regions, games)
select regions country, count(games) total_participated_games
from temp1
group by regions
having count(games) = (select count(distinct games) from olympics_history)
---------------------------------------------------------------------------------------------

/* 6. Identify the sport which was played in all summer olympics?
   SQL query to fetch the list of all sports which have been part of every olympics */ 

with 
t1 as 
	(select count(distinct(games)) as total_summer_games
	from olympics_history
	where season = 'Summer'),
t2 as 
	(select distinct sport , games
	from olympics_history
	where season = 'Summer'
	order by games),
t3 as
	(select sport, count(games) as no_of_games
	 from t2
	 group by sport)

select * 
from t3
join t1 on t1.total_summer_games = t3.no_of_games
	
--------------------------------------------------------------------------------------------
/* 7. Which Sports were just played only once in the olympics?
	Using SQL query, Identify the sport which were just played once in all of olympics.*/

with 
temp1 as 
	(select distinct sport ,  games
	from olympics_history
	order by sport),
temp2 as 
	(select sport , count(games) no_of_games
	from temp1
	group by sport 
	having count(games) = 1
	order by sport)

select distinct temp2.sport, no_of_games, oh.games
from temp2
join  olympics_history oh
on oh.sport = temp2.sport
order by sport
------------------------------------------------------------------------------------------
/* 8.Fetch the top 5 athletes who have won the most gold medals ?  
   SQL query to fetch the top 5 athletes who have whon the most gold medals. */

with 
t1 as 
	(select name, team , count(medal) as  total_gold_medals
	from olympics_history
	where medal = 'Gold'
	group by name, team
	order by total_gold_medals desc),
t2 as
	(select *, dense_rank() over(order by total_gold_medals desc)  as rnk
	 from t1)
select name, team, total_gold_medals from t2
where rnk <=5
-------------------------------------------------------------------------------------
/* 9. Fetch oldest athletes to win a gold medal?
	SQL query to fetch the details of the oldest athletes to win a gold medal at the olympics.*/
	
select name, sex, age, team, games, city, sport, event, medal
from olympics_history
where age = (select max(age) from olympics_history where age != 'NA' and medal = 'Gold') and medal = 'Gold'
---------------------------------------------------------------------------------------
/* 10. Find the Ratio of male and female athletes participated in all olympic games?
	Write a SQL query to get the ratio of male and female participants */

with 
temp1 as 
	(select sex, count(1) as cnt 
	from olympics_history 
	group by sex),
temp2 as 
	(select *, row_number() over(order by cnt) as rn
	from temp1),
min_cnt as 
	(select cnt from temp2 where rn = 1),
max_cnt as 
	(select cnt from temp2 where rn = 2)	

select concat('1 :', round(max_cnt.cnt ::decimal/ min_cnt.cnt,2 )) as ratio
from min_cnt, max_cnt
----------------------------------------------------------------------------------------------
/* 11.Fetch the top 5 athletes who have won the most gold medals.
	SQL query to fethch the top 5 athletes who have won the most gold medals.*/
	
with temp1 as 
	(select name ,nr.regions , count(2) total_gold_medals
	from olympics_history oh
	join olympics_history_noc_regions nr
	on nr.noc = oh.noc
	where medal = 'Gold'
	group by name, nr.regions
	order by total_gold_medals desc),
temp2 as 
	(select * , dense_rank() over(order by total_gold_medals desc) rnk
	from temp1)
select name, regions as team, total_gold_medals
from temp2
where rnk <=5

-----------------------------------------------------------------------------------------------
/* 12.Fetch the top 5 athletes who have won the most medals(gold/silver/bronze)?
	SQL Query to fetch the top 5 athletes who have won the most medals (medals include gold,silver and bronze).*/

with 
temp1 as
	(select name, team , count(medal) total_medals 
	from olympics_history 
	where medal != 'NA'
	group by name , team
	order by total_medals desc),
temp2 as
	(select *, dense_rank() over(order by total_medals desc) rnk
	 from temp1)
select name , team, total_medals  
from temp2
where rnk <= 5;
------------------------------------------------------------------------------------------------------
/* 13. Fetch the top 5 most successful countries in olympics. Success is defined by no. of medals won.
	Write a SQL query to fetch the top 5 most successful countries in olympics. (Success is defined by no. of medals won)*/

with 
temp1 as
	(select nr.regions, count(medal) total_medals
	from olympics_history oh
	join olympics_history_noc_regions nr
	on nr.noc = oh.noc
	where oh.medal != 'NA'
	group by nr.regions
	order by total_medals desc),
temp2 as 
	(select *, dense_rank() over(order by total_medals desc) as rnk
	from temp1 )
select regions, total_medals, rnk 
from temp2
where rnk <= 5
------------------------------------------------------------------------------------------------------
/* 14. List down total gold silver and bronze medals won by each country?
	Write a SQL query to list down the total gold silver and bronze medals won by each country */

-- Before running the crosstab query, we need to enable the crosstab function. 
-- The crosstab function is part of the PostgreSQL extension called tablefunc
Create extension tablefunc;

select nr.regions as country , medal, count(medal) as total_medals
from olympics_history oh
join olympics_history_noc_regions nr on nr.noc = oh.noc
where medal != 'NA'
group by nr.regions , medal
order by nr.regions , medal;

select country, 
coalesce(gold, 0) as Gold,
coalesce(silver, 0) as Silver,
coalesce(bronze, 0) as Bronze
from crosstab('select nr.regions as country , medal, count(medal) as total_medals
				from olympics_history oh
				join olympics_history_noc_regions nr on nr.noc = oh.noc
				where medal != ''NA''
				group by nr.regions , medal
				order by nr.regions , medal', 
			  	'values (''Bronze''), (''Gold''), (''Silver'')')
		as result(country varchar, bronze bigint, gold bigint, silver bigint)
order by  Gold desc, Silver desc, Bronze desc

----------------------------------------------------------------------------------------------------
/* 15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games
	Write a SQL query to list down the totla gold, silver and bronze medals won by each country corresponding to each olympic games.*/

select games, nr.regions as country , medal, count(medal) as total_medals 
from olympics_history oh 
join olympics_history_noc_regions nr
on nr.noc = oh.noc
where medal != 'NA'
group by games, nr.regions , medal
order by games, nr.regions, medal;


SELECT substring(games,1,position(' - ' in games) - 1) as games
	, substring(games,position(' - ' in games) + 3) as country
	, coalesce(gold, 0) as gold
	, coalesce(silver, 0) as silver
	, coalesce(bronze, 0) as bronze
FROM CROSSTAB('SELECT concat(games, '' - '', nr.regions) as games
			, medal
			, count(1) as total_medals
			FROM olympics_history oh
			JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
			where medal <> ''NA''
			GROUP BY games,nr.regions,medal
			order BY games,medal',
		'values (''Bronze''), (''Gold''), (''Silver'')')
AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint);

-----------------------------------------------------------------------------------------------------
/* 16. Identify which country won the most gold, most silver and most bronze medals in each olympic games
	write SQL query to display for each Olympic Games, which country won the highest gold, silver and bronze */

with 
temp1 as 
		(select substring(games_country , 1, position('- ' in games_country) - 1) as games, 
		substring(games_country , position('- ' in games_country) +2 ) as country,
		coalesce(gold, 0) as Gold,
		coalesce(silver, 0) as Silver,
		coalesce(bronze, 0) as Bronze
		from crosstab('select concat(games, ''- '', nr.regions) as games_country , medal, count(medal) as total_medals
						from olympics_history oh
						join olympics_history_noc_regions nr on nr.noc = oh.noc
						where medal != ''NA''
						group by games ,nr.regions , medal
						order by games ,nr.regions , medal', 
						'values (''Bronze''), (''Gold''), (''Silver'')')
				as result(games_country varchar, bronze bigint, gold bigint, silver bigint)
		order by  games_country)
select distinct games, 
concat(first_value(country) over(partition by games order by gold desc), ' - ', first_value(gold) over(partition by games order by gold desc) ) as Gold
,concat(first_value(country) over(partition by games order by silver desc), ' - ', first_value(silver) over(partition by games order by silver desc) ) silver
,concat(first_value(country) over(partition by games order by bronze desc), ' - ', first_value(bronze) over(partition by games order by bronze desc) ) bronze
from temp1
order by games
-----------------------------------------------------------------------------------------------------
/* 17. Identify which country won the most gold, most silver, most bronze medals and the most medas in each olympic games.
	Similar to the previous query, identify during each Olympic Games, which country won the highest gold, silver and bronze medals.
	Along with this, identify also the country with the most medals in each olympic games.*/
    with temp as
    	(SELECT substring(games, 1, position(' - ' in games) - 1) as games
    		, substring(games, position(' - ' in games) + 3) as country
    		, coalesce(gold, 0) as gold
    		, coalesce(silver, 0) as silver
    		, coalesce(bronze, 0) as bronze
    	FROM CROSSTAB('SELECT concat(games, '' - '', nr.regions) as games
    					, medal
    					, count(1) as total_medals
    				  FROM olympics_history oh
    				  JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
    				  where medal <> ''NA''
    				  GROUP BY games,nr.regions,medal
    				  order BY games,medal',
                  'values (''Bronze''), (''Gold''), (''Silver'')')
    			   AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint)),
    	tot_medals as
    		(SELECT games, nr.regions as country, count(1) as total_medals
    		FROM olympics_history oh
    		JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
    		where medal <> 'NA'
    		GROUP BY games,nr.regions order BY 1, 2)
    select distinct t.games
    	, concat(first_value(t.country) over(partition by t.games order by gold desc)
    			, ' - '
    			, first_value(t.gold) over(partition by t.games order by gold desc)) as Max_Gold
    	, concat(first_value(t.country) over(partition by t.games order by silver desc)
    			, ' - '
    			, first_value(t.silver) over(partition by t.games order by silver desc)) as Max_Silver
    	, concat(first_value(t.country) over(partition by t.games order by bronze desc)
    			, ' - '
    			, first_value(t.bronze) over(partition by t.games order by bronze desc)) as Max_Bronze
    	, concat(first_value(tm.country) over (partition by tm.games order by total_medals desc nulls last)
    			, ' - '
    			, first_value(tm.total_medals) over(partition by tm.games order by total_medals desc nulls last)) as Max_Medals
    from temp t
    join tot_medals tm on tm.games = t.games and tm.country = t.country
    order by games;




-----------------------------------------------------------------------------------------------------
/* 18.  Which countries have never won gold medal but have won silver/bronze medals?
	Write a SQL Query to fetch details of countries which have won silver or bronze medal but never won a gold medal.*/

with 
temp1 as (SELECT country, coalesce(gold,0) as gold, coalesce(silver,0) as silver, coalesce(bronze,0) as bronze
		FROM CROSSTAB('SELECT nr.regions as country
					, medal, count(1) as total_medals
					FROM OLYMPICS_HISTORY oh
					JOIN OLYMPICS_HISTORY_NOC_REGIONS nr ON nr.noc=oh.noc
					where medal <> ''NA''
					GROUP BY nr.regions ,medal order BY nr.regions,medal',
				'values (''Bronze''), (''Gold''), (''Silver'')')
		AS FINAL_RESULT(country varchar,bronze bigint, gold bigint, silver bigint))
select country, gold,silver, bronze 
from temp1
where gold = 0 and (silver > 0 or bronze > 0)
order by gold desc nulls last, silver desc nulls last, bronze desc nulls last;


	
-----------------------------------------------------------------------------------------------------
/* 19. In which Sport/event, India has won highest medals.
	 Write SQL Query to return the sport which has won India the highest no of medals. */ 

with 
temp1 as (select sport, count(medal) total_medals
		from olympics_history 
		where team = 'India' and medal !='NA'
		group by sport
		order by total_medals desc),
temp2 as (select * , dense_rank() over(order by total_medals desc) rnk
		  from temp1) 
select sport , total_medals 
from temp2
where rnk = 1
-----------------------------------------------------------------------------------------------------
/* 20.  Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
	Write an SQL Query to fetch details of all Olympic Games where India won medal(s) in hockey.*/

select team, sport , games, count(medal) total_medals
from olympics_history
where team = 'India' and sport = 'Hockey' and medal != 'NA'
group by team , sport , games
order by total_medals desc

-----------------------------------------------------------------------------------------------------	

-----------------------------------------------------------------------------------------------------
 -- This data provides a solid foundation for further visualization and in-depth analysis.
 -- THANK YOU
-----------------------------------------------------------------------------------------------------

