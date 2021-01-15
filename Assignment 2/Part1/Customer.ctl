LOAD DATA
INFILE Customer.dat
APPEND INTO TABLE Customer
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' AND '"'
(CustID, FName, LName, StreetNo, Street, City, Province, PCode, PrimaryCustID)
