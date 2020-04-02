#CREATE DATABASE VetClinic;
USE VetClinic;

DROP TABLE IF EXISTS Billing;
DROP TABLE IF EXISTS Visit;
DROP TABLE IF EXISTS Treatment;
DROP TABLE IF EXISTS Vet;
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS PetOwner;


CREATE TABLE PetOwner(
   ownerID INT NOT NULL, 
   firstName VARCHAR(20), 
   lastName VARCHAR(20),
   phone VARCHAR(20),
   email VARCHAR(40),
   address VARCHAR(40),
   city VARCHAR(20),
   state VARCHAR(20),
   zipcode INT,
   PRIMARY KEY (ownerID)
   );
   
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

CREATE TABLE Vet(
	vetID INT NOT NULL,
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	salary DECIMAL(8,2),
	phone VARCHAR(20),
	PRIMARY KEY (vetID)
);

CREATE TABLE Treatment(
	treatmentID INT NOT NULL,
	animalType VARCHAR(20) NOT NULL,
	treatmentType VARCHAR(40) NOT NULL,
	cost DECIMAL(8,2),
	PRIMARY KEY (treatmentID)
);

CREATE TABLE Visit(
	visitID INT NOT NULL,
	treatmentID INT,
	animalID INT,
	visitDate DATETIME,
	reason VARCHAR(100), #Changed the type from TEXT to VARCHAR(100) in order to have it accepted as a PRIMARY KEY
	checkIn TIME,
	vetID INT,
	FOREIGN KEY (animalID) REFERENCES Animal(animalID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (vetID) REFERENCES Vet(vetID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (treatmentID) REFERENCES Treatment(treatmentID) ON DELETE CASCADE ON UPDATE CASCADE, #We need to clarify the ON DELETE constraint
	PRIMARY KEY (visitID, TreatmentID, reason) #I added "reason" because regarding the entries of that table, it only works by considering the reason as a primary key
    /* THE FOLLOWING COMMENT IS JUST INFORMATIVE, NOT A BETTER WAY TO DO IT
    (However it can be interesting to argue on our choice and the reasons of it: easier to understand and to track data modification/limit discrepancy)
    We can limit the amount of data by deleting visitID if we assume that a vet cannot have 2 visit at the same time and same date (should we just put date-time in the same attribute?)
    for the same animal and the same treatment, then we would get PRIMARY KEY (vetID, visitDate, checkIn, treatmentID, animalID)
    but it would change the Billing table though
    */
);

CREATE TABLE Billing (
	invoiceNumber INT NOT NULL,
	visitID INT NOT NULL,
	totalCost DECIMAL(8,2),
	dateFilled DATE,
	datePaid DATE,
	FOREIGN KEY (visitID) REFERENCES Visit(visitID) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (invoiceNumber)
);

INSERT Treatment VALUES
(11,'Dog','Vaccine', 50),
(12,'Cat','Vaccine', 50),
(21,'Dog','Checkup', 150),
(22,'Cat','Checkup', 150),
(24,'Rabbit','Checkup', 100),
(31,'Dog','Antibiotic', 75),
(33,'Mouse','Antibiotic', 25),
(35,'Bird','Antibiotic', 50);

INSERT Vet VALUES
(12345,'Cristina','Yang','90000', '212-555-1234'),
(13579,'Derek','Shepherd','100000', '123-456-7890'),
(10101,'Preston','Burke','80000', '212-555-7293');

INSERT PetOwner VALUES
(1010,'Calynn','Vitus', '678-999-8212', 'vitusc@gmail.com','135 Broadway St', 'New York', 'New York', 10001),
(2222,'Emily','Grgigg','123-755-2099', 'eg@yahoo.com', NULL, NULL, NULL, NULL),
(7624,'Jerome','Auguste','279-776-2323', NULL, '89 Paris St', 'New York', 'New York', 10001),
(24601, 'Jean', 'ValJean', '444-555-6666', 'jvalj@hotmail.com', '726 Maple Ave', 'Downers Grove', 'Illinois', 60515),
(9143, 'Barack', 'Obama', '630-912-4492', 'barack_obama@whitehouse.gov', '2720 S. Highland Ave', 'New York', 'New York', 10001),
(1011, 'Michelle', 'Obama', NULL, '2720 S. Highland Ave', 'michelle_obama@whitehouse.gov', 'New York', 'New York', 10001);

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

INSERT Visit VALUES
(75, '22', 1, '2020-04-28 09:30:00', 'Yearly Checkup', NULL, 12345),
(88, '11', 3, '2020-03-01 13:45:00', 'Rabies Shot', '13:32:09', 13579),
(88, '11', 3, '2020-03-01 13:45:00', 'Feline Distemper', '13:32:09', 13579),
(11, '33', 11, '1980-01-01 10:15:00', 'Lyme Disease', '10:17:07', 12345),
(12, '33', 11, '1981-01-01 10:15:00', 'Lyme Disease', '10:10:17', 12345),
(13, '33', 11, '1982-01-03 10:00:00', 'Lyme Disease', '9:57:11', 12345),
(14, '33', 11, '1982-02-01 14:30:00', 'Followup', '14:27:55', 12345),
(15, '33', 11, '1983-01-05 10:00:00', 'Lyme Disease', NULL, 12345),
(16, '33', 11, '1984-01-01 08:00:00', 'Lyme Disease', '08:15:33', 12345),
(22, '22', 8, '1855-03-31 19:00:00', 'Emergency Checkup', NULL, 13579),
(44, '33', 10, '2019-12-04 15:00:00', 'Antibiotics', '14:45:00', 12345),
(17, '33', 11, '1985-01-01 12:00:00', 'Lyme Disease', '11:59:59', 12345),
(01, '11', 7, '1900-05-22 14:25:00', 'Polio Vaccine', '14:05:56', 13579),
(99, '33', 9, '2019-12-04 15:00:00', 'Antibiotics', '14:30:00', 13579),
(98, '33', 10, '2019-12-04 16:00:00', 'Antibiotics', '14:31:15', 10101),
(97, '33', 11, '2019-12-04 16:15:00', 'Lyme Disease', '16:15:01', 13579),
(96, '21', 1, '2019-12-04 09:30:00', 'Yearly Checkup', '09:31:00', 13579),
(96, '11', 1, '2019-12-04 10:00:00', 'Polio Vaccine', '09:31:00', 13579),
(96, '31', 1, '2019-12-04 10:30:00', 'Heartworms', '09:31:00', 10101),
(96, '11', 1, '2019-12-04 10:15:00', 'Anthrax Vaccine', '09:31:00', 13579);


INSERT Billing VALUES
(101, 88, 100, '2020-03-08', '2020-03-10'),
(102, 75, 250,  '2020-04-21', NULL),
(103, 11, 15, '1980-06-01', '1999-01-04'),
(104, 12, 15, '1981-06-01', '1999-01-04'),
(105, 13, 15, '1982-06-01', '1999-01-04'),
(106, 14, 25, '1982-06-01', '1999-01-04'),
(107, 15, 25, '1983-06-01', NULL),
(108, 16, 25, '1984-06-01', NULL),
(109, 96, 375, '2019-12-05', '2019-12-05');



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