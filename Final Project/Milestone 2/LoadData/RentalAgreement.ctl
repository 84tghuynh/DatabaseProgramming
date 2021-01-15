LOAD DATA
INFILE RentalAgreement.csv
APPEND INTO TABLE RentalAgreement
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(AgreementID, CustID, AgreementDate Date 'YYYY-MM-DD', ItemCount, DurationID,RentalType)
