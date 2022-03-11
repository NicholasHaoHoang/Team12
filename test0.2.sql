DROP TABlE Museum;
DROP TABLE Exhibition;
DROP TABLE Customers;
DROP TABLE GiftShop;
DROP TABLE ARTPIECES;
DROP TABLE TICKET;
DROP TABLE EMPLOYEES;
DROP TABLE Departments;
USE MiniWorld;

CREATE TABLE Museum(
	mName VARCHAR(65) NOT NULL,
    Street VARCHAR(30) NOT NULL,
    City VARCHAR(20) NOT NULL,
    Province VARCHAR(20) NOT NULL,
    ZipCode VARCHAR(5) NOT NULL,
    sTime TIME NOT NULL,
    eTime TIME NOT NULL,
    Ratings DECIMAL (2,1),
    PRIMARY KEY(mName)
    );
CREATE TABLE Exhibition(
	EXID	INT(8) NOT NULL,
	exName VARCHAR(50) NOT NULL,
    COST  DOUBLE(4,2),
    sDate DATE NOT NULL,
    eDate DATE NOT NULL,
    PRIMARY KEY(exName),
    CONSTRAINT INVALID_INSTALL_DATE CHECK (((sDate > '2001-01-01') and (sDate <= sysdate()))),
	CONSTRAINT INVALID_REMOVE_DATE CHECK (((eDate > '2001-01-01') and (eDate >= sDate))));
