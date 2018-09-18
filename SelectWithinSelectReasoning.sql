# 1.
# List each country name where the population is larger than that of 'Russia'.

SELECT name FROM world
  WHERE population > (SELECT population FROM world WHERE name='Russia')

# This requires for us to - SELECT name FROM world WHERE population > (Russia's Population)
# To select Russia's Population, we say- (SELECT population FROM world WHERE name='Russia')
# Now, we plug this in, to get our complete query, which results in:

SELECT name FROM world
  WHERE population > (SELECT population FROM world WHERE name='Russia')
      
# 2.
# Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name FROM world 
  WHERE continent='Europe' AND GDP/population > (SELECT GDP/population FROM world WHERE name='United Kingdom')

# 3.
# List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

#Correct:
SELECT name, continent FROM world
  WHERE continent IN (SELECT continent FROM world WHERE name='Argentina' OR name= 'Australia') ORDER BY name

# Correct:
SELECT name, continent FROM world 
  WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina','Australia')) ORDER BY name

# Incorrect: ( '=' does not work)
SELECT name, continent FROM world 
WHERE continent = (SELECT continent FROM world WHERE name='Argentina' OR name= 'Australia') ORDER BY name


# 4. 
# Which country has a population that is more than Canada but less than Poland? Show the name and the population.

# Reasoning- We SELECT name from world WHERE
# population > (Canada's population) 
# AND population < (Poland's population)

SELECT name, population FROM world
  WHERE population > (SELECT population FROM world WHERE name='Canada') 
    AND population < (SELECT population FROM world WHERE name='Poland')

# 5. 
# Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

# Correct:

SELECT name,CONCAT(ROUND(population/(SELECT population FROM world WHERE name='Germany')*100,0),'%') 
  FROM world WHERE continent='Europe' 

# Reasoning: Basic- SELECT name, (population/(Germany's Population))*100 FROM world WHERE continent='Europe'

# Honing Reasoning: # SELECT name, ROUND(population/(Germany's Population)*100,0) FROM world WHERE continent='Europe'
# (To round off with no decimal place)
# Honing Reasoning: SELECT name, CONCAT(ROUND(population/(Germany's Population)*100,0),%) FROM world WHERE continent='Europe'   
# (To add % sign)

# (Germany's Population): (SELECT population FROM world WHERE name='Germany')

# Plugging it to get the query: 
SELECT name, CONCAT(ROUND(population/(SELECT population FROM world WHERE name='Germany')*100,0),%)
  FROM world WHERE continent='Europe'  

# 6. 
# Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)

# Correct 1:
SELECT name FROM world WHERE GDP> (SELECT MAX(GDP) FROM world WHERE GDP IS NOT NULL AND continent='Europe')

# Correct 2:
SELECT name FROM world WHERE GDP> ALL(SELECT GDP FROM world WHERE GDP IS NOT NULL AND continent='Europe')

# Correct 1:  Basic reasoning: SELECT GDP FROM world WHERE GDP> (Max GDP of European Countries)

# GDP of Europen countries- SELECT GDP FROM world WHERE continent='Europe'
Max GDP of European countries- (SELECT MAX(GDP) FROM world WHERE continent='Europe')
# To select values that are not NULL, we use IS NOT NULL
Max GDP of European countries- (SELECT MAX(GDP) FROM world WHERE GDP IS NOT NULL AND continent='Europe')
# This gives us Germany, we now want countries with GDP> GDP of Germany (European country with highest GDP)

# Plugging it, we get:
SELECT name FROM world WHERE GDP> (SELECT MAX(GDP) FROM world WHERE GDP IS NOT NULL AND continent='Europe')

# Correct 2: We can use the word ALL to allow >= or > or < or <=to act over a list. 
# Basic Reasoning: ALL can be used to compare with ALL values in a list. It will compare with each value in list individually 
# it therefore, can help in getting the max/min value

# Reasoining: SELECT name FROM world WHERE GDP> ALL( European countries' GDP)
# (European countries' GDP): SELECT GDP FROM world WHERE continent='Europe'
# Taking Non-NULL values:   SELECT GDP FROM world WHERE GDP IS NOT NULL AND continent='Europe' 

# Plugging it:
SELECT name FROM world WHERE GDP> ALL(SELECT GDP FROM world WHERE GDP IS NOT NULL AND continent='Europe')

# Note: Since we don't want to include Germany in this list, make sure that the condition says > and not >=
# The answer we get is: China, Japan, United States

# 7.
# Find the largest country (by area) in each continent, show the continent, the name and the area:

# Correct answer 1:
SELECT continent, name, area FROM world WHERE area in (SELECT MAX(area) FROM world GROUP BY continent)

# Correct answer: 2

SELECT continent, name, area FROM world w1
  WHERE area >=
    (SELECT max(area) FROM world w2
        WHERE w2.continent=w1.continent
          AND area>0) 


#Correct answer 3:
SELECT continent, name, area FROM world w1
  WHERE area >= ALL
    (SELECT area FROM world w2
        WHERE w2.continent=w1.continent
          AND area>0) 


Correct 1:
SELECT continent,name,area FROM world WHERE area in (SELECT MAX(area) FROM world GROUP BY continent)

#Basic reasoning: SELECT continent, name, area FROM world (for country with max area, for each continent)
# Honing: SELECT continent, name, area FROM world WHERE area in (max area country in each continent)
# Country with max area, for each continent: (SELECT max(area) FROM world GROUP BY continent)
# Plugging it to get the final query.

Incorrect: SELECT name, continent, area FROM world WHERE name IN (SELECT MAX(area) FROM world GROUP BY continent)
# When we are selecting on basis of max(area), we should also be saying- WHERE area IN... and not- name IN

# This doesn't yeild anything: SELECT name, continent,MAX(area) FROM world GROUP BY continent
# it works when we say:SELECT continent,MAX(area) FROM world GROUP BY continent

# For correct 2 and 3: ( Couldn't work out the reassoning myself, though was able to modify the given e.g. to get the answer)

SELECT continent, name, area FROM world w1
  WHERE area >= ALL
    (SELECT area FROM world w2
        WHERE w2.continent=w1.continent
          AND area>0) 
          
 # The first alias we give to the world table is w1, and the other alias is w2

# The example is known as a correlated or synchronized sub-query.

/* The technique relies on table aliases to identify two different uses of the same table,
one in the outer query and the other in the subquery.
One way to interpret the line in the WHERE clause that references the two table is 
“… where the correlated values are the same”.

We say “select the country details from world where the area is greater than or equal to
the area of all countries where the continent is the same” */


# 8.
# List each continent and the name of the country that comes first alphabetically.

# Correct: SELECT continent, min(name) FROM world GROUP BY continent

# Incorrect: SELECT continent, name FROM world 
#  WHERE name IN (SELECT name FROM world LIMIT 1 ORDER BY name GROUP BY continent )



# Attempt for ques9 : Incorrect:
/* SELECT name, continent, population FROM world
WHERE continent IN (SELECT continent FROM world WHERE MAX(population)<= 25000000 GROUP BY continent) */



