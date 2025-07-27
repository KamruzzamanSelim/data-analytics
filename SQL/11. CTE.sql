SELECT *
FROM employee_demographics;

WITH em_dem AS (
SELECT gender, AVG(age), COUNT(age), MAX(AGE), MIN(age)
FROM employee_demographics
GROUP BY gender
)
SELECT *
FROM em_dem;

WITH em_dem AS (
SELECT gender, AVG(age), COUNT(age), MAX(AGE), MIN(age)
FROM employee_demographics
GROUP BY gender
)
SELECT gender, `AVG(age)`
FROM em_dem;

WITH em_dem(gender, avg_age, count_age, max_age, min_age) AS (
SELECT gender, AVG(age), COUNT(age), MAX(AGE), MIN(age)
FROM employee_demographics
GROUP BY gender
)
SELECT gender, avg_age, count_age
FROM em_dem;

WITH em_dem(gender, avg_age, count_age, max_age, min_age) AS (
SELECT gender, AVG(age), COUNT(age), MAX(AGE), MIN(age)
FROM employee_demographics
GROUP BY gender
)
SELECT max(avg_age)
FROM em_dem;