CREATE TABLE ACCESS(
	ACID INT(8) NOT NULL,
    ACEN VARCHAR(50) NOT NULL,
    ACC DOUBLE(4,2),
	FOREIGN KEY(ACID) REFERENCES CUSTOMER(CID),
    FOREIGN KEY(ACEN) REFERENCES EXHIBITION(exName),
    FOREIGN KEY(ACC) REFERENCES EXHIBITION(COST)
    
);
create table Customers(
	FirstName		CHAR(50),
    LastName		CHAR(50),
    Age				INT(3),
    PhoneNumber		BIGINT(10),
    Email			VARCHAR(50),
    CID				INT(8) NOT NULL,
    SpecialStatus	ENUM('CollegeStudent', 'Veteran', 'Senior', 'Child', 'None') NOT NULL,
    Primary Key (CID)
);
create table GiftShop(
	GiftID		INT(10),
    GiftName	VARCHAR(30),
    Price		DOUBLE(16,2),
    SpecialStatus	ENUM('Sold', 'In Stock') NOT NULL,
    Primary Key (GiftID),
    FOREIGN KEY (GiftID) REFERENCES CUSTOMER(CID)
);
CREATE TABLE ARTPIECES (
  AID char(6) NOT NULL,
  ANAME varchar(100) NOT NULL,  -- NAME OF THE PIECE
  ARTIST varchar(50) DEFAULT NULL,  -- ARTIST NAME
  DEPTNAME enum('PAINTING','SCULPTURE','FILM','ARCHITECTURE') NOT NULL,
  ARTINFO varchar(1500) DEFAULT NULL,  -- DESCRIPTION OF ART
  INDATE date NOT NULL,
  OUTDATE date DEFAULT NULL,
  
  PRIMARY KEY (AID),
  -- FOREIGN KEY (DEPTNAME) REFERENCES DEPARTMENT()
  FOREIGN KEY (dID) REFERENCES CUSTOMER(Dep_Num)
  CONSTRAINT INVALID_INSTALL_DATE CHECK (((INDATE > '2001-01-01') and (INDATE <= sysdate()))),
  CONSTRAINT INVALID_REMOVE_DATE CHECK (((OUTDATE > '2001-01-01') and (OUTDATE >= INDATE)))
);
CREATE TABLE TICKET 
(
	TID   		CHAR(10)    	NOT NULL ,	-- PASSED,  will automatically add trailling spaces
				-- CONSTRAINT ck_Only_Numbers  -- PASSED
				-- CHECK (TID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
				
	TTYPES  	ENUM('CHILD','SENIOR','REGULAR','VETERAN','STUDENT') 
					NOT NULL,
                                
	PRICE  		DECIMAL(8,2)   	NOT NULL,
    
	SOLDDATE	DATE  			
				CONSTRAINT INVALID_SOLDDATE
				CHECK( SOLDDATE >= '2001-01-01' AND SOLDDATE  <= SYSDATE()),    -- PASSED 	-- Format: YYYY-MM-DD, date is string
                
	CUSID  		INT(8)						NOT NULL,
	
	PRIMARY KEY (TID),
    FOREIGN KEY (CUSID) REFERENCES CUSTOMER(CID)
    
	-- CONSTRAINT ALLOCATED_TO_CUSTOMER
	-- FOREIGN KEY (CUSID) 
    -- REFERENCES CUSTOMER(CID) 
    -- ON UPDATE CASCADE
    -- ON DELETE SET NULL
);
CREATE TABLE EMPLOYEES (
  EMPLOYEE_ID INT(10) NOT NULL,  -- Employee's ID
  JOBTITLE varchar(100) NOT NULL,
  FIRST_NAME varchar(50) NOT NULL,  -- FNAME OF THE EMPLOYEE
  LAST_NAME varchar(50) NOT NULL,  -- LNAME OF THE EMPLOYEE
  AGE varchar(3) NOT NULL,  -- AGE OF EMPLOYEE
  SEX ENUM('M','F','Other'),
  PHONE_NUMBER char(10) NOT NULL,
  EMPLOYEE_ADDRESS varchar(200) NOT NULL,
  SALARY DECIMAL(9, 2) NOT NULL,
  BIRTHDATE date NOT NULL,
  FOREIGN KEY (dNum) REFERENCES CUSTOMER(Dep_Num)--works in department


  
  PRIMARY KEY (EMPLOYEE_ID),
);
--set up in a way that this could now apply to multiple museums if they happen to be owned by the same dude
CREATE TABLE Departments(
    Dep_Num int(10) NOT NULL,--artificial key
    Dep_Name VARCHAR(30) NOT NULL,--ex: giftshop, scultpures, classical
    PRIMARY KEY(Dep_Num)
    FOREIGN KEY (Museum_Name) REFERENCES CUSTOMER(mName)
    );
INSERT INTO EMPLOYEES(JOBTITLE, EMPLOYEE_NAME, AGE, SEX, EMPLOYEE_ID, PHONE_NUMBER, EMPLOYEE_ADDRESS, SALARY, BIRTHDATE)
VALUES ('Janitor', "Harold Hart", 21, "M", 1834774838, 8328459284, "440 North St Houston, TX", 40000.00, 12-08-2000),
('Tour Guide', "Arnold Mart", 22, "M", 1004839021, 2817463838, "100 Stone Blvd Bellaire, TX", 60000.00, 08-01-2000);

--  -------Following is test cases ----------
            
INSERT INTO TICKET(TID,TTYPES, PRICE,  SOLDDATE)
VALUES ('123456780','CHILD','12.99', '2020-09-09');  -- TESTING : CONSTARINT SOLD, CORRECT RESULT: FAIL_TO_INSERT

-- ------  FOLLOWING IS TEST CASES      --------
INSERT INTO ARTPIECES(AID, ANAME, ARTIST, DEPTNAME, INDATE)
VALUES ('198762','DAVID','MICHEANGELO','SCULPTURE','2022-03-08');  -- CORRECT RESULT: INSERT SUCCESSFULLY

INSERT INTO ARTPIECES(AID, ANAME, ARTIST, DEPTNAME, INDATE)
VALUES ('19876299','DAVID','MICHEANGELO','SCULPTURE','2022-03-08');  -- CORRECT RESULT: FAIL TO INSERT

INSERT INTO ARTPIECES(AID, ANAME, ARTIST, DEPTNAME, INDATE)
VALUES ('198762','DAVID','MICHEANGELO','BOBBY','2022-03-08');  -- CORRECT RESULT: FAIL TO INSERT

INSERT INTO ARTPIECES(AID, ANAME, ARTIST, DEPTNAME, INDATE)
VALUES ('198762','DAVID','MICHEANGELO','SCULPTURE','2022-04-08');  -- CORRECT RESULT: FAIL TO INSERT

INSERT INTO ARTPIECES(AID, ANAME, ARTIST, DEPTNAME, INDATE, OUTDATE)
VALUES ('198762','DAVID','MICHEANGELO','SCULPTURE','2022-01-08','2022-01-01');  -- CORRECT RESULT: FAIL TO INSERT

INSERT INTO GiftShop VALUES ('0000054321', '10.25', 'Sold');
INSERT INTO GiftShop VALUES ('123456789', '1.99', 'In Stock');
INSERT INTO GiftShop VALUES ('987654321', '8.99', 'Sold');
INSERT INTO GiftShop VALUES ('165489763', '4', 'Sold');
INSERT INTO Customers VALUES ('Dorian', 'Nozales', '23', '8325671234', 'myemail@yahoo.com', 'CollegeStudent');
INSERT INTO Customers VALUES ('Erika', 'Ubuya', '5', null, null, 'Child');
INSERT INTO Customers VALUES ('Elijah', 'Tottenham', '69', '6347895003', null, 'Senior');
INSERT INTO Customers VALUES ('Zachary', 'Sams', '36', '3484700098', null, 'None');   
 
INSERT INTO Museum(mName,Street,City,Province, ZipCode,sTime,eTime,Ratings)
VALUES('Houston Museum of Fine Arts','1001 Bissonnet St', 'Houston', 'TX', '77005','9:00','18:00',4.9);

INSERT INTO Exhibition(exName,sDate,eDate)
VALUES('Summer Art Pieces','2022-06-09','2022-07-09');

SELECT mName AS Museum, CONCAT(Street,', ',City,', ',Province,' ', ZipCode) AS 'Address', sTime AS 'Opening Hours', eTime AS 'Closing Hours', Ratings
FROM Museum;

SELECT *
FROM Museum, Exhibition