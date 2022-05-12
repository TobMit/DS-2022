--Ako rozbehať tento triger
-- 1. na DB create fun vypoc_obsadenost
-- 2. alter table pre novy stlpce obsad_poboc - ak uz nieje vytvoreny
-- 3. na DB create proc aktualizuj_obsadenost_pobocky, (malo by vyhodit error, to je ocakavane keď aktualizujeme celu tabulku)
-- 4. spustit blok aby sa naplnila tabulka
-- 5. na DB create trig kontrola_kapacity

---------------------------------------------------- Sekvencia ----------------------------------------------------
create sequence idcko_transakcie
    increment by 1
        start with 11101
            minvalue 11101
    nocycle;

create sequence idcko_zvierata
    increment by 1
        start with 10001
            minvalue 10001
    nocycle;
----------------------------------------------- Funkcia / Procedura -----------------------------------------------
-- funkcia ktorá vráti počet obsadenia chovnej stanice
create or replace function vypoc_obsadenost (cis_pobocky INTEGER)
    return number
is
    obsad integer;
begin
    select count(ID_POBOCKY) into obsad
        from ZVIERATA
            where ID_POBOCKY = cis_pobocky;
    return obsad;
end vypoc_obsadenost;
/

-- vytvorenie noveho stlpca pre automaticky update
alter table POBOCKY add obsad_poboc integer;

-- procedúra kotrá akutualizuje kapacitu v tabulke
create or replace procedure aktualizuj_obsadenost_pobocky(cis_poboc integer)
    is
    begin
        if cis_poboc > 1 then
            update POBOCKY set POBOCKY.obsad_poboc = vypoc_obsadenost(ID_POBOCKY) where ID_POBOCKY = cis_poboc;
        else
            update POBOCKY set POBOCKY.obsad_poboc = vypoc_obsadenost(ID_POBOCKY);
        end if;
    end;
/


-- funkcia - vrati dalsie id_zviera, ktore nebolo pouzite (cislo v poradi)
create or replace function nove_id_zviera return number
    is
    pocet number;
begin
    select max(id_zviera) into pocet
        from zvierata
            where exists (select 'x' from zvierata);
    pocet := pocet +1;

    return pocet;
end;
/

-- cursor ktory spocita hospodarenie pobocky
create or replace function f_hospodarenie (pobocka_id integer)
    return int
    is
    cursor kurzor(id integer) is select cena, typ_operacie from FIN_OPERACIE where ID_POBOCKY = id;
    vyslednaCena number := 0;
begin

    for riadok in kurzor(pobocka_id)
        loop
            if riadok.TYP_OPERACIE = 'P' then vyslednaCena := vyslednaCena + riadok.CENA;
            else vyslednaCena := vyslednaCena - riadok.CENA;
            end if;
        end loop;

    return vyslednaCena;
end;
/

drop function f_hospodarenie;

--Procedura - Zmaz zviera (vstupne udaje -id_zvierata+ check rodièov)
create or replace procedure delete_zviera(del_id_zvierata in int)
    IS
begin
    update zvierata
        set matka = null
            where matka = del_id_zvierata;
    update zvierata
        set otec = null
            where otec = del_id_zvierata;
    update fin_operacie
        set id_zviera = null
            where id_zviera = del_id_zvierata;
    delete from zvierata
        where id_zviera = del_id_zvierata;
end;
/

-- zmaze celu tabulku / vsetky tabulky v spravnom poradi
create or replace procedure drop_vsetko
    IS
begin
    execute immediate 'DROP TABLE fin_operacie';
    execute immediate 'DROP TABLE zakaznici_dodavatelia';
    execute immediate 'DROP TABLE zamestnanci';
    execute immediate 'DROP TABLE pobocky_zariadenia';
    execute immediate 'DROP TABLE zariadenia';
    execute immediate 'DROP TABLE zvierata';
    execute immediate 'DROP TABLE pobocky';
    execute immediate 'DROP TABLE plemena';
end;
/

----------------------------------------------- Trigre -----------------------------------------------
-- triger ktory skontroluje id zvierata vo fin operacie ci je rovnake aj v tabuke zvierat
create or replace trigger overenie
    before insert or update of id_plem on fin_operacie
    for each row
declare
    zviera_id_plem integer;

begin
    select plemeno into zviera_id_plem
        from zvierata
            where id_zviera = :new.id_zviera;
    if zviera_id_plem <> :new.id_plem
    then raise_application_error(-20001, 'zviera nema spravny typ plemena'); end if;
end;
/

-- logger pre fin operacie
alter table fin_operacie
    add uzivatel varchar2(30);
alter table fin_operacie
    add dat_zmeny date;

create or replace trigger logger_fin_operacie
    before insert or update on fin_operacie
    for each row
begin
    :NEW.uzivatel := user;
    :new.dat_zmeny := sysdate;
end;
/

-- ked sa predava zviera tak sa nastavi aj atribut v zvierati na null
create or replace trigger predaj_zvierata
    before insert or update of ID_ZVIERA on fin_operacie
    for each row
begin
    if (:new.typ_operacie = 'P' and :new.id_zviera is not null)
    then
        update zvierata set id_pobocky = null
                where id_zviera = :new.id_zviera;
    end if;
