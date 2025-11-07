-- Practice working with multiple tables in MySQL
-- EMPLOYEES, JOB_HISTORY, JOBS, DEPARTMENTS and LOCATIONS tables

-- ACCESSING MULTIPLE TABLES WITH SUB-QUERIES

-- Retrieve only the EMPLOYEES records that correspond to jobs in the JOBS table.
select * from EMPLOYEES where JOB_ID IN (select JOB_IDENT from JOBS);

-- Retrieve only the list of employees whose JOB_TITLE is Jr. Designer.
select * from EMPLOYEES where JOB_ID IN (select JOB_IDENT from JOBS where JOB_TITLE= 'Jr. Designer');

-- Retrieve JOB information and who earn more than $70,000.
select JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT from JOBS where JOB_IDENT IN (select JOB_ID from EMPLOYEES where SALARY > 70000 );

-- Retrieve JOB information and list of employees whose birth year is after 1976.
select JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT from JOBS where JOB_IDENT IN (select JOB_ID from EMPLOYEES where YEAR(B_DATE)>1976 );

-- Retrieve JOB information and list of female employees whose birth year is after 1976.
select JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT from JOBS  where JOB_IDENT IN (select JOB_ID from EMPLOYEES where YEAR(B_DATE)>1976 and SEX='F' );

-- ACCESSING MULTIPLE TABLES WITH IMPLICIT JOINS

-- Perform an implicit cartesian/cross join between EMPLOYEES and JOBS tables.
select * from EMPLOYEES, JOBS;

-- Retrieve only the EMPLOYEES records that correspond to jobs in the JOBS table.
select * from EMPLOYEES, JOBS where EMPLOYEES.JOB_ID = JOBS.JOB_IDENT;

-- Redo the previous query, using shorter aliases for table names.
select * from EMPLOYEES E, JOBS J where E.JOB_ID = J.JOB_IDENT;

-- Redo the previous query, but retrieve only the Employee ID, Employee Name and Job Title.
select EMP_ID,F_NAME,L_NAME, JOB_TITLE from EMPLOYEES E, JOBS J where E.JOB_ID = J.JOB_IDENT;

-- Redo the previous query, but specify the fully qualified column names with aliases in the SELECT clause.
select E.EMP_ID,E.F_NAME,E.L_NAME, J.JOB_TITLE from EMPLOYEES E, JOBS  J where E.JOB_ID = J.JOB_IDENT;
