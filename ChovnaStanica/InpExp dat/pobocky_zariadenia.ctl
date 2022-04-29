LOAD DATA
INFILE 'pobocky_zariadenia.unl'
INTO TABLE Pobocky_zariadenia

FIELDS TERMINATED BY '|'
(
  id_pobocky,
  id_zariadenia
)