# Olympic-history-athletes-and-results-__SQL
<p align="center"> 
<img src="https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjEx…9naWZfYnlfaWQmY3Q9Zw/nKrLA723kcA3dSThqA/giphy.gif"  width="500" height="350" alt="GIF">
</p>

## Introduction
This dataset provides a comprehensive look at the modern Olympic Games, spanning from Athens 1896 to Rio 2016. It includes detailed information about the events, athletes, and countries participating in each edition of the Games. The data was scraped from www.sports-reference.com in May 2018.

The data was scraped using R code, which is available in the repository under scraping_code/R_scraping_script.R. The scraping process involved gathering information from the website and wrangling it into a structured format suitable for analysis.

#### Important Note
It's essential to note that the Winter and Summer Games were held in the same year until 1992. After 1992, they were staggered, with the Winter Games occurring on a four-year cycle starting in 1994, followed by the Summer Games in 1996, and so on. This distinction is crucial for accurate analysis of the data.

## Dataset 
### Dataset link - Kaggle
https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results

### Olympic history (Table- 1)
    ID -     Unique number for each athlete
    Name -   Athlete's name
    Sex -    M or F
    Age -    Integer
    Height - In centimeters
    Weight - In kilograms
    Team -   Team name
    NOC -    National Olympic Committee 3-letter code
    Games -  Year and season
    Year -   Integer
    Season - Summer or Winter
    City -   Host city
    Sport -  Sport
    Event -  Event
    Medal -  Gold, Silver, Bronze, or NA
### Olympic_history_noc_regions (Table- 2)
    NOC   -  National Olympic Committee 3-letter code
    region - Country name (matches with regions)
    Notes
## ERD For Database
![Screenshot 2024-02-26 170739](https://github.com/hamant-jagwan/Olympic_history_athletes_and_results--SQL/assets/117731315/36eb9702-9a0e-4ba1-88d6-0f13e850bc97)

## Tool and Concept 
**Tool** - ***PostgreSQL***

![PostgreSQL600x340](https://github.com/hamant-jagwan/Olympic_history_athletes_and_results--SQL/assets/117731315/308cd0da-cf40-45af-a2bb-db0ebe01b70d) 


***Concept*** - 1. **Joins**  2. **Subquery**  3. **Common Table Expressions (CTE)**  4.**Window Functions**  5. **Pivot Tables (CrossTab)**

## Analysis Questions
1.  How many olympics games have been held?
2.  List down all Olympics games held so far.
3.  Mention the total no of nations who participated in each olympics game?
4.  Which year saw the highest and lowest no of countries participating in olympics?
5.  Which nation has participated in all of the olympic games?
6.  Identify the sport which was played in all summer olympics.
7.  Which Sports were just played only once in the olympics?
8.  Fetch the total no of sports played in each olympic games.
9.  Fetch details of the oldest athletes to win a gold medal.
10. Find the Ratio of male and female athletes participated in all olympic games.
11. Fetch the top 5 athletes who have won the most gold medals.
12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
14. List down total gold, silver and broze medals won by each country.
15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.
16. Identify which country won the most gold, most silver and most bronze medals in each olympic games.
17. Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
18. Which countries have never won gold medal but have won silver/bronze medals?
19. In which Sport/event, India has won highest medals.
20. Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.

## Conclusion
 the comprehensive analysis of Olympic history data offers valuable insights into the evolution and dynamics of the games over time. 
 With a focus on participation trends, sport popularity, individual achievements, and country performances, this data provides a solid foundation for further visualization and in-depth analysis.
