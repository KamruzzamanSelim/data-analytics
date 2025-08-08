select * from employee_demographics;

select * from employee_salary;

select * from parks_departments;

select * from employee_demographics
where gender = 'female';

select * from employee_demographics
where gender = 'male';

select employee_id, last_name salary, department_name from employee_salary
join parks_departments
where employee_salary.dept_id = parks_departments.department_id;

select * from employee_salary
join parks_departments
where employee_salary.dept_id = parks_departments.department_id;

SELECT first_name,
last_name,
age,
age + 10
FROM employee_demographics;

SELECT DISTINCT gender
FROM employee_demographics;

SELECT *
FROM employee_demographics;

SELECT DISTINCT gender,
first_name
FROM employee_demographics
order by gender;

SELECT gender,
first_name
FROM employee_demographics
group by gender, first_name;

SELECT gender,
count(gender)
FROM employee_demographics
group by gender
order by count(gender) desc;

SELECT first_name, age
FROM employee_demographics
order by first_name asc;

SELECT gender, avg(age)
FROM employee_demographics
group by gender;

SELECT occupation, salary
FROM employee_salary
group by occupation,salary
order by occupation asc;