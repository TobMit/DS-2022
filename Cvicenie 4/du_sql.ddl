
CREATE TABLE p_krajina
(
	id_krajiny           CHAR(3) NOT NULL ,
	n_krajiny            VARCHAR2(30) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_krajina ON p_krajina
(id_krajiny   ASC);

ALTER TABLE p_krajina
	ADD CONSTRAINT  XPKp_krajina PRIMARY KEY (id_krajiny);

CREATE TABLE p_kraj
(
	id_kraja             CHAR(2) NOT NULL ,
	n_kraja              VARCHAR2(30) NOT NULL ,
	id_krajiny           CHAR(3) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_kraj ON p_kraj
(id_kraja   ASC);

ALTER TABLE p_kraj
	ADD CONSTRAINT  XPKp_kraj PRIMARY KEY (id_kraja);

CREATE TABLE p_okres
(
	id_okresu            CHAR(2) NOT NULL ,
	n_okresu             VARCHAR2(30) NOT NULL ,
	id_kraja             CHAR(2) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_okres ON p_okres
(id_okresu   ASC);

ALTER TABLE p_okres
	ADD CONSTRAINT  XPKp_okres PRIMARY KEY (id_okresu);

CREATE TABLE p_mesto
(
	PSC                  CHAR(5) NOT NULL ,
	n_mesta              VARCHAR2(30) NOT NULL ,
	id_okresu            CHAR(2) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_mesto ON p_mesto
(PSC   ASC);

ALTER TABLE p_mesto
	ADD CONSTRAINT  XPKp_mesto PRIMARY KEY (PSC);

CREATE TABLE p_osoba
(
	meno                 VARCHAR2(30) NOT NULL ,
	priezvisko           VARCHAR2(30) NOT NULL ,
	ulica                VARCHAR2(50) NULL ,
	PSC                  CHAR(5) NOT NULL ,
	narodenie_PSC        CHAR(5) NULL ,
	rod_cislo            CHAR(11) NOT NULL ,
	matka                CHAR(11) NULL ,
	otec                 CHAR(11) NULL 
);

CREATE UNIQUE INDEX XPKp_osoba ON p_osoba
(rod_cislo   ASC);

ALTER TABLE p_osoba
	ADD CONSTRAINT  XPKp_osoba PRIMARY KEY (rod_cislo);

CREATE TABLE p_platitel
(
	id_platitela         CHAR(11) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_platitel ON p_platitel
(id_platitela   ASC);

ALTER TABLE p_platitel
	ADD CONSTRAINT  XPKp_platitel PRIMARY KEY (id_platitela);

CREATE TABLE p_poistenie
(
	oslobodeny           CHAR(18) NOT NULL ,
	dat_od               DATE NOT NULL ,
	dat_do               DATE NULL ,
	id_poistenca         NUMBER NOT NULL ,
	rod_cislo            CHAR(11) NOT NULL ,
	id_platitela         CHAR(11) NULL 
);

CREATE UNIQUE INDEX XPKp_poistenie ON p_poistenie
(id_poistenca   ASC);

ALTER TABLE p_poistenie
	ADD CONSTRAINT  XPKp_poistenie PRIMARY KEY (id_poistenca);

CREATE TABLE p_odvod_platba
(
	cis_platby           NUMBER NOT NULL ,
	suma                 NUMBER NOT NULL  CONSTRAINT  eura_moje_1861695022 CHECK (suma >= 0),
	dat_platby           DATE NOT NULL ,
	obdobie              DATE NOT NULL ,
	id_poistenca         NUMBER NOT NULL 
);

CREATE UNIQUE INDEX XPKp_odvod_platba ON p_odvod_platba
(cis_platby   ASC,id_poistenca   ASC);

ALTER TABLE p_odvod_platba
	ADD CONSTRAINT  XPKp_odvod_platba PRIMARY KEY (cis_platby,id_poistenca);

CREATE TABLE p_poberatel
(
	id_poberatela        NUMBER NOT NULL ,
	perc_vyj             REAL NOT NULL ,
	dat_od               DATE NOT NULL ,
	dat_do               DATE NULL ,
	id_typu              INTEGER NOT NULL ,
	rod_cislo            CHAR(11) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_poberatel ON p_poberatel
(id_poberatela   ASC);

ALTER TABLE p_poberatel
	ADD CONSTRAINT  XPKp_poberatel PRIMARY KEY (id_poberatela);

CREATE TABLE p_prispevky
(
	obdobie              DATE NOT NULL ,
	kedy                 DATE NOT NULL ,
	suma                 NUMBER NOT NULL ,
	id_poberatela        NUMBER NOT NULL ,
	id_typu              INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKp_prispevky ON p_prispevky
(id_poberatela   ASC,obdobie   ASC);

ALTER TABLE p_prispevky
	ADD CONSTRAINT  XPKp_prispevky PRIMARY KEY (id_poberatela,obdobie);

CREATE TABLE p_typ_postihnutia
(
	id_postihnutia       NUMBER NOT NULL ,
	nazov_postihnutia    VARCHAR2(50) NULL 
);

CREATE UNIQUE INDEX XPKp_typ_postihnutia ON p_typ_postihnutia
(id_postihnutia   ASC);

ALTER TABLE p_typ_postihnutia
	ADD CONSTRAINT  XPKp_typ_postihnutia PRIMARY KEY (id_postihnutia);

CREATE TABLE p_ZTP
(
	id_ZTP               CHAR(6) NOT NULL ,
	dat_od               DATE NOT NULL ,
	dat_do               DATE NULL ,
	id_postihnutia       NUMBER NOT NULL ,
	rod_cislo            CHAR(11) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_ZTP ON p_ZTP
(id_ZTP   ASC);

ALTER TABLE p_ZTP
	ADD CONSTRAINT  XPKp_ZTP PRIMARY KEY (id_ZTP);

CREATE TABLE p_typ_prispevku
(
	id_typu              INTEGER NOT NULL ,
	zakl_vyska           NUMBER NOT NULL  CONSTRAINT  eura_moje_1921464916 CHECK (zakl_vyska >= 0),
	popis                VARCHAR2(10) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_typ_prispevku ON p_typ_prispevku
(id_typu   ASC);

ALTER TABLE p_typ_prispevku
	ADD CONSTRAINT  XPKp_typ_prispevku PRIMARY KEY (id_typu);

CREATE TABLE p_historia
(
	dat_od               DATE NOT NULL ,
	dat_do               DATE NOT NULL ,
	zakl_vyska           NUMBER NOT NULL ,
	id_typu              INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKp_historia ON p_historia
(id_typu   ASC,dat_od   ASC,dat_do   ASC);

ALTER TABLE p_historia
	ADD CONSTRAINT  XPKp_historia PRIMARY KEY (id_typu,dat_od,dat_do);

CREATE TABLE p_zamestnavatel
(
	nazov                VARCHAR2(30) NOT NULL ,
	ulica                VARCHAR2(50) NOT NULL ,
	PSC                  CHAR(5) NOT NULL ,
	ICO                  CHAR(11) NOT NULL 
);

CREATE UNIQUE INDEX XPKp_zamestnavatel ON p_zamestnavatel
(ICO   ASC);

ALTER TABLE p_zamestnavatel
	ADD CONSTRAINT  XPKp_zamestnavatel PRIMARY KEY (ICO);

CREATE TABLE p_zamestnanec
(
	dat_od               DATE NOT NULL ,
	dat_do               DATE NULL ,
	id_zamestnavatela    CHAR(11) NOT NULL ,
	rod_cislo            CHAR(11) NOT NULL ,
	id_poistenca         NUMBER NULL 
);

CREATE UNIQUE INDEX XPKp_zamestnanec ON p_zamestnanec
(id_zamestnavatela   ASC,rod_cislo   ASC,dat_od   ASC);

ALTER TABLE p_zamestnanec
	ADD CONSTRAINT  XPKp_zamestnanec PRIMARY KEY (id_zamestnavatela,rod_cislo,dat_od);

ALTER TABLE p_kraj
	ADD (CONSTRAINT R_1 FOREIGN KEY (id_krajiny) REFERENCES p_krajina (id_krajiny));

ALTER TABLE p_okres
	ADD (CONSTRAINT R_2 FOREIGN KEY (id_kraja) REFERENCES p_kraj (id_kraja));

ALTER TABLE p_mesto
	ADD (CONSTRAINT R_3 FOREIGN KEY (id_okresu) REFERENCES p_okres (id_okresu));

ALTER TABLE p_osoba
	ADD (CONSTRAINT R_4 FOREIGN KEY (PSC) REFERENCES p_mesto (PSC) ON DELETE SET NULL);

ALTER TABLE p_osoba
	ADD (CONSTRAINT R_13 FOREIGN KEY (rod_cislo) REFERENCES p_platitel (id_platitela));

ALTER TABLE p_osoba
	ADD (CONSTRAINT R_23 FOREIGN KEY (otec) REFERENCES p_osoba (rod_cislo) ON DELETE SET NULL);

ALTER TABLE p_osoba
	ADD (CONSTRAINT R_24 FOREIGN KEY (matka) REFERENCES p_osoba (rod_cislo) ON DELETE SET NULL);

ALTER TABLE p_osoba
	ADD (CONSTRAINT R_25 FOREIGN KEY (narodenie_PSC) REFERENCES p_mesto (PSC) ON DELETE SET NULL);

ALTER TABLE p_poistenie
	ADD (CONSTRAINT R_11 FOREIGN KEY (rod_cislo) REFERENCES p_osoba (rod_cislo));

ALTER TABLE p_poistenie
	ADD (CONSTRAINT R_14 FOREIGN KEY (id_platitela) REFERENCES p_platitel (id_platitela) ON DELETE SET NULL);

ALTER TABLE p_odvod_platba
	ADD (CONSTRAINT R_22 FOREIGN KEY (id_poistenca) REFERENCES p_poistenie (id_poistenca));

ALTER TABLE p_poberatel
	ADD (CONSTRAINT R_7 FOREIGN KEY (rod_cislo) REFERENCES p_osoba (rod_cislo));

ALTER TABLE p_poberatel
	ADD (CONSTRAINT R_9 FOREIGN KEY (id_typu) REFERENCES p_typ_prispevku (id_typu) ON DELETE SET NULL);

ALTER TABLE p_prispevky
	ADD (CONSTRAINT R_8 FOREIGN KEY (id_poberatela) REFERENCES p_poberatel (id_poberatela));

ALTER TABLE p_ZTP
	ADD (CONSTRAINT R_5 FOREIGN KEY (rod_cislo) REFERENCES p_osoba (rod_cislo));

ALTER TABLE p_ZTP
	ADD (CONSTRAINT R_6 FOREIGN KEY (id_postihnutia) REFERENCES p_typ_postihnutia (id_postihnutia));

ALTER TABLE p_historia
	ADD (CONSTRAINT R_10 FOREIGN KEY (id_typu) REFERENCES p_typ_prispevku (id_typu));

ALTER TABLE p_zamestnavatel
	ADD (CONSTRAINT R_15 FOREIGN KEY (PSC) REFERENCES p_mesto (PSC));

ALTER TABLE p_zamestnavatel
	ADD (CONSTRAINT R_18 FOREIGN KEY (ICO) REFERENCES p_platitel (id_platitela));

ALTER TABLE p_zamestnanec
	ADD (CONSTRAINT R_19 FOREIGN KEY (id_zamestnavatela) REFERENCES p_zamestnavatel (ICO));

ALTER TABLE p_zamestnanec
	ADD (CONSTRAINT R_20 FOREIGN KEY (rod_cislo) REFERENCES p_osoba (rod_cislo));

ALTER TABLE p_zamestnanec
	ADD (CONSTRAINT R_21 FOREIGN KEY (id_poistenca) REFERENCES p_poistenie (id_poistenca) ON DELETE SET NULL);

CREATE  TRIGGER  tD_p_krajina AFTER DELETE ON p_krajina for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_krajina 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_krajina  p_kraj on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d275", PARENT_OWNER="", PARENT_TABLE="p_krajina"
    CHILD_OWNER="", CHILD_TABLE="p_kraj"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="id_krajiny" */
    SELECT count(*) INTO NUMROWS
      FROM p_kraj
      WHERE
        /*  %JoinFKPK(p_kraj,:%Old," = "," AND") */
        p_kraj.id_krajiny = :old.id_krajiny;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_krajina because p_kraj exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_krajina AFTER UPDATE ON p_krajina for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_krajina 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_krajina  p_kraj on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000fa8a", PARENT_OWNER="", PARENT_TABLE="p_krajina"
    CHILD_OWNER="", CHILD_TABLE="p_kraj"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="id_krajiny" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_krajiny <> :new.id_krajiny
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_kraj
      WHERE
        /*  %JoinFKPK(p_kraj,:%Old," = "," AND") */
        p_kraj.id_krajiny = :old.id_krajiny;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_krajina because p_kraj exists.'
      );
    END IF;
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_kraj AFTER DELETE ON p_kraj for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_kraj 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_kraj  p_okres on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d2e9", PARENT_OWNER="", PARENT_TABLE="p_kraj"
    CHILD_OWNER="", CHILD_TABLE="p_okres"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="id_kraja" */
    SELECT count(*) INTO NUMROWS
      FROM p_okres
      WHERE
        /*  %JoinFKPK(p_okres,:%Old," = "," AND") */
        p_okres.id_kraja = :old.id_kraja;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_kraj because p_okres exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_kraj BEFORE INSERT ON p_kraj for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_kraj 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_krajina  p_kraj on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000ef27", PARENT_OWNER="", PARENT_TABLE="p_krajina"
    CHILD_OWNER="", CHILD_TABLE="p_kraj"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="id_krajiny" */
    SELECT count(*) INTO NUMROWS
      FROM p_krajina
      WHERE
        /* %JoinFKPK(:%New,p_krajina," = "," AND") */
        :new.id_krajiny = p_krajina.id_krajiny;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_kraj because p_krajina does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_kraj AFTER UPDATE ON p_kraj for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_kraj 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_kraj  p_okres on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001fdaa", PARENT_OWNER="", PARENT_TABLE="p_kraj"
    CHILD_OWNER="", CHILD_TABLE="p_okres"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="id_kraja" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_kraja <> :new.id_kraja
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_okres
      WHERE
        /*  %JoinFKPK(p_okres,:%Old," = "," AND") */
        p_okres.id_kraja = :old.id_kraja;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_kraj because p_okres exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_krajina  p_kraj on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_krajina"
    CHILD_OWNER="", CHILD_TABLE="p_kraj"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="id_krajiny" */
  SELECT count(*) INTO NUMROWS
    FROM p_krajina
    WHERE
      /* %JoinFKPK(:%New,p_krajina," = "," AND") */
      :new.id_krajiny = p_krajina.id_krajiny;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_kraj because p_krajina does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_okres AFTER DELETE ON p_okres for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_okres 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_okres  p_mesto on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000de3f", PARENT_OWNER="", PARENT_TABLE="p_okres"
    CHILD_OWNER="", CHILD_TABLE="p_mesto"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id_okresu" */
    SELECT count(*) INTO NUMROWS
      FROM p_mesto
      WHERE
        /*  %JoinFKPK(p_mesto,:%Old," = "," AND") */
        p_mesto.id_okresu = :old.id_okresu;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_okres because p_mesto exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_okres BEFORE INSERT ON p_okres for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_okres 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_kraj  p_okres on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000dd9b", PARENT_OWNER="", PARENT_TABLE="p_kraj"
    CHILD_OWNER="", CHILD_TABLE="p_okres"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="id_kraja" */
    SELECT count(*) INTO NUMROWS
      FROM p_kraj
      WHERE
        /* %JoinFKPK(:%New,p_kraj," = "," AND") */
        :new.id_kraja = p_kraj.id_kraja;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_okres because p_kraj does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_okres AFTER UPDATE ON p_okres for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_okres 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_okres  p_mesto on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001f925", PARENT_OWNER="", PARENT_TABLE="p_okres"
    CHILD_OWNER="", CHILD_TABLE="p_mesto"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id_okresu" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_okresu <> :new.id_okresu
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_mesto
      WHERE
        /*  %JoinFKPK(p_mesto,:%Old," = "," AND") */
        p_mesto.id_okresu = :old.id_okresu;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_okres because p_mesto exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_kraj  p_okres on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_kraj"
    CHILD_OWNER="", CHILD_TABLE="p_okres"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="id_kraja" */
  SELECT count(*) INTO NUMROWS
    FROM p_kraj
    WHERE
      /* %JoinFKPK(:%New,p_kraj," = "," AND") */
      :new.id_kraja = p_kraj.id_kraja;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_okres because p_kraj does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_mesto AFTER DELETE ON p_mesto for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_mesto 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_mesto  p_osoba on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="000257a0", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="narodenie_PSC" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.narodenie_PSC = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = "," AND") */
        p_osoba.narodenie_PSC = :old.PSC;

    /* erwin Builtin Trigger */
    /* p_mesto  p_zamestnavatel on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PSC" */
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnavatel
      WHERE
        /*  %JoinFKPK(p_zamestnavatel,:%Old," = "," AND") */
        p_zamestnavatel.PSC = :old.PSC;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_mesto because p_zamestnavatel exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_mesto  p_osoba on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PSC" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.PSC = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = "," AND") */
        p_osoba.PSC = :old.PSC;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_mesto BEFORE INSERT ON p_mesto for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_mesto 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_okres  p_mesto on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000ef18", PARENT_OWNER="", PARENT_TABLE="p_okres"
    CHILD_OWNER="", CHILD_TABLE="p_mesto"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id_okresu" */
    SELECT count(*) INTO NUMROWS
      FROM p_okres
      WHERE
        /* %JoinFKPK(:%New,p_okres," = "," AND") */
        :new.id_okresu = p_okres.id_okresu;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_mesto because p_okres does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_mesto AFTER UPDATE ON p_mesto for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_mesto 
DECLARE NUMROWS INTEGER;
BEGIN
  /* p_mesto  p_osoba on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00039dbe", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="narodenie_PSC" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.PSC <> :new.PSC
  THEN
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.narodenie_PSC = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = ",",") */
        p_osoba.narodenie_PSC = :old.PSC;
  END IF;

  /* erwin Builtin Trigger */
  /* p_mesto  p_zamestnavatel on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PSC" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.PSC <> :new.PSC
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnavatel
      WHERE
        /*  %JoinFKPK(p_zamestnavatel,:%Old," = "," AND") */
        p_zamestnavatel.PSC = :old.PSC;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_mesto because p_zamestnavatel exists.'
      );
    END IF;
  END IF;

  /* p_mesto  p_osoba on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PSC" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.PSC <> :new.PSC
  THEN
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.PSC = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = ",",") */
        p_osoba.PSC = :old.PSC;
  END IF;

  /* erwin Builtin Trigger */
  /* p_okres  p_mesto on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_okres"
    CHILD_OWNER="", CHILD_TABLE="p_mesto"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="id_okresu" */
  SELECT count(*) INTO NUMROWS
    FROM p_okres
    WHERE
      /* %JoinFKPK(:%New,p_okres," = "," AND") */
      :new.id_okresu = p_okres.id_okresu;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_mesto because p_okres does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_osoba AFTER DELETE ON p_osoba for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_osoba 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_osoba  p_osoba on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="000522c1", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="matka" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.matka = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = "," AND") */
        p_osoba.matka = :old.rod_cislo;

    /* erwin Builtin Trigger */
    /* p_osoba  p_osoba on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="otec" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.otec = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = "," AND") */
        p_osoba.otec = :old.rod_cislo;

    /* erwin Builtin Trigger */
    /* p_osoba  p_zamestnanec on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnanec
      WHERE
        /*  %JoinFKPK(p_zamestnanec,:%Old," = "," AND") */
        p_zamestnanec.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_osoba because p_zamestnanec exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_osoba  p_poistenie on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_poistenie
      WHERE
        /*  %JoinFKPK(p_poistenie,:%Old," = "," AND") */
        p_poistenie.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_osoba because p_poistenie exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_osoba  p_poberatel on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_poberatel
      WHERE
        /*  %JoinFKPK(p_poberatel,:%Old," = "," AND") */
        p_poberatel.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_osoba because p_poberatel exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_osoba  p_ZTP on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_ZTP
      WHERE
        /*  %JoinFKPK(p_ZTP,:%Old," = "," AND") */
        p_ZTP.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_osoba because p_ZTP exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_osoba BEFORE INSERT ON p_osoba for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_osoba 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_mesto  p_osoba on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0004a91e", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="narodenie_PSC" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.narodenie_PSC = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_mesto
            WHERE
              /* %JoinFKPK(:%New,p_mesto," = "," AND") */
              :new.narodenie_PSC = p_mesto.PSC
        ) 
        /* %JoinPKPK(p_osoba,:%New," = "," AND") */
         and p_osoba.rod_cislo = :new.rod_cislo;

    /* erwin Builtin Trigger */
    /* p_osoba  p_osoba on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="matka" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.matka = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_osoba
            WHERE
              /* %JoinFKPK(:%New,p_osoba," = "," AND") */
              :new.matka = p_osoba.rod_cislo
        ) 
        /* %JoinPKPK(p_osoba,:%New," = "," AND") */
         and p_osoba.rod_cislo = :new.rod_cislo;

    /* erwin Builtin Trigger */
    /* p_osoba  p_osoba on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="otec" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.otec = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_osoba
            WHERE
              /* %JoinFKPK(:%New,p_osoba," = "," AND") */
              :new.otec = p_osoba.rod_cislo
        ) 
        /* %JoinPKPK(p_osoba,:%New," = "," AND") */
         and p_osoba.rod_cislo = :new.rod_cislo;

    /* erwin Builtin Trigger */
    /* p_platitel  p_osoba on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_platitel
      WHERE
        /* %JoinFKPK(:%New,p_platitel," = "," AND") */
        :new.rod_cislo = p_platitel.id_platitela;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_osoba because p_platitel does not exist.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_mesto  p_osoba on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PSC" */
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.PSC = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_mesto
            WHERE
              /* %JoinFKPK(:%New,p_mesto," = "," AND") */
              :new.PSC = p_mesto.PSC
        ) 
        /* %JoinPKPK(p_osoba,:%New," = "," AND") */
         and p_osoba.rod_cislo = :new.rod_cislo;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_osoba AFTER UPDATE ON p_osoba for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_osoba 
DECLARE NUMROWS INTEGER;
BEGIN
  /* p_osoba  p_osoba on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="000b3c67", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="matka" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.rod_cislo <> :new.rod_cislo
  THEN
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.matka = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = ",",") */
        p_osoba.matka = :old.rod_cislo;
  END IF;

  /* p_osoba  p_osoba on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="otec" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.rod_cislo <> :new.rod_cislo
  THEN
    UPDATE p_osoba
      SET
        /* %SetFK(p_osoba,NULL) */
        p_osoba.otec = NULL
      WHERE
        /* %JoinFKPK(p_osoba,:%Old," = ",",") */
        p_osoba.otec = :old.rod_cislo;
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_zamestnanec on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="rod_cislo" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.rod_cislo <> :new.rod_cislo
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnanec
      WHERE
        /*  %JoinFKPK(p_zamestnanec,:%Old," = "," AND") */
        p_zamestnanec.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_osoba because p_zamestnanec exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_poistenie on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="rod_cislo" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.rod_cislo <> :new.rod_cislo
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_poistenie
      WHERE
        /*  %JoinFKPK(p_poistenie,:%Old," = "," AND") */
        p_poistenie.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_osoba because p_poistenie exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_poberatel on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="rod_cislo" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.rod_cislo <> :new.rod_cislo
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_poberatel
      WHERE
        /*  %JoinFKPK(p_poberatel,:%Old," = "," AND") */
        p_poberatel.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_osoba because p_poberatel exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_ZTP on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="rod_cislo" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.rod_cislo <> :new.rod_cislo
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_ZTP
      WHERE
        /*  %JoinFKPK(p_ZTP,:%Old," = "," AND") */
        p_ZTP.rod_cislo = :old.rod_cislo;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_osoba because p_ZTP exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_mesto  p_osoba on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="narodenie_PSC" */
  SELECT count(*) INTO NUMROWS
    FROM p_mesto
    WHERE
      /* %JoinFKPK(:%New,p_mesto," = "," AND") */
      :new.narodenie_PSC = p_mesto.PSC;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.narodenie_PSC IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_osoba because p_mesto does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_osoba on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="matka" */
  SELECT count(*) INTO NUMROWS
    FROM p_osoba
    WHERE
      /* %JoinFKPK(:%New,p_osoba," = "," AND") */
      :new.matka = p_osoba.rod_cislo;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.matka IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_osoba because p_osoba does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_osoba on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="otec" */
  SELECT count(*) INTO NUMROWS
    FROM p_osoba
    WHERE
      /* %JoinFKPK(:%New,p_osoba," = "," AND") */
      :new.otec = p_osoba.rod_cislo;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.otec IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_osoba because p_osoba does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_platitel  p_osoba on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="rod_cislo" */
  SELECT count(*) INTO NUMROWS
    FROM p_platitel
    WHERE
      /* %JoinFKPK(:%New,p_platitel," = "," AND") */
      :new.rod_cislo = p_platitel.id_platitela;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_osoba because p_platitel does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_mesto  p_osoba on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PSC" */
  SELECT count(*) INTO NUMROWS
    FROM p_mesto
    WHERE
      /* %JoinFKPK(:%New,p_mesto," = "," AND") */
      :new.PSC = p_mesto.PSC;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.PSC IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_osoba because p_mesto does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_platitel AFTER DELETE ON p_platitel for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_platitel 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_platitel  p_zamestnavatel on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0002a76d", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="ICO" */
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnavatel
      WHERE
        /*  %JoinFKPK(p_zamestnavatel,:%Old," = "," AND") */
        p_zamestnavatel.ICO = :old.id_platitela;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_platitel because p_zamestnavatel exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_platitel  p_poistenie on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="id_platitela" */
    UPDATE p_poistenie
      SET
        /* %SetFK(p_poistenie,NULL) */
        p_poistenie.id_platitela = NULL
      WHERE
        /* %JoinFKPK(p_poistenie,:%Old," = "," AND") */
        p_poistenie.id_platitela = :old.id_platitela;

    /* erwin Builtin Trigger */
    /* p_platitel  p_osoba on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_osoba
      WHERE
        /*  %JoinFKPK(p_osoba,:%Old," = "," AND") */
        p_osoba.rod_cislo = :old.id_platitela;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_platitel because p_osoba exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_platitel AFTER UPDATE ON p_platitel for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_platitel 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_platitel  p_zamestnavatel on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00031fa6", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="ICO" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_platitela <> :new.id_platitela
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnavatel
      WHERE
        /*  %JoinFKPK(p_zamestnavatel,:%Old," = "," AND") */
        p_zamestnavatel.ICO = :old.id_platitela;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_platitel because p_zamestnavatel exists.'
      );
    END IF;
  END IF;

  /* p_platitel  p_poistenie on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="id_platitela" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_platitela <> :new.id_platitela
  THEN
    UPDATE p_poistenie
      SET
        /* %SetFK(p_poistenie,NULL) */
        p_poistenie.id_platitela = NULL
      WHERE
        /* %JoinFKPK(p_poistenie,:%Old," = ",",") */
        p_poistenie.id_platitela = :old.id_platitela;
  END IF;

  /* erwin Builtin Trigger */
  /* p_platitel  p_osoba on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_osoba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="rod_cislo" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_platitela <> :new.id_platitela
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_osoba
      WHERE
        /*  %JoinFKPK(p_osoba,:%Old," = "," AND") */
        p_osoba.rod_cislo = :old.id_platitela;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_platitel because p_osoba exists.'
      );
    END IF;
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_poistenie AFTER DELETE ON p_poistenie for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_poistenie 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_poistenie  p_odvod_platba on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001cede", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_odvod_platba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="id_poistenca" */
    SELECT count(*) INTO NUMROWS
      FROM p_odvod_platba
      WHERE
        /*  %JoinFKPK(p_odvod_platba,:%Old," = "," AND") */
        p_odvod_platba.id_poistenca = :old.id_poistenca;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_poistenie because p_odvod_platba exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_poistenie  p_zamestnanec on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="id_poistenca" */
    UPDATE p_zamestnanec
      SET
        /* %SetFK(p_zamestnanec,NULL) */
        p_zamestnanec.id_poistenca = NULL
      WHERE
        /* %JoinFKPK(p_zamestnanec,:%Old," = "," AND") */
        p_zamestnanec.id_poistenca = :old.id_poistenca;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_poistenie BEFORE INSERT ON p_poistenie for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_poistenie 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_platitel  p_poistenie on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001f662", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="id_platitela" */
    UPDATE p_poistenie
      SET
        /* %SetFK(p_poistenie,NULL) */
        p_poistenie.id_platitela = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_platitel
            WHERE
              /* %JoinFKPK(:%New,p_platitel," = "," AND") */
              :new.id_platitela = p_platitel.id_platitela
        ) 
        /* %JoinPKPK(p_poistenie,:%New," = "," AND") */
         and p_poistenie.id_poistenca = :new.id_poistenca;

    /* erwin Builtin Trigger */
    /* p_osoba  p_poistenie on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_osoba
      WHERE
        /* %JoinFKPK(:%New,p_osoba," = "," AND") */
        :new.rod_cislo = p_osoba.rod_cislo;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_poistenie because p_osoba does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_poistenie AFTER UPDATE ON p_poistenie for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_poistenie 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_poistenie  p_odvod_platba on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00043e0e", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_odvod_platba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="id_poistenca" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_poistenca <> :new.id_poistenca
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_odvod_platba
      WHERE
        /*  %JoinFKPK(p_odvod_platba,:%Old," = "," AND") */
        p_odvod_platba.id_poistenca = :old.id_poistenca;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_poistenie because p_odvod_platba exists.'
      );
    END IF;
  END IF;

  /* p_poistenie  p_zamestnanec on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="id_poistenca" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_poistenca <> :new.id_poistenca
  THEN
    UPDATE p_zamestnanec
      SET
        /* %SetFK(p_zamestnanec,NULL) */
        p_zamestnanec.id_poistenca = NULL
      WHERE
        /* %JoinFKPK(p_zamestnanec,:%Old," = ",",") */
        p_zamestnanec.id_poistenca = :old.id_poistenca;
  END IF;

  /* erwin Builtin Trigger */
  /* p_platitel  p_poistenie on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="id_platitela" */
  SELECT count(*) INTO NUMROWS
    FROM p_platitel
    WHERE
      /* %JoinFKPK(:%New,p_platitel," = "," AND") */
      :new.id_platitela = p_platitel.id_platitela;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.id_platitela IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_poistenie because p_platitel does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_poistenie on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poistenie"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="rod_cislo" */
  SELECT count(*) INTO NUMROWS
    FROM p_osoba
    WHERE
      /* %JoinFKPK(:%New,p_osoba," = "," AND") */
      :new.rod_cislo = p_osoba.rod_cislo;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_poistenie because p_osoba does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_p_odvod_platba BEFORE INSERT ON p_odvod_platba for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_odvod_platba 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_poistenie  p_odvod_platba on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00010139", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_odvod_platba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="id_poistenca" */
    SELECT count(*) INTO NUMROWS
      FROM p_poistenie
      WHERE
        /* %JoinFKPK(:%New,p_poistenie," = "," AND") */
        :new.id_poistenca = p_poistenie.id_poistenca;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_odvod_platba because p_poistenie does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_odvod_platba AFTER UPDATE ON p_odvod_platba for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_odvod_platba 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_poistenie  p_odvod_platba on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000fd1e", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_odvod_platba"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="id_poistenca" */
  SELECT count(*) INTO NUMROWS
    FROM p_poistenie
    WHERE
      /* %JoinFKPK(:%New,p_poistenie," = "," AND") */
      :new.id_poistenca = p_poistenie.id_poistenca;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_odvod_platba because p_poistenie does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_poberatel AFTER DELETE ON p_poberatel for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_poberatel 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_poberatel  p_prispevky on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e806", PARENT_OWNER="", PARENT_TABLE="p_poberatel"
    CHILD_OWNER="", CHILD_TABLE="p_prispevky"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="id_poberatela" */
    SELECT count(*) INTO NUMROWS
      FROM p_prispevky
      WHERE
        /*  %JoinFKPK(p_prispevky,:%Old," = "," AND") */
        p_prispevky.id_poberatela = :old.id_poberatela;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_poberatel because p_prispevky exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_poberatel BEFORE INSERT ON p_poberatel for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_poberatel 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_typ_prispevku  p_poberatel on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="000202e1", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="id_typu" */
    UPDATE p_poberatel
      SET
        /* %SetFK(p_poberatel,NULL) */
        p_poberatel.id_typu = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_typ_prispevku
            WHERE
              /* %JoinFKPK(:%New,p_typ_prispevku," = "," AND") */
              :new.id_typu = p_typ_prispevku.id_typu
        ) 
        /* %JoinPKPK(p_poberatel,:%New," = "," AND") */
         and p_poberatel.id_poberatela = :new.id_poberatela;

    /* erwin Builtin Trigger */
    /* p_osoba  p_poberatel on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_osoba
      WHERE
        /* %JoinFKPK(:%New,p_osoba," = "," AND") */
        :new.rod_cislo = p_osoba.rod_cislo;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_poberatel because p_osoba does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_poberatel AFTER UPDATE ON p_poberatel for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_poberatel 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_poberatel  p_prispevky on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00033ab7", PARENT_OWNER="", PARENT_TABLE="p_poberatel"
    CHILD_OWNER="", CHILD_TABLE="p_prispevky"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="id_poberatela" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_poberatela <> :new.id_poberatela
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_prispevky
      WHERE
        /*  %JoinFKPK(p_prispevky,:%Old," = "," AND") */
        p_prispevky.id_poberatela = :old.id_poberatela;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_poberatel because p_prispevky exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_typ_prispevku  p_poberatel on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="id_typu" */
  SELECT count(*) INTO NUMROWS
    FROM p_typ_prispevku
    WHERE
      /* %JoinFKPK(:%New,p_typ_prispevku," = "," AND") */
      :new.id_typu = p_typ_prispevku.id_typu;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.id_typu IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_poberatel because p_typ_prispevku does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_poberatel on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="rod_cislo" */
  SELECT count(*) INTO NUMROWS
    FROM p_osoba
    WHERE
      /* %JoinFKPK(:%New,p_osoba," = "," AND") */
      :new.rod_cislo = p_osoba.rod_cislo;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_poberatel because p_osoba does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_p_prispevky BEFORE INSERT ON p_prispevky for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_prispevky 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_poberatel  p_prispevky on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00010859", PARENT_OWNER="", PARENT_TABLE="p_poberatel"
    CHILD_OWNER="", CHILD_TABLE="p_prispevky"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="id_poberatela" */
    SELECT count(*) INTO NUMROWS
      FROM p_poberatel
      WHERE
        /* %JoinFKPK(:%New,p_poberatel," = "," AND") */
        :new.id_poberatela = p_poberatel.id_poberatela;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_prispevky because p_poberatel does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_prispevky AFTER UPDATE ON p_prispevky for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_prispevky 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_poberatel  p_prispevky on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000fe38", PARENT_OWNER="", PARENT_TABLE="p_poberatel"
    CHILD_OWNER="", CHILD_TABLE="p_prispevky"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="id_poberatela" */
  SELECT count(*) INTO NUMROWS
    FROM p_poberatel
    WHERE
      /* %JoinFKPK(:%New,p_poberatel," = "," AND") */
      :new.id_poberatela = p_poberatel.id_poberatela;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_prispevky because p_poberatel does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_typ_postihnutia AFTER DELETE ON p_typ_postihnutia for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_typ_postihnutia 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_typ_postihnutia  p_ZTP on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d85f", PARENT_OWNER="", PARENT_TABLE="p_typ_postihnutia"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="id_postihnutia" */
    SELECT count(*) INTO NUMROWS
      FROM p_ZTP
      WHERE
        /*  %JoinFKPK(p_ZTP,:%Old," = "," AND") */
        p_ZTP.id_postihnutia = :old.id_postihnutia;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_typ_postihnutia because p_ZTP exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_typ_postihnutia AFTER UPDATE ON p_typ_postihnutia for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_typ_postihnutia 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_typ_postihnutia  p_ZTP on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000fdb9", PARENT_OWNER="", PARENT_TABLE="p_typ_postihnutia"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="id_postihnutia" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_postihnutia <> :new.id_postihnutia
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_ZTP
      WHERE
        /*  %JoinFKPK(p_ZTP,:%Old," = "," AND") */
        p_ZTP.id_postihnutia = :old.id_postihnutia;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_typ_postihnutia because p_ZTP exists.'
      );
    END IF;
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_p_ZTP BEFORE INSERT ON p_ZTP for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_ZTP 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_typ_postihnutia  p_ZTP on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0002013c", PARENT_OWNER="", PARENT_TABLE="p_typ_postihnutia"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="id_postihnutia" */
    SELECT count(*) INTO NUMROWS
      FROM p_typ_postihnutia
      WHERE
        /* %JoinFKPK(:%New,p_typ_postihnutia," = "," AND") */
        :new.id_postihnutia = p_typ_postihnutia.id_postihnutia;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_ZTP because p_typ_postihnutia does not exist.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_osoba  p_ZTP on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_osoba
      WHERE
        /* %JoinFKPK(:%New,p_osoba," = "," AND") */
        :new.rod_cislo = p_osoba.rod_cislo;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_ZTP because p_osoba does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_ZTP AFTER UPDATE ON p_ZTP for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_ZTP 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_typ_postihnutia  p_ZTP on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001ffc0", PARENT_OWNER="", PARENT_TABLE="p_typ_postihnutia"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="id_postihnutia" */
  SELECT count(*) INTO NUMROWS
    FROM p_typ_postihnutia
    WHERE
      /* %JoinFKPK(:%New,p_typ_postihnutia," = "," AND") */
      :new.id_postihnutia = p_typ_postihnutia.id_postihnutia;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_ZTP because p_typ_postihnutia does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_ZTP on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_ZTP"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="rod_cislo" */
  SELECT count(*) INTO NUMROWS
    FROM p_osoba
    WHERE
      /* %JoinFKPK(:%New,p_osoba," = "," AND") */
      :new.rod_cislo = p_osoba.rod_cislo;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_ZTP because p_osoba does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_typ_prispevku AFTER DELETE ON p_typ_prispevku for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_typ_prispevku 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_typ_prispevku  p_historia on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001b389", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_historia"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="id_typu" */
    SELECT count(*) INTO NUMROWS
      FROM p_historia
      WHERE
        /*  %JoinFKPK(p_historia,:%Old," = "," AND") */
        p_historia.id_typu = :old.id_typu;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_typ_prispevku because p_historia exists.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_typ_prispevku  p_poberatel on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="id_typu" */
    UPDATE p_poberatel
      SET
        /* %SetFK(p_poberatel,NULL) */
        p_poberatel.id_typu = NULL
      WHERE
        /* %JoinFKPK(p_poberatel,:%Old," = "," AND") */
        p_poberatel.id_typu = :old.id_typu;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_typ_prispevku AFTER UPDATE ON p_typ_prispevku for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_typ_prispevku 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_typ_prispevku  p_historia on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001dfb0", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_historia"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="id_typu" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_typu <> :new.id_typu
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_historia
      WHERE
        /*  %JoinFKPK(p_historia,:%Old," = "," AND") */
        p_historia.id_typu = :old.id_typu;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_typ_prispevku because p_historia exists.'
      );
    END IF;
  END IF;

  /* p_typ_prispevku  p_poberatel on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_poberatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="id_typu" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.id_typu <> :new.id_typu
  THEN
    UPDATE p_poberatel
      SET
        /* %SetFK(p_poberatel,NULL) */
        p_poberatel.id_typu = NULL
      WHERE
        /* %JoinFKPK(p_poberatel,:%Old," = ",",") */
        p_poberatel.id_typu = :old.id_typu;
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_p_historia BEFORE INSERT ON p_historia for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_historia 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_typ_prispevku  p_historia on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f90e", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_historia"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="id_typu" */
    SELECT count(*) INTO NUMROWS
      FROM p_typ_prispevku
      WHERE
        /* %JoinFKPK(:%New,p_typ_prispevku," = "," AND") */
        :new.id_typu = p_typ_prispevku.id_typu;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_historia because p_typ_prispevku does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_historia AFTER UPDATE ON p_historia for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_historia 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_typ_prispevku  p_historia on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000f999", PARENT_OWNER="", PARENT_TABLE="p_typ_prispevku"
    CHILD_OWNER="", CHILD_TABLE="p_historia"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="id_typu" */
  SELECT count(*) INTO NUMROWS
    FROM p_typ_prispevku
    WHERE
      /* %JoinFKPK(:%New,p_typ_prispevku," = "," AND") */
      :new.id_typu = p_typ_prispevku.id_typu;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_historia because p_typ_prispevku does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_p_zamestnavatel AFTER DELETE ON p_zamestnavatel for each row
