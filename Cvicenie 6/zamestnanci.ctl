LOAD DATA
INFILE 'zamestnanci.unl'
INTO TABLE CV6_Zamestnanci

FIELDS TERMINATED BY '|'
(
  id,
  meno,
  priezvisko,
  veduci
)

