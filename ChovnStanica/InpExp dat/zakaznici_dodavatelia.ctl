LOAD DATA
INFILE 'zakaznici_dodavatelia.unl'
INTO TABLE Zakaznici_dodavatelia

FIELDS TERMINATED BY '|'
(
  id_osoby,
  meno,
  priezvisko,
  spolocnost
)