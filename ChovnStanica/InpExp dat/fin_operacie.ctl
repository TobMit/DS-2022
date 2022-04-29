LOAD DATA
INFILE 'fin_operacie.unl'
INTO TABLE Fin_Operacie

FIELDS TERMINATED BY '|'
(
  id_predaja,
  id_osoby,
  datum,
  id_zviera,
  cena,
  typ_operacie,
  id_prem,
  id_pobocky
)