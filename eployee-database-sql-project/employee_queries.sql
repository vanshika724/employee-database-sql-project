
-- Task 3: Fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT FROM emp_record_table;

-- Task 4: EMP_RATING filters
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING FROM emp_record_table WHERE EMP_RATING < 2;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING FROM emp_record_table WHERE EMP_RATING > 4;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT AS DEPARTMENT, EMP_RATING FROM emp_record_table WHERE EMP_RATING BETWEEN 2 AND 4;

-- Task 5: Concatenate name for Finance dept
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME FROM emp_record_table WHERE DEPT = 'Finance';

-- Task 6: Employees who are managers (have someone reporting to them)
SELECT MANAGER_ID, COUNT(*) AS Number_of_Reporters FROM emp_record_table WHERE MANAGER_ID IS NOT NULL GROUP BY MANAGER_ID;

-- Task 7: Healthcare and Finance dept employees using UNION
SELECT * FROM emp_record_table WHERE DEPT = 'Healthcare'
UNION
SELECT * FROM emp_record_table WHERE DEPT = 'Finance';

-- Task 8: Group by department and show employee rating with max
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING,
       MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS Max_Dept_Rating
FROM emp_record_table;

-- Task 9: Min and Max salary by role
SELECT ROLE, MIN(SALARY) AS Min_Salary, MAX(SALARY) AS Max_Salary
FROM emp_record_table
GROUP BY ROLE;

-- Task 10: Ranking based on experience
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP,
       RANK() OVER (ORDER BY EXP DESC) AS Experience_Rank
FROM emp_record_table;

-- Task 11: View for employees with salary > 6000
CREATE VIEW High_Salary_Employees AS
SELECT * FROM emp_record_table WHERE SALARY > 6000;

-- Task 12: Nested query for experience > 10
SELECT * FROM emp_record_table
WHERE EMP_ID IN (
    SELECT EMP_ID FROM emp_record_table WHERE EXP > 10
);

-- Task 13: Stored procedure for employees with EXP > 3
DELIMITER //
CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT * FROM emp_record_table WHERE EXP > 3;
END //
DELIMITER ;

-- Task 14: Stored Function to validate job title
DELIMITER //
CREATE FUNCTION ValidateJobTitle(exp INT, job_title VARCHAR(50))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE standard_title VARCHAR(50);
    IF exp <= 2 THEN
        SET standard_title = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET standard_title = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET standard_title = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET standard_title = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET standard_title = 'MANAGER';
    ELSE
        SET standard_title = 'UNKNOWN';
    END IF;

    IF standard_title = job_title THEN
        RETURN 'MATCH';
    ELSE
        RETURN 'MISMATCH';
    END IF;
END //
DELIMITER ;

-- Task 15: Create index for FIRST_NAME and use EXPLAIN
CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME);
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

-- Task 16: Calculate bonus
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
       (0.05 * SALARY * EMP_RATING) AS BONUS
FROM emp_record_table;

-- Task 17: Average salary by continent and country
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS Avg_Salary
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;
