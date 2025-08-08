SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT dem.first_name, dem.gender, sal.salary
FROM employee_demographics as dem
JOIN employee_salary as sal
WHERE dem.employee_id = sal.employee_id;

SELECT dem.gender, AVG(salary)
FROM employee_demographics as dem
JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id
GROUP BY gender;


SELECT dem.first_name, dem.gender, sal.salary, AVG(salary) OVER(PARTITION BY dem.gender) as avg_salary
FROM employee_demographics as dem
JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id
ORDER BY gender;

SELECT dem.first_name, dem.gender, sal.salary, AVG(sal.salary) OVER(PARTITION BY dem.gender) as avg_salary,
MAX(salary) OVER(PARTITION BY dem.gender) as max_salary
FROM employee_demographics as dem
JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id
ORDER BY gender;

SELECT dem.first_name, dem.gender, sal.salary, SUM(salary) OVER(PARTITION BY dem.gender) AS sum_salary,AVG(salary) OVER(PARTITION BY dem.gender) as avg_salary
FROM employee_demographics as dem
JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id
ORDER BY gender;

SELECT dem.first_name, dem.gender, sal.salary, SUM(salary) OVER(PARTITION BY dem.gender ORDER BY dem.employee_id) AS sum_salary,AVG(salary) OVER(PARTITION BY dem.gender) as avg_salary
FROM employee_demographics as dem
JOIN employee_salary as sal
ON dem.employee_id = sal.employee_id
ORDER BY gender;

SELECT first_name, gender,
ROW_NUMBER() OVER() as row_num
FROM employee_demographics
ORDER BY gender;

SELECT dem.first_name, dem.gender, sal.salary,
ROW_NUMBER() OVER(ORDER BY gender DESC) as row_num
FROM employee_demographics as dem
JOIN employee_salary as	sal
ON dem.employee_id = sal.employee_id
ORDER BY row_num;

SELECT dem.first_name, dem.gender, sal.salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary) as row_num
FROM employee_demographics as dem
JOIN employee_salary as	sal
ON dem.employee_id = sal.employee_id;

SELECT dem.first_name, dem.gender, sal.salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary) as row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary) as rank_num
FROM employee_demographics as dem
JOIN employee_salary as	sal
ON dem.employee_id = sal.employee_id;

SELECT dem.first_name, dem.gender, sal.salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary) as row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary) as rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary) as dense_rank_num
FROM employee_demographics as dem
JOIN employee_salary as	sal
ON dem.employee_id = sal.employee_id;