-- erwin Builtin Trigger
-- DELETE trigger on p_zamestnavatel 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_zamestnavatel  p_zamestnanec on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f43e", PARENT_OWNER="", PARENT_TABLE="p_zamestnavatel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="id_zamestnavatela" */
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnanec
      WHERE
        /*  %JoinFKPK(p_zamestnanec,:%Old," = "," AND") */
        p_zamestnanec.id_zamestnavatela = :old.ICO;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete p_zamestnavatel because p_zamestnanec exists.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_p_zamestnavatel BEFORE INSERT ON p_zamestnavatel for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_zamestnavatel 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_platitel  p_zamestnavatel on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001fb69", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="ICO" */
    SELECT count(*) INTO NUMROWS
      FROM p_platitel
      WHERE
        /* %JoinFKPK(:%New,p_platitel," = "," AND") */
        :new.ICO = p_platitel.id_platitela;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_zamestnavatel because p_platitel does not exist.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_mesto  p_zamestnavatel on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PSC" */
    SELECT count(*) INTO NUMROWS
      FROM p_mesto
      WHERE
        /* %JoinFKPK(:%New,p_mesto," = "," AND") */
        :new.PSC = p_mesto.PSC;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_zamestnavatel because p_mesto does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_zamestnavatel AFTER UPDATE ON p_zamestnavatel for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_zamestnavatel 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_zamestnavatel  p_zamestnanec on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00031eee", PARENT_OWNER="", PARENT_TABLE="p_zamestnavatel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="id_zamestnavatela" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.ICO <> :new.ICO
  THEN
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnanec
      WHERE
        /*  %JoinFKPK(p_zamestnanec,:%Old," = "," AND") */
        p_zamestnanec.id_zamestnavatela = :old.ICO;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update p_zamestnavatel because p_zamestnanec exists.'
      );
    END IF;
  END IF;

  /* erwin Builtin Trigger */
  /* p_platitel  p_zamestnavatel on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_platitel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="ICO" */
  SELECT count(*) INTO NUMROWS
    FROM p_platitel
    WHERE
      /* %JoinFKPK(:%New,p_platitel," = "," AND") */
      :new.ICO = p_platitel.id_platitela;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_zamestnavatel because p_platitel does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_mesto  p_zamestnavatel on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_mesto"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnavatel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PSC" */
  SELECT count(*) INTO NUMROWS
    FROM p_mesto
    WHERE
      /* %JoinFKPK(:%New,p_mesto," = "," AND") */
      :new.PSC = p_mesto.PSC;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_zamestnavatel because p_mesto does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_p_zamestnanec BEFORE INSERT ON p_zamestnanec for each row
