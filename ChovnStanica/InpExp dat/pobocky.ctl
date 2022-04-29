LOAD DATA
INFILE 'pobocky.unl'
INTO TABLE Pobocky

FIELDS TERMINATED BY '|'
(
  id_pobocky,
  kapacita,
  adresa,
  mesto,
  psc
)