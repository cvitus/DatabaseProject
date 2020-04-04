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

#Procedure to automatically set the cost of a bill
DROP PROCEDURE IF EXISTS TotalVisitCost;

DELIMITER //
CREATE PROCEDURE TotalVisitCost (IN invisitID INT)
BEGIN
    UPDATE Billing
        SET totalCost =
            (SELECT SUM(cost) FROM Treatment
            NATURAL JOIN Given
            GROUP BY visitID) WHERE VisitID = invisitID;
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