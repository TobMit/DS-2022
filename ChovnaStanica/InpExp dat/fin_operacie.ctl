LOAD DATA
INFILE 'fin_operacie.unl'
INTO TABLE Fin_Operacie

FIELDS TERMINATED BY '|'
(
  id_transakcia,
  id_osoby,
  datum DATE 'DD/MM/YYYY',
  id_zviera,
  cena,
  typ_operacie,
  id_prem,
  id_pobocky
)