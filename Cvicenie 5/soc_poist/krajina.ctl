LOAD DATA
INFILE 'krajina.unl'
INTO TABLE p_krajina
FIELDS TERMINATED BY '|'
(
  ID_KRAJINY,
  N_KRAJINY
)

