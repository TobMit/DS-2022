-- Vymažte všetkým ženám odvody za posledných 5 rokov. Pozor na referenčnú integritu.
select count(ROD_CISLO)
from P_OSOBA
    where substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6;
select *
    from P_ODVOD_PLATBA
        where ID_POISTENCA in (select ID_POISTENCA from P_POISTENIE
                               where (substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6)
                                 and extract(year from DAT_PLATBY) >= extract(year from sysdate) - 5);

delete
from P_ODVOD_PLATBA
where ID_POISTENCA in (select ID_POISTENCA from P_POISTENIE
                       where (substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6)
                         and extract(year from DAT_PLATBY) >= extract(year from sysdate) - 5);
rollback;

-- Vložte do databázy nové odvody pre zamestnancov ŽU za tento mesiac. Hodnoty odvodov budú rovnaké ako minulý mesiac s tým, že ak osoba už ukončila pracovný pomer, nové odvody mať nebude.
select *
    from P_ODVOD_PLATBA join P_POISTENIE pois using (id_poistenca) join P_ZAMESTNAVATEL zam on  zam.ico = pois.ID_PLATITELA
        where to_char(DAT_PLATBY, 'MM.YYYY') = to_char(add_months(sysdate,-67), 'MM.YYYY') and zam.NAZOV = 'ZU';

select *
from P_ODVOD_PLATBA order by CIS_PLATBY;


insert into P_ODVOD_PLATBA (cis_platby, id_poistenca, suma, dat_platby, obdobie)
    select CIS_PLATBY, ID_POISTENCA, suma, sysdate, add_months(OBDOBIE, 1)
        from P_ODVOD_PLATBA join P_POISTENIE pois using (id_poistenca) join P_ZAMESTNAVATEL zam on  zam.ico = pois.ID_PLATITELA
            where to_char(DAT_PLATBY, 'MM.YYYY') = to_char(add_months(sysdate,-67), 'MM.YYYY') and zam.NAZOV = 'ZU'
                and pois.ROD_CISLO in (select ROD_CISLO from P_ZAMESTNANEC where DAT_OD <= sysdate and (DAT_DO >= sysdate or DAT_DO is null) );

rollback

select *
from P_ODVOD_PLATBA where DAT_PLATBY = sysdate;

select *
    from P_ODVOD_PLATBA join P_POISTENIE pois using (id_poistenca) join P_ZAMESTNAVATEL zam on  zam.ico = pois.ID_PLATITELA
        where to_char(DAT_PLATBY, 'MM.YYYY') = to_char(add_months(sysdate,-67), 'MM.YYYY') and zam.NAZOV = 'ZU'
            and pois.ROD_CISLO in (select ROD_CISLO from P_ZAMESTNANEC where DAT_OD <= sysdate and (DAT_DO >= sysdate or DAT_DO is null) );

-- aký bude výsledok selectu ak použijeme tieto príkazy
create table randomTAbula (
    hodnota integer not null,
    primary key (hodnota)
);

insert into randomTAbula values (1);
insert into randomTAbula values (2);
alter table randomTAbula add (pocet integer);
rollback ;
insert into randomTAbula values (3,4);
select count(*) from randomTAbula;
select *
from randomTAbula;

drop table randomTAbula;

-- Doplňte select, ktorý má vypísať pre každú osobu jej rodné číslo, meno, priezvisko a koľkokrát bola osobou ZŤP.
SELECT rod_cislo, meno, priezvisko, COUNT(*)
    FROM p_osoba JOIN p_ZTP USING(rod_cislo)
        group by rod_cislo, meno, priezvisko order by ROD_CISLO;

-- Vytvorte trigger, ktorý znemožní skončenie pracovného pomeru zamestnanca, ktorý mal za posledný polrok evidované aspoň jedno ZŤP.
create or replace trigger zamestnanecZTP
    before insert or update on P_ZAMESTNANEC
    for each row
    declare
        pocet integer;
    begin
        select count(ID_ZTP) into pocet
            from P_ZTP
                where P_ZTP.DAT_OD >= add_months(sysdate, -6) and P_ZTP.ROD_CISLO = :NEW.ROD_CISLO
                    group by P_ZTP.ROD_CISLO;
        if pocet > 0 then raise_application_error(-20001, 'Nemozno vyhodit zamestnanca');
        end if;
    end;
/
drop trigger zamestnanecZTP;

-- Osloboďte od platenia poistného všetkých zamestnancov firiem sídliacich na Slovensku, ktorí majú aktuálne menej ako 5 zamestnancov, príp. Žiadneho.
update P_POISTENIE
set OSLOBODENY = 'A'
where ID_POISTENCA in (select ID_POISTENCA
                       from P_ZAMESTNANEC
                                     join P_ZAMESTNAVATEL PZ on PZ.ICO = P_ZAMESTNANEC.ID_ZAMESTNAVATELA
                                         where ico in (select ICO
                                                            from P_ZAMESTNAVATEL join P_MESTO on P_ZAMESTNAVATEL.PSC = P_MESTO.PSC
                                                                  join P_MESTO PM on PM.PSC = P_ZAMESTNAVATEL.PSC
                                                                  join P_OKRES PO on PO.ID_OKRESU = P_MESTO.ID_OKRESU
                                                                  join P_KRAJ PK on PK.ID_KRAJA = PO.ID_KRAJA
                                                                  join P_KRAJINA P on P.ID_KRAJINY = PK.ID_KRAJINY
                                                                  join P_ZAMESTNANEC Z on P_ZAMESTNAVATEL.ICO = Z.ID_ZAMESTNAVATELA
                                                                    where p.N_KRAJINY = 'Slovensko'
                                                                    group by ICO
                                                                    having count(ico) < 5));