end;
/

-- Triger ktorý skontrouje či nieje prevíšena kapacita pobočky
create or replace trigger kontrola_kapacity
    for insert or update of ID_POBOCKY on ZVIERATA
    compound trigger
        cekovaKapacia integer;
        obsadenostPobocky integer;
        newId integer := :new.ID_POBOCKY;

    before each row is
    begin
        if :new.ID_POBOCKY is not null then
        select KAPACITA, OBSAD_POBOC into cekovaKapacia, obsadenostPobocky
            from POBOCKY
                where ID_POBOCKY = :new.ID_POBOCKY; end if;
        if (cekovaKapacia - obsadenostPobocky) <= 0 then raise_application_error(-20001, 'Pobocka je plna'); end if;
    end before each row;

    after statement is
    begin
        aktualizuj_obsadenost_pobocky(newId);
    end after statement ;

end kontrola_kapacity;
/


----------------------------------------------- Selekty -----------------------------------------------
-- Vypis vsetkych zvierat zadanej chovnej stanice.
select *
    from zvierata
        WHERE id_pobocky = :ID_pobocky;
undefine ID_pobocky;

-- Vypis vsetkych zamestnancov, ktori pracovali vo viac ako jednej pobocke.
select ROD_CIS, count(CISLO_ZAMES)
    from ZAMESTNANCI
        group by ROD_CIS
            having count(CISLO_ZAMES) > 1;

-- Vypis vsetkych zvierat zadaneho druhu.
SELECT * FROM
    zvierata
        WHERE plemeno = :ID_plemena;
undefine ID_plemena;

-- Vypis vsetkych zvierat, ktore nemaju potomkov.
select * from zvierata nepotomkove
    where not exists
        (select 'x' from zvierata potomkove
         where potomkove.matka = nepotomkove.id_zviera
            or potomkove.otec = nepotomkove.id_zviera ) order by ID_ZVIERA;

--Vypis vsetkych zvierat, ktore nie su cistokrvne (medzi priamymi predkami sa nachadza zviera ineho plemena).
select distinct zvieratko.id_zviera, zvieratko.matka, maminka.plemeno as plemeno_matka, zvieratko.otec, tatinko.plemeno as plemeno_otec
    from zvierata
         zvieratko join zvierata maminka
                        on (zvieratko.matka = maminka.id_zviera)
                   join zvierata tatinko
                        on (zvieratko.otec = tatinko.id_zviera)
                            where maminka.plemeno <> tatinko.plemeno;

-- Vypis surodencov (rovnakí rodicia) daneho zvierata
select sur.MENO_ZVER, sur.ID_ZVIERA, sur.MATKA, sur.OTEC, sur.PLEMENO, sur.ID_POBOCKY
    from zvierata syn join ZVIERATA sur on syn.MATKA = sur.MATKA
        where syn.ID_ZVIERA <> sur.ID_ZVIERA and syn.OTEC = sur.OTEC and syn.ID_ZVIERA = :id_zviera;

-- Vypis najlepsich dodavatelov pre dane plemeno zvierat (maju najnizsie ceny).
select ID_OSOBY, MENO, PRIEZVISKO, SPOLOCNOST, CENA
    from FIN_OPERACIE join ZAKAZNICI_DODAVATELIA using (id_osoby)
        where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n') and ID_PLEM = :id_plem
          and CENA = (select min(cena)
                        from FIN_OPERACIE
                            where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n') and ID_PLEM = :id_plem
                                group by ID_PLEM);

-- Vypis zakaznikov, ktori kupili viac ako 3 zvierata.
select ID_OSOBY, meno, PRIEZVISKO, SPOLOCNOST, count (ID_ZVIERA)
    from FIN_OPERACIE join ZAKAZNICI_DODAVATELIA using (id_osoby)
        where  TYP_OPERACIE = 'P' or TYP_OPERACIE = 'p'
            group by ID_OSOBY, meno, PRIEZVISKO, SPOLOCNOST
                having count(ID_ZVIERA) > 3
                    order by count(ID_ZVIERA) desc ;

-- Vypis vsetkych chovnych stanic, ktore maju zadane zariadenie.
SELECT * FROM pobocky
                  JOIN pobocky_zariadenia USING (id_pobocky)
                  JOIN zariadenia USING (id_zariadenia)
                        WHERE nazov_zariadenia is NOT null;

-- Vypis vsetkych zamestnancov, ktori su zaroven zakaznikmi.
SELECT * FROM fin_operacie
                  JOIN pobocky USING (id_pobocky)
                  JOIN zamestnanci zc USING (id_pobocky)
                  JOIN zakaznici_dodavatelia zd USING(id_osoby)
                    WHERE zc.meno  = zd.meno and zc.priezvisko = zd.priezvisko;

-- Vypis vsetkych chovnych stanic, ktore v sucasnosti nemaju volnu kapacitu pre dalsie zvierata.
select *
    from POBOCKY
        where KAPACITA = OBSAD_POBOC;
-------------------------------------------------------------------------------------------------------
-- naplní stlpce na správne hodnoty
begin
    aktualizuj_obsadenost_pobocky(0);
end;
/