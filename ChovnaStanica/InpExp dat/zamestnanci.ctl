LOAD DATA
INFILE 'zamestnanci.unl'
INTO TABLE Zamestnanci

FIELDS TERMINATED BY '|'
(
  cislo_zames,
  id_pobocky,
  rod_cis,
  meno,
  priezvisko,
  prac_od DATE 'DD/MM/YYYY',
  prac_do DATE 'DD/MM/YYYY'
  )