-- Create schema if not exists azure_company;
-- SQL Server does not support creating schema if not exists directly.

-- Use azure_company;
-- SQL Server uses USE statement as well.

USE PowerBi;
GO

-- Your select statement remains the same for SQL Server.
SELECT * FROM information_schema.table_constraints
	WHERE constraint_schema = 'PowerBi';
GO

-- Create domain D_num as int check(D_num> 0 and D_num< 21);
-- SQL Server does not support CREATE DOMAIN. You can use CHECK constraint directly on the column.

CREATE TABLE employee (
	Fname VARCHAR(15) NOT NULL,
    Minit CHAR,
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL, 
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR,
    Salary DECIMAL(10,2) CHECK (Salary > 2000.0), -- Adding CHECK constraint directly
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT pk_employee PRIMARY KEY (Ssn),
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
);
GO
alter table employee 
	add constraint fk_employee 
	foreign key(Super_ssn) references employee(Ssn)
    on delete set null
    on update cascade;
-- Alter table employee modify Dno int not null default 1;
-- In SQL Server, the ALTER TABLE statement does not support MODIFY. You can use the following:

ALTER TABLE employee
    ADD CONSTRAINT df_Dno DEFAULT 1 FOR Dno;
GO

-- Desc employee;
-- SQL Server does not support DESC keyword. You can use sp_help to get table information.

EXEC sp_help 'employee';
GO

CREATE TABLE departament (
	Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE, 
    Dept_create_date DATE,
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE (Dname),
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
);
GO

-- Modify a constraint: drop and add
-- SQL Server does not support DROP CONSTRAINT. You can only disable constraints.

-- ALTER TABLE departament DROP CONSTRAINT departament_ibfk_1; -- Not supported in SQL Server

-- Instead, you can disable the constraint:
-- ALTER TABLE departament NOCHECK CONSTRAINT departament_ibfk_1;

-- And then add the modified constraint:
ALTER TABLE departament
    ADD CONSTRAINT fk_dept FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
    ON UPDATE CASCADE;
GO

-- Desc departament;
-- Use sp_help to get table information.
EXEC sp_help 'departament';
GO

CREATE TABLE dept_locations (
	Dnumber INT NOT NULL,
	Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament(Dnumber)
);
GO

-- Alter table dept_locations drop fk_dept_locations;
-- SQL Server does not support dropping foreign keys directly.
-- Instead, you can disable the foreign key:

-- ALTER TABLE dept_locations NOCHECK CONSTRAINT fk_dept_locations;

-- Then, add the modified constraint:
ALTER TABLE dept_locations 
    ADD CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament(Dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
GO

CREATE TABLE project (
	Pname VARCHAR(15) NOT NULL,
	Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES departament(Dnumber)
);
GO

CREATE TABLE works_on (
	Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    CONSTRAINT pk_works_on PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);
GO

-- DROP TABLE dependent;
CREATE TABLE dependent (
	Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR,
    Bdate DATE,
    Relationship VARCHAR(8),
    CONSTRAINT pk_dependent PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);
GO

-- Show tables;
-- SQL Server does not have a direct equivalent of "SHOW TABLES".
-- You can use the following query to get a list of tables:

SELECT table_name FROM information_schema.tables WHERE table_schema = 'PowerBi';
GO

-- Desc dependent;
-- Use sp_help to get table information.
EXEC sp_help 'dependent';
GO
