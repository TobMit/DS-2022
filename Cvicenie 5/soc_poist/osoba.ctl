LOAD DATA
INFILE 'osoba.unl'
INTO TABLE p_osoba
FIELDS TERMINATED BY '|'
(
	MENO,
	PRIEZVISKO,
	ROD_CISLO,
	PSC,
	ULICA
)

