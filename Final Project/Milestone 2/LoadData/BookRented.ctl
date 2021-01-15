LOAD DATA
INFILE BookRented.csv
APPEND INTO TABLE BookRented
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(AgreementID, BookID, RentalAmount,RentalExpiry Date 'YYYY-MM-DD')
