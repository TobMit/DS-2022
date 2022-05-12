-- 7.2.1
select count(ID_ZAMESTNAVATELA)
    from P_ZAMESTNANEC join P_ZAMESTNAVATEL on ID_ZAMESTNAVATELA = ico
        where NAZOV = 'Tesco'
            group by ID_ZAMESTNAVATELA;

-- 7.2.3 Vypiste menny zoznam osôb koté sú oslobodené a nepoberajú prispevok
select meno, PRIEZVISKO
    from P_OSOBA join P_POISTENIE using (rod_cislo)
        where (OSLOBODENY = 'A' or OSLOBODENY = 'a')
        and ROD_CISLO not in (select ROD_CISLO from P_POBERATEL);

-- 7.2.4 Ku každej osobe vypíšte koľko zaplatila minulý kalendárny rok
select osob.MENO, osob.PRIEZVISKO, count(CIS_PLATBY)
    from P_OSOBA osob join P_POISTENIE pois on osob.ROD_CISLO = pois.ROD_CISLO left join P_ODVOD_PLATBA plad on pois.ID_POISTENCA = plad.ID_POISTENCA
        group by MENO, PRIEZVISKO;

-- 7.2.5 Ku každému človku vypíšete aj meno jeho menovca
select osob.meno, osob.priezvisko, men.meno, men.priezvisko
    from P_OSOBA osob join P_OSOBA men on osob.meno = men.meno;

-- 7.2.6 osoby ktoré poberajú viac príspevkov
select meno, PRIEZVISKO
    from P_OSOBA join P_POBERATEL using (rod_cislo)
        group by meno, PRIEZVISKO
            having count(ID_TYPU) > 1;

-- 7.2.7 menny zoznam a aj typy príspevkov
select distinct meno, PRIEZVISKO, ID_TYPU as typ
    from P_OSOBA join P_POBERATEL using (rod_cislo)
        group by ID_TYPU, PRIEZVISKO, meno;

-- View - prehľad s informáciami o všetkých zamestnancoch ktorí bývajú na ulici 'KarpatskáƉ
create or replace view ulKarpatska
as select *
    from P_OSOBA join P_ZAMESTNANEC using(rod_cislo)
        where ULICA like '%Karpatska%';

select * from ulKarpatska;

-- Vytvorte procedúru, po zadaná rod_cisla, dat_od a dat_do, ktorá vypíše sumu, ktorú osoba zinkasovala za príspevky
create or replace procedure p_suma_poberatel(rodCislo P_POBERATEL.rod_cislo%type, datOd date, datDo date)
is
    scitane number;
begin
    select sum(suma) into scitane
        from P_PRISPEVKY join P_POBERATEL using (id_poberatela)
            where ROD_CISLO = rodCislo and KEDY >= datOd and kedy <= datDo;
    DBMS_OUTPUT.PUT_LINE(scitane);-------------------------------------------------------
end;


SET SERVEROUTPUT ON

-- teoreticka otázka
SELECT meno, priezvisko, COUNT (*)
    FROM p_osoba JOIN p_poistenie USING (rod_cislo)
       JOIN p_odvod_platba USING (id_poistenca)
            group by meno, priezvisko, CIS_PLATBY;

-- zoznam poberateľov, ktorí dostali všetky svoje príspevky viac ako 500 eur
select distinct ID_POBERATELA, ROD_CISLO
    from P_POBERATEL join P_PRISPEVKY using (id_poberatela)
        group by ID_POBERATELA, ROD_CISLO
            having min(SUMA)> 500;

-- vypíšte zoznam poberateľov, ktorí nedostali príspevok menší ako 5 eur
select distinct ID_POBERATELA, ROD_CISLO
    from P_POBERATEL join P_PRISPEVKY using (id_poberatela)
        group by ID_POBERATELA, ROD_CISLO
            having min(SUMA) > 5;

-- teoreticka uloho aky prikaz vypise cislo 6 (na vyber boli rozne typy count())
CREATE TABLE tab (id integer);
insert into tab values(1);
insert into tab values(1);
insert into tab values(2);
insert into tab values(null);
insert into tab values(3);
insert into tab values(null);

select count(*)
    from tab;

drop table tab;

-- Vytvorte Trigger, ktorý zabezpečí kaskádu príkazov na operáciu Update pri zmene id_okresu
create or replace trigger t_cascada_id_okresu
    before insert or update on P_OKRES
    for each row
    begin
        update P_MESTO set ID_OKRESU = :new.id_okresu where ID_OKRESU = :old.id_okresu;
    end;
/
drop trigger t_cascada_id_okresu;

select *
from P_OKRES;

update P_OKRES
set ID_OKRESU = 'XX'
where ID_OKRESU = 'BA';

select *
from P_MESTO order by ID_OKRESU;
rollback ;

-- Ku každému typu príspevku vypíšte jeho id, popis, zakladnú výšku príspevku a zoznam všetkých poberateľov,
-- ktorí poberajú tento typ príspevkov, aj tých ku ktorým neevidujeme žiadneho poberateľa
select distinct ID_TYPU, ZAKL_VYSKA, POPIS, nvl(ROD_CISLO, '--')
    from P_TYP_PRISPEVKU left join P_POBERATEL using (id_typu) order by ID_TYPU;

insert into P_TYP_PRISPEVKU (ID_TYPU, ZAKL_VYSKA, POPIS)
values (5, 100, 'pops');

delete
from P_TYP_PRISPEVKU
where ID_TYPU = 5;

select *
    from P_TYP_PRISPEVKU where ID_TYPU not in (select distinct ID_TYPU from P_POBERATEL);
select count(*)
from P_POBERATEL;