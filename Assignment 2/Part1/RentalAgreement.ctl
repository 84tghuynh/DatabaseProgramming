LOAD DATA
INFILE RentalAgreement.dat
APPEND INTO TABLE RentalAgreement
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(AgreementID, CustID, AgreementDate Date 'YYYY-MM-DD', MovieCount, DurationID)
