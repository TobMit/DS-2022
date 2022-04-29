LOAD DATA
INFILE 'zariadenia.unl'
INTO TABLE Zariadenia

FIELDS TERMINATED BY '|'
(
  id_zariadenia,
  nazov_zariadenia
)