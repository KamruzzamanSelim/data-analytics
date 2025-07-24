SELECT first_name
FROM employee_demographics;

SELECT first_name, length(first_name) AS Length
FROM employee_demographics
ORDER BY Length;

SELECT first_name, upper(first_name), lower(first_name)
FROM employee_demographics;

SELECT trim('     Test     ');

SELECT trim(first_name)
FROM employee_demographics;

SELECT trim(first_name)
FROM employee_demographics;

SELECT Ltrim(first_name)
FROM employee_demographics;

SELECT substring(first_name,3,2)
FROM employee_demographics;

SELECT DISTINCT substring(upper(first_name),3,2) AS substrng
FROM employee_demographics
ORDER BY substrng;

SELECT first_name, replace(first_name, 'o', '*')
FROM employee_demographics;

SELECT first_name, locate('a', first_name)
FROM employee_demographics;