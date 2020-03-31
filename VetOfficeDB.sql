

#If the tables already exist, then they are deleted

DROP TABLE IF EXISTS PetOwner;
DROP TABLE IF EXISTS Animal;
DROP TABLE IF EXISTS Billing;
DROP TABLE IF EXISTS Visit;
DROP TABLE IF EXISTS Treatments;
DROP TABLE IF EXISTS Vet;

CREATE TABLE PetOwner
	(OwnerID	VARCHAR(8),
	 OwnerName	VARCHAR(15),
	 Phone		DECIMAL(11,0),
     Address	VARCHAR(30),
     Email		VARCHAR(30),
     PRIMARY KEY (OwnerID)
	);
    
CREATE TABLE Animal
	(AnimalID	VARCHAR(8),
    OwnerID		VARCHAR(8),
    AnimalName	VARCHAR(15),
    Birthday	DATE,
    AnimalType	VARCHAR(15),
    Breed		VARCHAR(30),
    PRIMARY KEY (AnimalID),
    FOREIGN KEY (OwnerID) REFERENCES PetOwner(OwnerID) ON DELETE SET NULL
	);
    
CREATE TABLE Visit
(VisitNum	DECIMAL(8,0),
AnimalID	VARCHAR(8),
VisitDate	DATE,
Reason		VARCHAR(30),
Treatments	VARCHAR(1), #Gonna need to change this, not sure list is best
VetID		VARCHAR(8),
VisitType	VARCHAR(8),
PRIMARY KEY (VisitNum), 
FOREIGN KEY (AnimalID) REFERENCES Animal (AnimalID) ON DELETE CASCADE,
FOREIGN KEY (Treatments) REFERENCES Treatments(TreatmentID) ON DELETE CASCADE,
FOREIGN KEY (VetID) REFERENCES Vet(VetID) ON DELETE CASCADE
);

CREATE TABLE Billing
(
InvoiceNum	DECIMAL(8,0),
VisitNum	DECIMAL(8,0),
TotalPrice	DECIMAL(6,2),
DateFiled	DATE,
DatePaid	DATE,
PRIMARY KEY (InvoiceNum),
FOREIGN KEY (VisitNum) REFERENCES Visit(VisitNum) ON DELETE CASCADE
);