rollback;
-- Vypíšte zoznam poberateľov, ktorých príspevky boli priemerne nad 20€.
select ID_POBERATELA, ROD_CISLO, avg(suma)
    from P_POBERATEL join P_PRISPEVKY using (id_poberatela)
        group by ID_POBERATELA, ROD_CISLO
            having avg(suma) >= 20
                order by avg(suma) ;

-- Ku každému typu príspevku vypíšte jeho ID, popis, základnú výšku a zoznam jeho histórie.
-- Vypíšte aj tie typy príspevkov, ku ktorým neevidujeme žiadny historický záznam.

select ID_TYPU, POPIS, prispev.ZAKL_VYSKA, dat_od, DAT_DO, his.ZAKL_VYSKA
    from P_TYP_PRISPEVKU prispev left join P_HISTORIA his using (id_typu);

--Vypíšte zoznam osôb, ktoré nedostávajú viac ako 300€ mesačne. Pokryte aj prípad, že osoba nedostáva žiadne príspevky.
select meno, PRIEZVISKO, ROD_CISLO, max(suma)
    from P_OSOBA left join P_POBERATEL using(rod_cislo)
                 left join P_PRISPEVKY using(id_poberatela)
                    group by ROD_CISLO, PRIEZVISKO, meno
                        having max(SUMA) <= 300;

-- napíšte skprip ktorý vytvorí nasledovné tabuľky
create table TAB_CATEGORY (
  id_category integer not null,
  name varchar2(20) null,
  primary key (id_category)
);

create table TAB_COMPONENT (
    id_componet integer not null,
    category integer not null,
    info varchar2(50) null,
    primary key (id_componet),
    foreign key (category) references TAB_CATEGORY(id_category)
);
drop table TAB_COMPONENT;
drop table TAB_CATEGORY;

-- pomocou ERA diagram citatel - kniha (vypožičanie knihy)
Kniha(#isbn, nazov, autor, vidavatelstvo)
Citatel(#id_citatela, meno, priezvisko, adresa)
kniznica(#id_kniznice, isbn(FK), id_citatela(FK), datum_vypozicania, vratenia)

kardinalita vzťahuje m:N pretože knihu môže mať požičanú iba jedn používateľ ale jeden používateľ môže mať požičanch viac kních
Nepovinnné členstvo z oboch strán

-- Majme atribút cena v tabuľke faktúra, ktorý nech má dátový typ Integer. Zabezpečte, aby hodnota nemohla byť záporná.
create or replace trigger zapornaHOdnota
    before insert or update on faktura
    for each row
    begin
        if :new.cena < 0 then raise_application_error(-20001, 'Cena nemôze byt zaporna'); end if;
    end;
/

-- vymažte všetkým ženám za posledné 2 roky odvody
delete from P_ODVOD_PLATBA
    where extract(year from DAT_PLATBY) >= extract(year from sysdate) -6
      and ID_POISTENCA in ( select ID_POISTENCA from P_POISTENIE
                                                where substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6);

rollback ;

-- triger ktorý zabráni do p_prispevky vkladať sumy záporné
create or replace trigger zapornaSuma
    before insert or update of suma on P_PRISPEVKY
    for each row
    begin
        if :new.suma < 0 then raise_application_error(-20001, 'Zaporna suma'); end if;
    end;
/

update p_prispevky set suma = -1;
drop trigger zapornaSuma;
rollback;

-- oslobodiť všetkých zamestnancov firmi ktorá je slovenská a menej ako 5 zemstnancov
update P_POISTENIE
    set OSLOBODENY = 'A'
        where ID_POISTENCA in (select ID_POISTENCA
                                    from P_ZAMESTNANEC join p_zamestnavatel on (P_ZAMESTNANEC.ID_ZAMESTNAVATELA = P_ZAMESTNAVATEL.ICO)
                                        where ico in (select ico
                                                        from P_ZAMESTNAVATEL join P_ZAMESTNANEC on (P_ZAMESTNANEC.ID_ZAMESTNAVATELA = P_ZAMESTNAVATEL.ICO)
                                                                join P_MESTO using (psc)
                                                                join P_OKRES using (id_okresu)
                                                                join p_kraj using (id_kraja)
                                                                join P_KRAJINA using (id_krajiny)
                                                        where N_KRAJINY = 'Slovensko'
                                                            group by ico
                                                                having count(ROD_CISLO) < 5));
-- koniec semestra