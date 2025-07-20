select occupation, salary
from employee_salary
where salary > 50000;

select occupation, salary
from employee_salary
where occupation like '%manager%'
having salary > 50000;

select occupation, salary
from employee_salary
where occupation like '%manager%'
having salary > 50000;