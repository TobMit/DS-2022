/*
Created		1.3.2022
Modified		
Project		Data import
Model			Socialna poistovna
Company		Zilinska univerzita v Ziline	
Author		Michal Kvet
Version		
Database		Oracle 18c 
*/



Create table p_osoba (
	rod_cislo Char (11) NOT NULL ,
	meno Varchar2 (20) NOT NULL ,
	priezvisko Varchar2 (30) NOT NULL ,
	PSC Char (5) NOT NULL ,
	ulica Varchar2 (50),
primary key (rod_cislo) 
) 
/

Create table p_zamestnavatel (
	ICO Char (11) NOT NULL ,
	nazov Varchar2 (30) NOT NULL ,
	PSC Char (5) NOT NULL ,
	ulica Varchar2 (50) NOT NULL ,
primary key (ICO) 
) 
/

Create table p_poistenie (
	id_poistenca Number NOT NULL ,
	rod_cislo Char (11) NOT NULL ,
	id_platitela Char (11),
	oslobodeny Char (1) NOT NULL ,
	dat_od Date NOT NULL ,
	dat_do Date,
primary key (id_poistenca) 
) 
/

Create table p_zamestnanec (
	id_zamestnavatela Char (11) NOT NULL ,
	rod_cislo Char (11) NOT NULL ,
	dat_od Date NOT NULL ,
	dat_do Date,
	id_poistenca Number,
primary key (id_zamestnavatela,rod_cislo,dat_od) 
) 
/

Create table p_odvod_platba (
	cis_platby Number NOT NULL ,
	id_poistenca Number NOT NULL ,
	suma Number NOT NULL  Check (suma >= 0 ) ,
	dat_platby Date NOT NULL ,
	obdobie Date NOT NULL ,
primary key (cis_platby,id_poistenca) 
) 
/

Create table p_poberatel (
	id_poberatela Number NOT NULL ,
	rod_cislo Char (11) NOT NULL ,
	id_typu Integer NOT NULL ,
	perc_vyj Real NOT NULL ,
	dat_od Date NOT NULL ,
	dat_do Date,
primary key (id_poberatela) 
) 
/

Create table p_typ_prispevku (
	id_typu Integer NOT NULL ,
	zakl_vyska Number NOT NULL  Check (zakl_vyska >= 0 ) ,
	popis Varchar2 (10) NOT NULL ,
primary key (id_typu) 
) 
/

Create table p_ZTP (
	id_ZTP Char (6) NOT NULL ,
	rod_cislo Char (11) NOT NULL ,
	dat_od Date NOT NULL ,
	dat_do Date,
	id_postihnutia Number NOT NULL ,
primary key (id_ZTP) 
) 
/

Create table p_platitel (
	id_platitela Char (11) NOT NULL ,
primary key (id_platitela) 
) 
/

Create table p_prispevky (
	id_poberatela Number NOT NULL ,
	obdobie Date NOT NULL ,
	id_typu Integer NOT NULL ,
	kedy Date NOT NULL ,
	suma Number NOT NULL  Check (suma >= 0 ) ,
primary key (id_poberatela,obdobie) 
) 
/

Create table p_mesto (
	PSC Char (5) NOT NULL ,
	n_mesta Varchar2 (30) NOT NULL ,
	id_okresu Char (2) NOT NULL ,
primary key (PSC) 
) 
/

Create table p_okres (
	id_okresu Char (2) NOT NULL ,
	n_okresu Varchar2 (30) NOT NULL ,
	id_kraja Char (2) NOT NULL ,
primary key (id_okresu) 
) 
/

Create table p_kraj (
	id_kraja Char (2) NOT NULL ,
	n_kraja Varchar2 (30) NOT NULL ,
	id_krajiny Char (3) NOT NULL ,
primary key (id_kraja) 
) 
/

Create table p_krajina (
	id_krajiny Char (3) NOT NULL ,
	n_krajiny Varchar2 (30) NOT NULL ,
primary key (id_krajiny) 
) 
/

Create table p_typ_postihnutia (
	id_postihnutia Number NOT NULL ,
	nazov_postihnutia Varchar2 (50),
primary key (id_postihnutia) 
) 
/

Create table p_historia (
	id_typu Integer NOT NULL ,
	dat_od Date NOT NULL ,
	dat_do Date NOT NULL ,
	zakl_vyska Number NOT NULL  Check (zakl_vyska >= 0 ) ,
primary key (id_typu,dat_od,dat_do) 
) 
/


-- Create Foreign keys section

Alter table p_poistenie add  foreign key (rod_cislo) references p_osoba (rod_cislo) 
/

Alter table p_ZTP add  foreign key (rod_cislo) references p_osoba (rod_cislo) 
/

Alter table p_poberatel add  foreign key (rod_cislo) references p_osoba (rod_cislo) 
/

Alter table p_zamestnanec add  foreign key (rod_cislo) references p_osoba (rod_cislo) 
/

Alter table p_zamestnanec add  foreign key (id_zamestnavatela) references p_zamestnavatel (ICO) 
/

Alter table p_odvod_platba add  foreign key (id_poistenca) references p_poistenie (id_poistenca) 
/

Alter table p_zamestnanec add  foreign key (id_poistenca) references p_poistenie (id_poistenca) 
/

Alter table p_prispevky add  foreign key (id_poberatela) references p_poberatel (id_poberatela) 
/

Alter table p_poberatel add  foreign key (id_typu) references p_typ_prispevku (id_typu) 
/

Alter table p_historia add  foreign key (id_typu) references p_typ_prispevku (id_typu) 
/

Alter table p_osoba add  foreign key (rod_cislo) references p_platitel (id_platitela) 
/

Alter table p_zamestnavatel add  foreign key (ICO) references p_platitel (id_platitela) 
/

Alter table p_poistenie add  foreign key (id_platitela) references p_platitel (id_platitela) 
/

Alter table p_zamestnavatel add  foreign key (PSC) references p_mesto (PSC) 
/

Alter table p_osoba add  foreign key (PSC) references p_mesto (PSC) 
/

Alter table p_mesto add  foreign key (id_okresu) references p_okres (id_okresu) 
/

Alter table p_okres add  foreign key (id_kraja) references p_kraj (id_kraja) 
/

Alter table p_kraj add  foreign key (id_krajiny) references p_krajina (id_krajiny) 
/

Alter table p_ZTP add  foreign key (id_postihnutia) references p_typ_postihnutia (id_postihnutia) 
/


