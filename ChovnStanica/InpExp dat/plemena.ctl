LOAD DATA
INFILE 'plemena.unl'
INTO TABLE Plemena

FIELDS TERMINATED BY '|'
(
  id_plem,
  nazov_plem
)