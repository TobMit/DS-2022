
CREATE TABLE plemena
(
	id_plem              int NOT NULL ,
	nazov_plem           varchar2(15) NOT NULL 
);


ALTER TABLE plemena
	ADD CONSTRAINT  XPKPlemeno PRIMARY KEY (id_plem);

CREATE TABLE pobocky
(
	id_pobocky           int NOT NULL ,
	kapacita             int NOT NULL  CONSTRAINT  min_0_137231836 CHECK (kapacita >= 1),
	psc                  CHAR(5) NOT NULL ,
	adresa               Varchar2(30) NOT NULL ,
	mesto                VARCHAR2(50) NULL 
);

ALTER TABLE pobocky
	ADD CONSTRAINT  XPKPobo�ky PRIMARY KEY (id_pobocky);

CREATE TABLE zakaznici_dodavatelia
(
	id_osoby             INTEGER NOT NULL ,
	meno                 varchar2(15) NOT NULL ,
	priezvisko           varchar2(15) NOT NULL ,
	spolocnost           varchar2(30) NULL 
);

ALTER TABLE zakaznici_dodavatelia
	ADD CONSTRAINT  XPKZakaznik_dodavatel PRIMARY KEY (id_osoby);

CREATE TABLE zamestnanci
(
	cislo_zames          int NOT NULL ,
	meno                 varchar2(15) NOT NULL ,
	rod_cis              varchar2(11) NOT NULL ,
	priezvisko           varchar2(15) NOT NULL ,
	prac_od              DATE NOT NULL ,
	prac_do              DATE NULL ,
	id_pobocky           int NOT NULL 
);

ALTER TABLE zamestnanci
	ADD CONSTRAINT  XPKMZamestnanci PRIMARY KEY (cislo_zames);


CREATE TABLE zariadenia
(
	id_zariadenia        int NOT NULL ,
	nazov_zariadenia     VARCHAR2(20) NULL 
);

ALTER TABLE zariadenia
	ADD CONSTRAINT  XPKZoznam_vybavenia PRIMARY KEY (id_zariadenia);

CREATE TABLE pobocky_zariadenia
(
	id_pobocky           int NOT NULL ,
	id_zariadenia        int NOT NULL 
);

ALTER TABLE pobocky_zariadenia
	ADD CONSTRAINT  XPKPobo�ky_Zoznam_vybavenia PRIMARY KEY (id_pobocky,id_zariadenia);

CREATE TABLE zvierata
(
	id_zviera            int NOT NULL ,
	matka                int NULL ,
	otec                 int NULL ,
	meno_zver            CHAR(18) NULL ,
	datum_nar            DATE NULL ,
	pohlavie             CHAR(1) NOT NULL  CONSTRAINT  pohlavie_1868332694 CHECK (pohlavie in ( 'M', 'F')),
	id_pobocky           int NULL ,
	plemeno              int NULL 
);

ALTER TABLE zvierata
	ADD CONSTRAINT  XPKZvierata PRIMARY KEY (id_zviera);

CREATE TABLE fin_operacie
(
    id_transakcia        int NOT NULL ,
    id_osoby             INTEGER NOT NULL ,
	datum                DATE NOT NULL ,
	id_zviera            int NULL ,
	cena                 NUMBER NOT NULL ,
	typ_operacie         CHAR(1) NOT NULL  CONSTRAINT  Typ_transkacie_1348476346 CHECK (typ_operacie in ( 'N', 'n' , 'P', 'p')),
	id_plem              int NOT NULL ,
	id_pobocky           int NOT NULL 
);

ALTER TABLE fin_operacie
	ADD CONSTRAINT  XPKFin_operacie PRIMARY KEY (id_transakcia);

ALTER TABLE zamestnanci
	ADD (CONSTRAINT Miesto_zamestnania FOREIGN KEY (id_pobocky) REFERENCES pobocky (id_pobocky));

ALTER TABLE pobocky_zariadenia
	ADD (CONSTRAINT R_27 FOREIGN KEY (id_pobocky) REFERENCES pobocky (id_pobocky));

ALTER TABLE pobocky_zariadenia
	ADD (CONSTRAINT R_28 FOREIGN KEY (id_zariadenia) REFERENCES zariadenia (id_zariadenia));

ALTER TABLE zvierata
	ADD (CONSTRAINT Chovna_st_zvier FOREIGN KEY (id_pobocky) REFERENCES pobocky (id_pobocky));

ALTER TABLE zvierata
	ADD (CONSTRAINT otec_zv FOREIGN KEY (otec) REFERENCES zvierata (id_zviera));

ALTER TABLE zvierata
	ADD (CONSTRAINT matka_zv FOREIGN KEY (matka) REFERENCES zvierata (id_zviera));

ALTER TABLE zvierata
	ADD (CONSTRAINT plem_zv FOREIGN KEY (plemeno) REFERENCES plemena (id_plem));

ALTER TABLE fin_operacie
	ADD (CONSTRAINT id_zakaznika FOREIGN KEY (id_osoby) REFERENCES zakaznici_dodavatelia (id_osoby));

ALTER TABLE fin_operacie
	ADD (CONSTRAINT Id_pred_zv FOREIGN KEY (id_zviera) REFERENCES zvierata (id_zviera));

ALTER TABLE fin_operacie
	ADD (CONSTRAINT R_29 FOREIGN KEY (id_plem) REFERENCES plemena (id_plem));

ALTER TABLE fin_operacie
	ADD (CONSTRAINT R_30 FOREIGN KEY (id_pobocky) REFERENCES pobocky (id_pobocky));

-- constrain pre zamestnancov opraveny koli tomu ze taky uz existuje
