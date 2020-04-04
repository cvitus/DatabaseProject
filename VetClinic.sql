DROP DATABASE IF EXISTS VetClinic;
CREATE DATABASE VetClinic;
USE VetClinic;

DROP TABLE IF EXISTS Billing;
DROP TABLE IF EXISTS Visit;
DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS Vet;
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS PetOwner;
DROP TABLE IF EXISTS Given;

DROP VIEW IF EXISTS billing_view;
DROP VIEW IF EXISTS visit_view;
DROP VIEW IF EXISTS treatment_view;
DROP VIEW IF EXISTS vet_view;
DROP VIEW IF EXISTS animal_view;
DROP VIEW IF EXISTS petowner_view;
DROP VIEW IF EXISTS given_view;

DROP FUNCTION IF EXISTS IsActivePatient;
DROP EVENT IF EXISTS patient_status_event;

CREATE TABLE PetOwner(
   ownerID INT NOT NULL, 
   firstName VARCHAR(20), 
   lastName VARCHAR(20),
   email VARCHAR(40),
   address VARCHAR(40),
   city VARCHAR(20),
   state VARCHAR(20),
   PRIMARY KEY (ownerID)
   );
   
CREATE VIEW petowner_view AS
SELECT * FROM PetOwner;
   
CREATE TABLE Animal(
	animalID INT NOT NULL,
    ownerID INT,
    animalName VARCHAR(40),
    animalBirthday DATE,
    animalType VARCHAR(20) NOT NULL,
    animalBreed VARCHAR(20),
    activePatient BOOLEAN,
    FOREIGN KEY (ownerID) REFERENCES PetOwner(ownerID) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (animalID)
);

CREATE VIEW animal_view AS
SELECT * FROM Animal;


CREATE TABLE Vet(
	vetID INT NOT NULL,
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	salary DECIMAL(8,2),
	email VARCHAR(30),
	PRIMARY KEY (vetID)
);

CREATE VIEW vet_view AS
SELECT * FROM Vet;



CREATE TABLE Treatment(
	treatmentID INT NOT NULL,
	animalType VARCHAR(20) NOT NULL,
	treatmentType VARCHAR(40) NOT NULL,
	cost DECIMAL(8,2),
    PRIMARY KEY (treatmentID)
	#FOREIGN KEY (treatmentID) REFERENCES Given(treatmentID) ON DELETE CASCADE ON UPDATE CASCADE
);

 CREATE VIEW treatment_view AS
SELECT * FROM Treatment;

