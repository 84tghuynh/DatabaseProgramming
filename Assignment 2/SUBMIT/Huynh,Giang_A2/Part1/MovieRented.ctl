LOAD DATA
INFILE MovieRented.dat
APPEND INTO TABLE MovieRented
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(MovieID, AgreementID, RentalAmount, PercentReductionApplied)
