-- base query to get top 100 empployees based on salary
SELECT 
    employee_id, 
    last_name, 
    first_name, 
    (salary * (1 + commission_pct)) as total_sal, 
    job_id, 
    hire_date 
FROM employees 
ORDER by total_sal DESC 
LIMIT 100

-- add generated/computed column 
ALTER table employees 
ADD column total_salary decimal (10,2) 
GENERATED ALWAYS AS (salary * (1 + commission_pct))

-- add covering index
create index EMP_COVER_01_IX on employees(total_salary, employee_id, last_name, first_name, job_id, hire_date)

-- revised top employee query

SELECT 
    employee_id, 
    last_name, 
    first_name, 
    total_salary, 
    job_id, 
    hire_date 
FROM employees 
ORDER by total_sal DESC 
LIMIT 100