CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
age int(10)
);

INSERT INTO temp_table
VALUES('alex', 'benjamin', 80);
INSERT INTO temp_table
VALUES('apex', 'bata', 80);

UPDATE temp_table 
set age = 56
where first_name = 'apex';


SELECT *
FROM temp_table;


SET SQL_SAFE_UPDATES = 0;