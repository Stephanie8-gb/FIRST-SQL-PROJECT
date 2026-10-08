SELECT first_name,
last_name,
birth_date,
gender,
age,
(age + 10) * 10
FROM employee_demographics;

-- WHERE Clause
SELECT*
FROM employee_demographics
WHERE gender != 'FEMALE'
;

-- AND OR NOT  -- LOGICAL OPERATORS
SELECT*
FROM employee_demographics
WHERE (first_name = 'April' AND age = 44) OR age > 40
;

-- LIKE STATEMENTS
-- % and _
SELECT*
FROM employee_demographics
WHERE first_name LIKE '%A%'
;

-- GROUP BY
SELECT gender,
avg(age),
max(age),
min(age),
count(age)
FROM employee_demographics
GROUP BY gender
;

-- ORDER BY
SELECT*
FROM employee_demographics
ORDER BY first_name asc,
gender,age
;

-- HAVING VS WHERE
SELECT occupation,avg
(salary)
FROM employee_salary
WHERE occupation LIKE '%Manager%'
GROUP BY occupation
HAVING avg(salary)>7000
;

-- LIMIT AND ALIASING
SELECT*
FROM employee_demographics
ORDER BY age DeSC
LIMIT 3,1
;

-- ALIASING
SELECT gender,
avg(age) avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40
;


-- JOINS
SELECT *
FROM employee_demographics emp_dem
INNER JOIN employee_salary emp_sal
	ON emp_dem.employee_id = emp_sal.employee_id
    ;


-- OUTER JOINS
SELECT *
FROM employee_demographics emp_dem
RIGHT JOIN employee_salary emp_sal
	ON emp_dem.employee_id = emp_sal.employee_id
    ;

-- SELF JOIN
SELECT emp1.employee_id emp_santa,
emp1.first_name first_name_santa,
emp1.last_name last_name_santa,
emp2.employee_id emp_name,
emp2.first_name first_name_emp,
emp2.last_name last_name_emp
FROM employee_salary emp1
RIGHT JOIN employee_salary emp2
	ON emp2.employee_id = emp2.employee_id
    ;

-- JOINING MULTIPLE TABLES
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments PD
    ON sal.dept_id = PD.department_id
    ;


-- UNIONS
SELECT first_name,
last_name, 'OLD m' Label
FROM employee_demographics
WHERE age > 40 AND gender = 'male'
UNION
SELECT first_name,
last_name, 'OLD l' Label
FROM employee_demographics
WHERE age > 40 AND gender ='female'
UNION
SELECT first_name,
last_name, 'Highly paid employee' Label
FROM employee_salary
WHERE salary > 7000
UNION
SELECT first_name,
last_name, 'YOUNG M' Label
FROM employee_demographics
WHERE age < 40 AND gender ='male'
UNION
SELECT first_name,
last_name, 'YOUNG L' Label
FROM employee_demographics
WHERE age < 40 AND gender ='female'
ORDER BY first_name,
last_name
;

-- STRING FUNCTIONS
SELECT first_name,
LENGTH(first_name),
LEFT (first_name,4),
RIGHT (first_name,4),
birth_date,
SUBSTRING(birth_date, 6,2) birth_month
FROM employee_demographics
ORDER BY 2
;

-- REPLACE
SELECT first_name,
REPLACE(first_name, 'a','s')
FROM employee_demographics
;

-- LOCATE
SELECT first_name,
LOCATE('AN',first_name)
FROM employee_demographics
;

-- CONCAT
SELECT first_name,
last_name,
CONCAT(first_name, '  ' ,last_name) full_name
FROM employee_demographics
;

-- CASE STATEMENTS
SELECT first_name,
last_name,
age,
CASE
  WHEN age >= 50 THEN  "On death's door"
  WHEN age <= 30 THEN 'young'
  WHEN age BETWEEN 31 and 50 THEN 'old'
