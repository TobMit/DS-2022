LOAD DATA
INFILE 'poistenie.unl'
INTO TABLE p_poistenie
FIELDS TERMINATED BY '|'
(
  ID_POISTENCA,
  ROD_CISLO,
  ID_PLATITELA,
  OSLOBODENY,
  DAT_OD DATE 'MM/DD/YYYY', 
  DAT_DO DATE 'MM/DD/YYYY' 
)
