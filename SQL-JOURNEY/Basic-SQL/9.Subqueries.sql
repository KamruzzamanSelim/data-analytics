SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT *
FROM employee_demographics
JOIN employee_salary
WHERE employee_demographics.employee_id = employee_salary.employee_id;

SELECT employee_demographics.first_name, employee_salary.salary, employee_salary.occupation
FROM employee_demographics
JOIN employee_salary
WHERE employee_demographics.employee_id = employee_salary.employee_id
AND employee_salary.dept_id = 1
ORDER BY salary asc;

SELECT *
FROM employee_demographics
WHERE employee_id IN (SELECT employee_id
						FROM employee_salary)
;

SELECT *
FROM employee_demographics
WHERE employee_id IN
(SELECT employee_id
FROM employee_salary
WHERE dept_id = 1)
;


SELECT first_name, salary, (select avg(salary) from employee_salary) as average
from employee_salary
group by first_name, salary;


SELECT first_name, salary, (select avg(salary) from employee_salary) as average
from employee_salary
group by first_name, salary;

SELECT first_name, age, (select avg(age) from employee_demographics) as average
from employee_demographics
group by first_name, age
order by age asc;

SELECT AVG(`AVG(age)`) AS avg_age, AVG(`COUNT(gender)`) AS avg_gender
FROM (SELECT gender, AVG(age), COUNT(gender) FROM employee_demographics
GROUP BY gender) as agg_table;

SELECT gender, AVG(age), COUNT(gender) FROM employee_demographics
GROUP BY gender;
