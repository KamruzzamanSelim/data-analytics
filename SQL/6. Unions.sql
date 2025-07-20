SELECT * FROM employee_demographics;

SELECT * FROM employee_salary;


SELECT first_name FROM employee_demographics
UNION
SELECT first_name FROM employee_salary;

SELECT first_name, last_name FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name FROM employee_salary;

SELECT first_name, last_name FROM employee_demographics
UNION ALL
SELECT first_name, last_name FROM employee_salary;

SELECT first_name, 'Old' AS label
FROM employee_demographics
WHERE age > 50;

SELECT first_name, last_name, 'Old' AS label
FROM employee_demographics
WHERE age > 40
UNION
SELECT first_name, last_name, salary FROM employee_salary
WHERE salary > 70000;

SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age > 50 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old lady' AS label 
FROM employee_demographics
WHERE age > 50 AND gender = 'Female'
UNION 
SELECT first_name, last_name, 'Highly paid' AS label FROM employee_salary
WHERE salary > 70000;