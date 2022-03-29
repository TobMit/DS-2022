LOAD DATA
INFILE 'zamestnavatel.unl'
INTO TABLE p_zamestnavatel
FIELDS TERMINATED BY '|'
(
  ICO,
  NAZOV,
  PSC,
  ULICA  
)

