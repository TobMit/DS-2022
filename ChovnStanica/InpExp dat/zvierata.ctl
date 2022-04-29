LOAD DATA
INFILE 'zvierata.unl'
INTO TABLE Zvierata

FIELDS TERMINATED BY '|'
(
  id_zviera,
  matka,
  otec,
  meno_zver,
  datum_nar,
  pohlavie,
  id_pobocky,
  plemeno
)