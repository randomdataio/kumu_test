/*
Assumes that mock data is placed under /var/lib/mysql-files directory. You may need\
to check if the proper configurations are set before using this.

*/
-- 1. Check that local_infile and secure_file_priv options are enabled and properly configured
show GLOBAL VARIABLES like 'secure_file_priv'

/* Sample results
# Variable_name, Value
'secure_file_priv', '/var/lib/mysql-files/' <-- should show the directory where input file is stored
*/

show GLOBAL VARIABLES like 'local_infile'

/* Sample result
# Variable_name, Value
'local_infile', 'ON'
*/

/* 
If any of this are not properly configured, 
you will need to edit the MySQL config file (my.cnf or my.ini) 
and add these under [mysqld] section. You will also need to restart MySQL service
for the changes tp take effect
*/

-- 2. Load bulk data 
LOAD data infile '/var/lib/mysql-files/MOCK_DATA_2.csv' INTO TABLE employees
fields  TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)