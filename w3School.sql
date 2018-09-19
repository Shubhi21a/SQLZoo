# Selected commands from W3 School

# 1. TOP
# The following SQL statement selects the first three records from the "Customers" table:
SELECT TOP 3 * FROM Customers;

# 2. NULL
/* It is very important to understand that a NULL value is different from a zero value or a field that contains spaces.
A field with a NULL value is one that has been left blank during record creation!

It is not possible to test for NULL values with comparison operators, such as =, <, or <>.
We will have to use the IS NULL and IS NOT NULL operators instead */

SELECT LastName, FirstName, Address FROM Persons
WHERE Address IS NULL;
# Tip: Always use IS NULL to look for NULL values.

# 3. IS NOT NULL
# The following SQL statement uses the IS NOT NULL operator to list all persons that do have an address:

SELECT LastName, FirstName, Address FROM Persons
WHERE Address IS NOT NULL;

# SQL ZOO : Multiple SELECTs: SELECT within SELECT
# Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name FROM world WHERE continent='Europe' AND GDP/population> (SELECT GDP/population FROM world WHERE name='United Kingdom')