END Age_bracket
FROM employee_demographics
;
-- PAY INCREASE AND BONUS
-- <50000 = 5%
-- > 50000 = 7%
-- Financial dept =10%
SELECT first_name,
last_name,
salary,
case
when salary < 50000 then salary * 0.05
when salary > 50000 then salary * 0.07
end as New_salary,
case
when dept_id = 6 then salary * 0.10
end as bonus
from employee_salary;

-- SUBQUERIES 1
select *
from employee_demographics
where employee_id in 
(select employee_id
from employee_salary
where dept_id = 1)
;

-- SUBQUERIES 2
select first_name,
salary,
(select avg (salary)
from employee_salary) average_salary
from employee_salary;

-- SUBQUERIES 3
select gender,
avg(max_age)
from
(select gender,
avg(age) avg_age,
max(age) max_age,
min(age) min_age,
count(age)
from employee_demographics
group by gender) agg_table
group by gender
;

-- WINDOWS FUNCTIONS 1
select dem.first_name,
dem.last_name,
gender,
sum(salary) over (partition by gender order by dem.employee_id) rolling_total
from employee_demographics dem
join employee_salary sal
 on dem.employee_id = sal.employee_id
;

-- WINDOWS FUNCTIONS 2
select dem.employee_id,
dem.first_name,
dem.last_name,
gender,
salary,
row_number() over(partition by gender order by salary desc) as row_num,
rank() over(partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) as dense_rank_num
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
;

-- CTE 1

with CTE_Example AS
(
select gender,
avg(salary) avg_sal,
max(salary) max_sal,
min(salary) min_sal,
count(salary) count_sal
from employee_demographics dem
join employee_salary sal
on dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal)
from CTE_example
;


-- CTE 2
with CTE_Example AS
(
select employee_id,
gender,
birth_date
from employee_demographics dem
WHERE birth_date < '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id,
salary
FROM employee_salary
WHERE salary > 50000
)
SELECT*
from CTE_Example
JOIN CTE_Example2
   ON CTE_Example.employee_id = CTE_Example2.employee_id
;


-- TEMPORARY TABLES1
CREATE TEMPORARY TABLE temp_table
(first_name varchar (50),
last_name varchar (50),
favorite_movie varchar (100)
);

SELECT*
FROM temp_table;

INSERT INTO  temp_table
VALUES('Alex','freberg','lord of the rings')
;

-- TEMPORARY TABLES2
SELECT*
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_60k
SELECT*
FROM employee_salary
WHERE salary <= 60000;

SELECT*
FROM salary_over_60k;

-- STORED PROCEDURES
SELECT*
FROM employee_salary
WHERE salary >= 50000
;

CREATE PROCEDURE large_salaries()
SELECT*
FROM employee_salary
WHERE salary >= 50000
;
CALL large_salaries();

-- STORED PROCEDURES2

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
  SELECT*
  FROM employee_salary
  WHERE salary >= 50000
  ;
  SELECT*
  FROM employee_salary
  WHERE salary >= 10000
  ; 
END $$
DELIMITER ;

CALL large_salaries2();


-- PARAMETER
DELIMITER $$
CREATE PROCEDURE large_salaries4(employe_id INT)
BEGIN
  SELECT salary
  FROM employee_salary
  WHERE employee_id = employee_id
  ;
END $$
DELIMITER ;

CALL large_salaries4(1);

-- TRIGGER AND EVENTS
DELIMITER $$
CREATE TRIGGER employee_insert
     AFTER INSERT ON employee_salary
     FOR EACH ROW
BEGIN
     INSERT INTO employee_demographics (employee_id, first_name, last_name)
     VALUES(NEW.employee_id, NEW.first_name, NEW.last_name);
END$$     
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Stephanie' , 'Aliyu' ,'Entertainment 720 CEO', 100000 , NULL)
;

SELECT*
FROM employee_salary;

SELECT*
FROM employee_demographics;

-- EVENTS
DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%'





























































