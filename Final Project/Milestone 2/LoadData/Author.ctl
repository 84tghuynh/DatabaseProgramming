LOAD DATA
INFILE Author.csv
APPEND INTO TABLE Contributor
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY "'"
(ContributorID, FName, MName, LName, MusicalGroup)