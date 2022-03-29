LOAD DATA
INFILE 'typ_prispevku.unl'
INTO TABLE p_typ_prispevku
FIELDS TERMINATED BY '|'
(
  ID_TYPU,
  ZAKL_VYSKA,
  POPIS
)

