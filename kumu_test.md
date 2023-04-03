This is a brief overview of my solution for the provided DBA skill assessment. The exercise can be divided into 3 parts: 1) Fix table creation script, 2) bulk load data ,and 3) create an optimized query to get the top 100 employees based on salary. 

## 1. Fix table creation scripts
The first change for the table creation scripts is to switch the storage engine from MyISAM to InnoDB. InnoDB has been the default storage engine for MySQL since version 5.5. It offers several advantages over MyISAM which makes it more sutiable for production-grade database environments like:

* ACID compliant and transaction safe to ensure that transactions can be properly rolled back in case of failure 
* Foreign key suppport to enfore data integrity and relationship between tables
* Row-level locking for better concurrency. Processes that update different rows on the same table can proceed simultaneously. MyISAM only has table-level locking which means only one process can modify a table at a time.

The primary keys were changed from decimal to int. Some were also set with AUTO_INCREMENT option. This makes it easier to insert new rows on a table without knowing what the next value of the primary key ID should be. 

Foreign keys were also added to enfore table relationships. Along with this, some INSERT commands were also edited to make them work with foreign keys (e.g. 0's were changed to NULLs, values not found in parent tables were corrected, etc).

Search the file for comments prepended with the keyword 'edited' to see all the modifications made.

## 2. Load data
I was only able to generate a mock data of 1000 rows for this exercise, but the approach for bulk loading data remains the same even if we scale to 10000 rows. I used MySQL's LOAD DATA INFILE command to upload the mock data from a csv stored in the server to the employees table. This works faster than trying to insert multiple rows one by one and is better than using an INSERT statement with multiple values since you can just have a CSV as input file.

## 3. Query for top 100 employees based on salary
For this exercise, the query is quite simple since we are just selecting data from a single table. I assumed that the commission should be factored in to an employee's total salary. Thus total_salary = salary + (salary * commission_pct) or salary * (1 + commission_pct). However, the base query won't use an index. We may try to add a covering index with all the columns in the query included but that still won't work because of the total_salary column. To solve this, we will need to add a virtual generated/computed column. This column can then be added to the covering index and then, we modify the query to use the said index.