LOAD DATA
INFILE 'day_calendar.unl'
INTO TABLE CV6_Zamestnanci

FIELDS TERMINATED BY '|'
(
  id,
  meno,
  priezvisko,
  veduci
)

