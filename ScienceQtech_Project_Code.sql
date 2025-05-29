-- 1.	Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee 
-- database from the given resources.
create database employee
use employee
-- 2. Create an ER diagram for the given employee database.
 

-- 3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of 
-- employees and details of their department.
select * from emp_record_table
select count(EMP_ID) from emp_record_table;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER,  DEPT from emp_record_table ORDER BY DEPT;

-- 4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
-- less than two
-- greater than four 
-- between two and four
select count(*) from emp_record_table
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table where EMP_RATING < 2;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table where EMP_RATING > 4;
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table where EMP_RATING between 2 AND 4 order by EMP_RATING;

-- 5.Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and 
-- then give the resultant column alias as NAME.

select * from emp_record_table
select * from data_science_team
select * from proj_table

SELECT EMP_ID,DEPT, CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME FROM emp_record_table WHERE DEPT = 'FINANCE';

-- 6.	Write a query to list only those employees who have someone reporting to them. Also, show the number of 
-- reporters (including the President).
select count(MANAGER_ID) from emp_record_table

SELECT E.EMP_ID,E.FIRST_NAME,E.LAST_NAME,E.ROLE, COUNT(R.EMP_ID) AS NO_OF_REPORTER FROM emp_record_table AS E JOIN emp_record_table AS R 
ON E.EMP_ID = R.MANAGER_ID 
GROUP BY E.EMP_ID, E.FIRST_NAME, E.LAST_NAME, E.ROLE
HAVING COUNT(R.EMP_ID) > 0
ORDER BY NO_OF_REPORTER DESC;

-- 7.	Write a query to list down all the employees from the healthcare and finance departments using union. Take data from 
-- the employee record table.


SELECT EMP_ID, DEPT FROM emp_record_table
WHERE DEPT='HEALTHCARE'
UNION
SELECT EMP_ID, DEPT FROM emp_record_table
WHERE DEPT='FINANCE'
ORDER BY DEPT;

-- 8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING 
-- grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
select * from emp_record_table 

SELECT E.EMP_ID, E.FIRST_NAME, E.LAST_NAME, E.ROLE, E.DEPT, E.EMP_RATING, D.MAX_RATING
FROM emp_record_table E
JOIN 
    ( SELECT DEPT, MAX(EMP_RATING) AS MAX_RATING FROM emp_record_table GROUP BY DEPT ) 
D ON E.DEPT = D.DEPT
ORDER BY 
E.DEPT, E.EMP_RATING DESC; 

--  9. AWrite a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY FROM  emp_record_table
GROUP BY ROLE
ORDER BY ROLE;

 -- 10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP,
    DENSE_RANK() OVER (ORDER BY EXP DESC) AS EXP_RANK
	FROM emp_record_table
	ORDER BY EXP_RANK;

-- 11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand.
-- Take data from the employee record table.

create view Salarly_Greter_than_6k as
select EMP_ID,FIRST_NAME,LAST_NAME,country,role,dept, salary from emp_record_table where salary > 6000 order by country;

select * from Salarly_Greter_than_6k;

-- 12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

select EMP_ID,FIRST_NAME,LAST_NAME,country,role,dept, exp from emp_record_table where  exp > any
 (select exp from emp_record_table where exp > 10) order by exp asc;

-- 13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years.
-- Take data from the employee record table.

delimiter //
 create procedure expmorethan3 ()
 begin
 select EMP_ID,FIRST_NAME,LAST_NAME,country,role,dept, exp from emp_record_table where  exp > 3 order by exp asc;
 end //

call expmorethan3()

-- 14.	Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the 
-- data science team matches the organization’s set standard.
select * from data_science_team

DELIMITER //

Create FUNCTION Get_standard_job(exp_year int)
RETURNS VARCHAR(50)
DETERMINISTIC

BEGIN
	 RETURN CASE
		WHEN exp_year <= 2 then 'JUNIO DATA SCIENTIST'
        when exp_year > 2 AND exp_year <=5 then "ASSOCIATE DATA SCIENTIST"
        WHEN exp_year > 5 AND exp_year <= 10 then "SENIOR DATA SCIENTIST"
        WHEN exp_year > 10 and exp_year <= 12 then "LEAD DATA SCIENTIST"
        WHEN exp_year > 12 AND exp_year <= 16 THEN "MANAGER"
        ELSE 'UNDEFINED'
    END;
END //
DELIMITER ;
SELECT Get_standard_job(1);
--
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE, Get_standard_job(EXP) AS standard_role,
    CASE 
        WHEN ROLE = Get_standard_job(EXP) THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS role_check
FROM data_science_team;

-- 	15.	Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee 
-- table after checking the execution plan.

CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME(20));
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

-- 16.	Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
-- (Use the formula: 5% of salary * employee rating).

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (0.05 * SALARY * EMP_RATING) AS BONUS,
    (SALARY +(SALARY *0.05)* EMP_RATING) AS TOTOAL_SALARY
FROM emp_record_table;

-- 17.	Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee
-- record table.

SELECT 
    CONTINENT,
    COUNTRY,
    (AVG(SALARY)) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, COUNTRY;




