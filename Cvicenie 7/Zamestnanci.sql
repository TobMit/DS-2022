-- Zamestnanci
CREATE TABLE CV6_Zamestnanci
(
    id                   INTEGER NOT NULL ,
    veduci               INTEGER NULL ,
    meno                 Varchar2(20) NULL ,
    priezvisko           Varchar2(20) NULL
);

ALTER TABLE CV6_Zamestnanci
    ADD CONSTRAINT  XPKZamestnanci PRIMARY KEY (id);

ALTER TABLE CV6_Zamestnanci
    ADD (CONSTRAINT R_2 FOREIGN KEY (veduci) REFERENCES CV6_Zamestnanci (id) ON DELETE SET NULL);

commit ;

