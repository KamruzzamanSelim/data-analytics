SELECT *
FROM employee_demographics;

SELECT *
FROM parks_departments;

SELECT *
FROM employee_salary;

SELECT 
    first_name,
    age,
    CASE
        WHEN age > 40 THEN 'Old'
        WHEN age <= 40 THEN 'Young'
    END AS aged
FROM
    employee_demographics
ORDER BY age ASC;

SELECT 
    CASE
        WHEN age > 40 THEN 'Old'
        WHEN age <= 40 THEN 'Young'
    END AS aged,
	count(*) as total
FROM
    employee_demographics
group by aged;


SELECT 
    first_name, salary,
    CASE
        WHEN salary > 50000 THEN salary * 1.1
        WHEN salary < 50000 THEN salary * 1.2
        
    END AS increment
FROM
    employee_salary
;