CREATE TABLE Given(
visitID INT NOT NULL,
treatmentID INT NOT NULL,
PRIMARY KEY (visitID),
FOREIGN KEY (treatmentID) REFERENCES Treatment(treatmentID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE VIEW given_view AS SELECT * FROM Given;

CREATE TABLE Visit(
	visitID INT NOT NULL,
	animalID INT,
	visitDate DATETIME,
	reason VARCHAR(100), #Changed the type from TEXT to VARCHAR(100) in order to have it accepted as a PRIMARY KEY
	checkIn TIME,
	vetID INT,
	FOREIGN KEY (animalID) REFERENCES Animal(animalID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (visitID) REFERENCES Given(visitID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (vetID) REFERENCES Vet(vetID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE VIEW visit_view AS
SELECT * FROM Visit;

CREATE TABLE Billing (
	visitID INT,
	totalCost DECIMAL(8,2),
	dateFilled DATE,
	datePaid DATE,
	FOREIGN KEY (visitID) REFERENCES Given(visitID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE VIEW billing_view AS
SELECT * FROM Billing;






INSERT Vet VALUES
(12345,'Cristina','Yang','90000', 'c.yang@seattle.med'),
(13579,'Derek','Shepherd','100000', 'dshep@greysloan.net'),
(10101,'Preston','Burke','80000', 'burkep@cornellmed.edu');

INSERT PetOwner VALUES
(1010,'Calynn','Vitus', 'vitusc@gmail.com','135 Broadway St', 'New York', 'New York'),
(2222,'Emily','Grgigg', 'eg@yahoo.com', NULL, NULL, NULL),
(7624,'Jerome','Auguste', NULL, '89 Paris St', 'New York', 'New York'),
(24601, 'Jean', 'ValJean',  'jvalj@hotmail.com', '726 Maple Ave', 'Downers Grove', 'Illinois'),
(9143, 'Barack', 'Obama',  'barack_obama@whitehouse.gov', '2720 S. Highland Ave', 'New York', 'New York'),
(1011, 'Michelle', 'Obama','michelle_obama@whitehouse.gov','2720 S. Highland Ave', 'New York', 'New York');

INSERT Animal VALUES
(1, 1010, 'Clifford', '1962-02-05', 'Dog', 'Great Dane', 1),
(2, 2222, 'Bugs', '1940-07-27', 'Rabbit', NULL, 1),
(3, 7624, 'Garfield', '2019-07-28', 'Cat', 'Tabby', 1),
(4, 1010, 'Minnie', '2018-10-18', 'Mouse', NULL, 0),
(5, 24601, 'Cosette', '1862-01-31', 'Cat', 'Calico', 0),
(6, 24601, 'Javert', NULL, 'Snake', NULL, 0),
(7, 24601, 'Marius', '1866-07-22', 'Dog', 'Miniature Schnauzer', 1),
(8, 24601, 'Fantine', '1840-09-03', 'Cat', NULL, 0),
(9, 9143, 'Malia', '1998-07-04', 'Mouse', NULL, 1),
(10, 9143, 'Sasha', '2001-06-10', 'Mouse', NULL, 1),
(11, 1011, 'Barack', '1961-08-04', 'Mouse', Null, 1);

INSERT Treatment VALUES
(11,'Dog','Vaccine', 50),
(12,'Cat','Vaccine', 50),
(21,'Dog','Checkup', 150),
(22,'Cat','Checkup', 150),
(24,'Rabbit','Checkup', 100),
(31,'Dog','Antibiotic', 75),
(33,'Mouse','Antibiotic', 25),
(35,'Bird','Antibiotic', 50);

INSERT Given VALUES
(75, 11),
(88, 11),
(11, 12),
(12, 12),
(13, 21),
(14, 21),
(15, 22),
(16,22),
(22,24),
(44, 31),
(17, 31),
(1, 31),
(99, 33),
(98, 35),
(97, 11),
(96, 11),
(101, 21),
(121, 24);

INSERT Visit VALUES
(75,  1, '2020-04-28 09:30:00', 'Yearly Checkup', NULL, 12345),
(88,  3, '2020-03-01 13:45:00', 'Rabies Shot', '13:32:09', 13579),
(88,  3, '2020-03-01 13:45:00', 'Feline Distemper', '13:32:09', 13579),
(11,  11, '1980-01-01 10:15:00', 'Lyme Disease', '10:17:07', 12345),
(12,  11, '1981-01-01 10:15:00', 'Lyme Disease', '10:10:17', 12345),
(13,  11, '1982-01-03 10:00:00', 'Lyme Disease', '9:57:11', 12345),
(14,  11, '1982-02-01 14:30:00', 'Followup', '14:27:55', 12345),
(15,  11, '1983-01-05 10:00:00', 'Lyme Disease', NULL, 12345),
(16,  11, '1984-01-01 08:00:00', 'Lyme Disease', '08:15:33', 12345),
(22,  8, '1855-03-31 19:00:00', 'Emergency Checkup', NULL, 13579),
(44,  10, '2019-12-04 15:00:00', 'Antibiotics', '14:45:00', 12345),
(17,  11, '1985-01-01 12:00:00', 'Lyme Disease', '11:59:59', 12345),
(01,  7, '1900-05-22 14:25:00', 'Polio Vaccine', '14:05:56', 13579),
(99,  9, '2019-12-04 15:00:00', 'Antibiotics', '14:30:00', 13579),
(98,  10, '2019-12-04 16:00:00', 'Antibiotics', '14:31:15', 10101),
(97,  11, '2019-12-04 16:15:00', 'Lyme Disease', '16:15:01', 13579),
(96,  1, '2019-12-04 09:30:00', 'Yearly Checkup', '09:31:00', 13579),
(96,  1, '2019-12-04 10:00:00', 'Polio Vaccine', '09:31:00', 13579),
(96,  1, '2019-12-04 10:30:00', 'Heartworms', '09:31:00', 10101),
(96,  1, '2019-12-04 10:15:00', 'Anthrax Vaccine', '09:31:00', 13579),
(101, 3, '2019-09-01 13:45:00', 'Feline Distemper', '13:32:09', 13579),
(121, 3, '2020-04-15 12:00:00', 'Heartworm Vaccine', NULL, NULL);


INSERT Billing VALUES
(88, 100, '2020-03-08', '2020-03-10'),
(75, 250,  '2020-04-21', NULL),
(11, 15, '1980-06-01', '1999-01-04'),
(12, 15, '1981-06-01', '1999-01-04'),
(13, 15, '1982-06-01', '1999-01-04'),
(14, 25, '1982-06-01', '1999-01-04'),
(15, 25, '1983-06-01', NULL),
(16, 25, '1984-06-01', NULL),
(96, 375, '2019-12-05', '2019-12-05'),
(101, 50, '2019-09-24', NULL);

SELECT * FROM VET;

#Query for all unpaid bill
SELECT OwnerID, AnimalID, VisitID, TotalCost, VisitDate
FROM (Billing NATURAL JOIN Visit) NATURAL JOIN Animal
WHERE DatePaid IS NULL;

#Query for all visits on a specific day
SELECT VisitID, Reason, VetID, AnimalName, AnimalType, VisitDate
FROM Visit NATURAL JOIN Animal
WHERE VisitDate >= '2019-12-04 00:00:00' AND VisitDate < '2019-12-05 00:00:00'
GROUP BY VisitDate;

#Health History of a specific pet
SELECT VisitID, AnimalName, Reason, VisitDate
FROM (Visit NATURAL JOIN Animal)
WHERE AnimalID = 11;

#PetOwner Instance


#Change Address of Client
UPDATE PetOwner
SET Address = '1600 Pennsylvania Ave', city='Washington DC', state='Washington DC'
WHERE lastname = 'Obama';

SELECT * FROM BILLING;
UPDATE Billing SET TotalCost =
	CASE
		WHEN datePaid IS NULL AND dateFilled < '2019-04-01'
		THEN totalCost*1.2
		WHEN datePaid IS NULL AND (dateFilled > '2019-04-01' AND dateFilled < '2020-01-01')
		THEN totalCost*1.1
		ELSE totalCost
    END;

DROP TRIGGER IF EXISTS vet_raise;
DELIMITER //
CREATE TRIGGER vet_raise
BEFORE INSERT ON VISIT FOR EACH ROW BEGIN
DECLARE aptcount INT;
SET aptcount = (SELECT COUNT(*) FROM Visit WHERE VetID = NEW.VetID);
IF aptcount=9
	THEN
		UPDATE Vet SET Salary=Salary*1.1 WHERE VetID=New.VetID;
END IF;
END//

INSERT Visit VALUES (122, '12', 3, '2020-04-15 12:00:00', 'Heartworm Vaccine', NULL, 12345);

#Function to return 0 if the patient hasn't come since 2017, 1 otherwise
DELIMITER //
CREATE FUNCTION IsActivePatient (vAnimalID INT, vDate DATE) RETURNS BOOLEAN
BEGIN
	DECLARE vRecentAppointments INT;
    DECLARE vCurrentActivity BOOLEAN;
    SELECT COUNT(*) INTO vRecentAppointments FROM Visit
    WHERE AnimalID = vAnimalID AND visitDate > vDate;
    SELECT activePatient INTO vCurrentActivity FROM Animal 
    WHERE AnimalID = vAnimalID;
    CASE
		WHEN vCurrentActivity = 0
        THEN RETURN 0;
        ELSE RETURN vRecentAppointments > 0;
	END CASE;
END; //
DELIMITER ;

#Procedure to do the function to all pets
DROP PROCEDURE IF EXISTS update_patient_status;
DELIMITER //
CREATE PROCEDURE update_patient_status (IN vDate DATE )
BEGIN
UPDATE Animal
SET ActivePatient = IsActivePatient(AnimalID, vDate);
END //
DELIMITER ;

CREATE EVENT patient_status_event
ON SCHEDULE EVERY 1 MONTH
STARTS '2020-05-01 00:00:01'
DO CALL update_patient_status (DATEADD(year, -2, current_date()));
SET GLOBAL event_scheduler = 1;

DROP PROCEDURE IF EXISTS UpdateTreatmentCosts;
DELIMITER //
CREATE PROCEDURE UpdateTreatmentCosts
    (IN vPriceChange DECIMAL(5,2))
BEGIN
	DECLARE Amt INT DEFAULT 0;
    START TRANSACTION;
    UPDATE Treatment SET cost = cost*vPriceChange;
    SET Amt = (SELECT COUNT(*) FROM Treatment WHERE Cost < 10);
    IF Amt>0
		THEN ROLLBACK;
	ELSE COMMIT;
    END IF;
END; //
DELIMITER ;
CALL UpdateTreatmentCosts(0.5);
SELECT * FROM Treatment;


