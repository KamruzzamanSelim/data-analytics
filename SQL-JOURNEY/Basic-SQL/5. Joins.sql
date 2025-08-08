select * from employee_demographics
order by gender, age, birth_date;

SELECT *
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id, dem.age, sal.salary, sal.occupation
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ORDER BY age desc;
    
SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
SELECT *
FROM employee_salary AS sal1
RIGHT JOIN employee_salary AS sal2
	ON sal1.employee_id = sal2.employee_id;
    
SELECT *
FROM employee_salary AS sal1
INNER JOIN employee_salary AS sal2
	ON sal1.employee_id = sal2.employee_id
INNER JOIN parks_departments AS par
	ON par.department_id = sal2.dept_id;

SELECT dem.first_name, sal.occupation, sal.salary, par.department_name
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS par
	ON par.department_id = sal.dept_id;
    
SELECT dem.employee_id, dem.first_name, sal.occupation, sal.salary, par.department_name
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS par
	ON par.department_id = sal.dept_id;