-- erwin Builtin Trigger
-- INSERT trigger on p_zamestnanec 
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* p_poistenie  p_zamestnanec on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0003784e", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="id_poistenca" */
    UPDATE p_zamestnanec
      SET
        /* %SetFK(p_zamestnanec,NULL) */
        p_zamestnanec.id_poistenca = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM p_poistenie
            WHERE
              /* %JoinFKPK(:%New,p_poistenie," = "," AND") */
              :new.id_poistenca = p_poistenie.id_poistenca
        ) 
        /* %JoinPKPK(p_zamestnanec,:%New," = "," AND") */
         and p_zamestnanec.dat_od = :new.dat_od AND
        p_zamestnanec.id_zamestnavatela = :new.id_zamestnavatela AND
        p_zamestnanec.rod_cislo = :new.rod_cislo;

    /* erwin Builtin Trigger */
    /* p_osoba  p_zamestnanec on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="rod_cislo" */
    SELECT count(*) INTO NUMROWS
      FROM p_osoba
      WHERE
        /* %JoinFKPK(:%New,p_osoba," = "," AND") */
        :new.rod_cislo = p_osoba.rod_cislo;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_zamestnanec because p_osoba does not exist.'
      );
    END IF;

    /* erwin Builtin Trigger */
    /* p_zamestnavatel  p_zamestnanec on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_zamestnavatel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="id_zamestnavatela" */
    SELECT count(*) INTO NUMROWS
      FROM p_zamestnavatel
      WHERE
        /* %JoinFKPK(:%New,p_zamestnavatel," = "," AND") */
        :new.id_zamestnavatela = p_zamestnavatel.ICO;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert p_zamestnanec because p_zamestnavatel does not exist.'
      );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_p_zamestnanec AFTER UPDATE ON p_zamestnanec for each row
