LOAD DATA
INFILE 'ztp.unl'
INTO TABLE p_ztp
FIELDS TERMINATED BY '|'
(
  ID_ZTP,
  ROD_CISLO,
  DAT_OD DATE 'MM/DD/YYYY',
  DAT_DO DATE 'MM/DD/YYYY', 
  ID_POSTIHNUTIA
)

