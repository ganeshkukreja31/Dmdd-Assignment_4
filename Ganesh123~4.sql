CREATE TABLE department (
  dept_id NUMBER(5) NOT NULL PRIMARY KEY,
  dept_name VARCHAR2(20) UNIQUE NOT NULL,
  dept_location VARCHAR2(2) NOT NULL
);

CREATE SEQUENCE dept_id_auto START WITH 1;

INSERT INTO department (dept_id, dept_name, dept_location) VALUES (dept_id_auto.NEXTVAL, 'Sales', 'NY');
INSERT INTO department (dept_id, dept_name, dept_location) VALUES (dept_id_auto.NEXTVAL, 'Marketing', 'CA');
INSERT INTO department (dept_id, dept_name, dept_location) VALUES (dept_id_auto.NEXTVAL, 'Human Resources', 'TX');
INSERT INTO department (dept_id, dept_name, dept_location) VALUES (dept_id_auto.NEXTVAL, 'Finance', 'IL');
INSERT INTO department (dept_id, dept_name, dept_location) VALUES (dept_id_auto.NEXTVAL, 'IT', 'NJ');
INSERT INTO department (dept_id, dept_name, dept_location) VALUES (dept_id_auto.NEXTVAL, 'Engineering', 'MA');

CREATE OR REPLACE PROCEDURE update_department(
    d_dept_name IN VARCHAR2,
    d_dept_location IN VARCHAR2
)
IS
    dp_dept_name VARCHAR2(40);
    dp_count NUMBER;
BEGIN
    -- Validate department name
    IF d_dept_name IS NULL OR LENGTH(d_dept_name) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Department name cannot be null or empty.');
    ELSIF REGEXP_LIKE(d_dept_name, '^[0-9]+$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Department name cannot be a number.');
    END IF;

    -- Convert department name to camel case
    dp_dept_name := INITCAP(d_dept_name);

    -- Validate department location
    IF NOT d_dept_location IN ('TX', 'IL', 'CA', 'MA', 'NJ', 'NY', 'RH', 'NH') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Dept location is invalid.');
    END IF;
    
    -- dept name length is more than 20 chars
    IF LENGTH(d_dept_name) > 20 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Dept name should not be more than 20 char.');
    END IF;
    
    -- dept name exists
    SELECT COUNT(*) INTO dp_count FROM DEPARTMENT WHERE dept_name = dp_dept_name;
    IF dp_count = 0 THEN
        -- Insert dept
        INSERT INTO DEPARTMENT(dept_id, dept_name, dept_location)
        VALUES(dept_id_auto.NEXTVAL, dp_dept_name, d_dept_location);
        DBMS_OUTPUT.PUT_LINE('Dept inserted.');
    ELSE
        -- Update deptlocation
        UPDATE DEPARTMENT SET dept_location = d_dept_location WHERE dept_name = dp_dept_name;
        DBMS_OUTPUT.PUT_LINE('Dept updated.');
    END IF;
    COMMIT;
END;

/
--IF THE DEPT NAME IS INVALID (NULL)
BEGIN
    UPDATE_DEPT(NULL, 'MA');
END;
/
--IF THE DEPT NAME IS INVALID (ZERO LENGTH)
BEGIN
    UPDATE_DEPT('', 'MA');
END;
/
--IF THE DEPT NAME IS A NUMBER
BEGIN
    UPDATE_DEPT('1234', 'MA');
END;
/
-- TEST CASE FOR ACCEPTED LOCATIONS
BEGIN
    UPDATE_DEPT('SALES', 'MH');
END;
/
--DEPT NAME WITH MORE THAN 20 CHAR
BEGIN
    UPDATE_DEPT('123456788900abcdefghijklmnopqr', 'NY');
END;
/
-- DEPT IF NAME DOESN'T EXIST
BEGIN
    UPDATE_DEPT('Ganesh', 'MA');
END;
/
--UPDT A DEPT LOCATION IF NAME IT EXISTS
BEGIN
    UPDATE_DEPT('Ganesh', 'RH');
END;
/
--CONVERT DEPT NAME TO CAMELCASE
BEGIN
UPDATE_DEPT('Dmdd', 'CA');
END;
/

select * from department;

DROP PROCEDURE update_department;
DROP SEQUENCE dept_id_auto;
DROP TABLE DEPARTMENT;