-- erwin Builtin Trigger
-- UPDATE trigger on p_zamestnanec 
DECLARE NUMROWS INTEGER;
BEGIN
  /* erwin Builtin Trigger */
  /* p_poistenie  p_zamestnanec on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00034757", PARENT_OWNER="", PARENT_TABLE="p_poistenie"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="id_poistenca" */
  SELECT count(*) INTO NUMROWS
    FROM p_poistenie
    WHERE
      /* %JoinFKPK(:%New,p_poistenie," = "," AND") */
      :new.id_poistenca = p_poistenie.id_poistenca;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.id_poistenca IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_zamestnanec because p_poistenie does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_osoba  p_zamestnanec on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_osoba"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="rod_cislo" */
  SELECT count(*) INTO NUMROWS
    FROM p_osoba
    WHERE
      /* %JoinFKPK(:%New,p_osoba," = "," AND") */
      :new.rod_cislo = p_osoba.rod_cislo;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_zamestnanec because p_osoba does not exist.'
    );
  END IF;

  /* erwin Builtin Trigger */
  /* p_zamestnavatel  p_zamestnanec on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="p_zamestnavatel"
    CHILD_OWNER="", CHILD_TABLE="p_zamestnanec"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="id_zamestnavatela" */
  SELECT count(*) INTO NUMROWS
    FROM p_zamestnavatel
    WHERE
      /* %JoinFKPK(:%New,p_zamestnavatel," = "," AND") */
      :new.id_zamestnavatela = p_zamestnavatel.ICO;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update p_zamestnanec because p_zamestnavatel does not exist.'
    );
  END IF;


-- erwin Builtin Trigger
END;
/

