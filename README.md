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
### Olympic history (Table- 1)
    ID - Unique number for each athlete
    Name - Athlete's name
    Sex - M or F
    Age - Integer
    Height - In centimeters
    Weight - In kilograms
    Team - Team name
    NOC - National Olympic Committee 3-letter code
    Games - Year and season
    Year - Integer
    Season - Summer or Winter
    City - Host city
    Sport - Sport
    Event - Event
    Medal - Gold, Silver, Bronze, or NA
### Olympic_history (Table- 2)
    NOC - National Olympic Committee 3-letter code
    region - Country name (matches with regions)
    Notes
## Tool and Concept 
**Tool** - *PostgreSQL*

**Concept** - Joins, Subquery, Common Table Expressions (CTE), Window Functions, Pivot Tables (CrossTab)

## Analysis Question
