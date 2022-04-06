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

-- zamestnancov ktorí nemajú žiadneho vedúceho
select id ,meno, priezvisko
    from CV6_Zamestnanci
        where veduci is null ;
-- zamestnancov ktorí nemajú podriadeného
select id, meno, priezvisko, veduci
    from CV6_Zamestnanci
        where id not in (select veduci
                            from CV6_Zamestnanci veduciZ
                                where veduciZ.veduci is not null );
-- kolegov na rovnakej úrovni

-- ku každému zamestnanovi jeho primeho nadriadeného
select zamestnanec.id, zamestnanec.meno, zamestnanec.priezvisko,veduciZ.meno as meno_Nadriadeneho, veduciZ.priezvisko as priezvisko_Nadriadeneho
    from CV6_Zamestnanci zamestnanec join CV6_Zamestnanci  veduciZ on (zamestnanec.veduci = veduciZ.id)
        where zamestnanec.veduci is not null;

