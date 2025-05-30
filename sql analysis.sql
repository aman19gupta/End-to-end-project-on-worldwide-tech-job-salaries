use aman;
select *from salaries1;
alter table salaries1
rename column `Expert LevelperiEntry levelce_level` to experience_level;

## q1 Average Salary (USD) by Experience Level
SELECT experience_level,AVG(salary_in_usd) AS avg_salary
FROM salaries1
GROUP BY experience_level 
order by avg_salary desc;

## q2 Find Top 5 Highest Paying Jobs and their location
SELECT  distinct job_title, salary_in_usd,company_location
FROM salaries1
ORDER BY salary_in_usd DESC
LIMIT 5;

WITH RankedDuplicates AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY  salary ORDER BY salary_in_usd) AS rn
  FROM salaries1
)

DELETE FROM salaries1
WHERE salary_in_usd IN (
    SELECT salary_in_usd
    FROM RankedDuplicates
    WHERE rn > 1
);
## q3 Count the Number of Remote Jobs (remote_ratio = 100)
SELECT COUNT(*) 
FROM salaries1
WHERE remote_ratio = 100;

##  q4 Average Salary by Company Size
SELECT company_size, AVG(salary_in_usd) AS avg_salary
FROM salaries1
GROUP BY company_size 
order by avg_salary desc;

## q5 Find Highest Salary for Each Experience Level
SELECT experience_level, MAX(salary_in_usd) AS highest_salary
FROM salaries1
GROUP BY experience_level 
order by highest_salary desc;

## q6 Average Salary by Company Size and Employment Type
SELECT company_size, employment_type, AVG(salary_in_usd) AS avg_salary
FROM salaries1
GROUP BY company_size, employment_type
ORDER BY avg_salary DESC;


## q8 Top 5 Locations with Most Employees
SELECT company_location, COUNT(*) AS employee_count
FROM salaries1
GROUP BY company_location
ORDER BY employee_count DESC
LIMIT 5;

## q9 Difference between Maximum and Minimum Salary per Experience Level
SELECT experience_level, 
       MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_gap
FROM salaries1
GROUP BY experience_level
order BY experience_level desc ;

## q10 Find Top 3 Highest Paid Job Titles per Company Size
WITH RankedJobs AS (
  SELECT company_size, job_title, salary_in_usd,
         RANK() OVER (PARTITION BY company_size ORDER BY salary_in_usd DESC) AS rnk
  FROM salaries1
)
SELECT *
FROM RankedJobs
WHERE rnk <= 3;


## q7 Count Employees per Experience Level for Each Company Size
select company_size, experience_level, COUNT(*) AS employee_count
FROM salaries1
GROUP BY company_size, experience_level
ORDER BY employee_count desc;