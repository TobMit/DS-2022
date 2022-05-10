--Ako rozbehať tento triger
-- 1. na DB create fun vypoc_obsadenost
-- 2. alter table pre novy stlpce obsad_poboc - ak uz nieje vytvoreny
-- 3. na DB create proc aktualizuj_obsadenost_pobocky, (malo by vyhodit error, to je ocakavane keď aktualizujeme celu tabulku)
-- 4. spustit blok aby sa naplnila tabulka
-- 5. na DB create trig kontrola_kapacity

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

-- naplní stlpce na správne hodnoty
begin
    aktualizuj_obsadenost_pobocky(0);
end;
/

-- Triger ktorý skontrouje či nieje prevíšena kapacita pobočky
create or replace trigger kontrola_kapacity
    for insert or update on ZVIERATA
    compound trigger
        cekovaKapacia integer;
        obsadenostPobocky integer;
        newId integer := :new.ID_POBOCKY;

    before each row is
    begin
        select KAPACITA, OBSAD_POBOC into cekovaKapacia, obsadenostPobocky
            from POBOCKY
                where ID_POBOCKY = :new.ID_POBOCKY;
        if (cekovaKapacia - obsadenostPobocky) <= 0 then raise_application_error(-20001, 'Pobocka je plna'); end if;
    end before each row;

    after statement is
    begin
        aktualizuj_obsadenost_pobocky(newId);
    end after statement ;

end kontrola_kapacity;
/


-- testy či to funguje
select *
    from ZVIERATA
        where ID_ZVIERA = 1;

select *
from POBOCKY
    where OBSAD_POBOC = KAPACITA;

-- 70 je plná
update ZVIERATA
    set ID_POBOCKY = 70
        where ID_ZVIERA = 1;

select ID_POBOCKY, KAPACITA, nvl(vypoc_obsadenost(ID_POBOCKY),0) as obsadenost, psc, adresa, mesto, obsad_poboc
    from POBOCKY
        where OBSAD_POBOC = KAPACITA;
rollback ;
commit ;


-------------------------------------------------------------------------------
-- Výpis najlepších dodávateľov pre dané plemeno zvierat (majú najnižšie ceny).

select ID_OSOBY, MENO, PRIEZVISKO, SPOLOCNOST, CENA
    from FIN_OPERACIE join ZAKAZNICI_DODAVATELIA using (id_osoby)
        where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n') and ID_PLEM = :id_plem
                and CENA = (select min(cena)
                               from FIN_OPERACIE
                               where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n') and ID_PLEM = :id_plem
                               group by ID_PLEM);

-- Výpis všetkých chovných staníc, ktoré v súčasnosti nemajú voľnú kapacitu pre ďalšie zvieratá.
select *
    from POBOCKY
        where KAPACITA = OBSAD_POBOC;

-- Výpis zákazníkov, ktorí kúpili viac ako 3 zvieratá.
select ID_OSOBY, meno, PRIEZVISKO, SPOLOCNOST, count (ID_ZVIERA)
    from FIN_OPERACIE join ZAKAZNICI_DODAVATELIA using (id_osoby)
        where  TYP_OPERACIE = 'P' or TYP_OPERACIE = 'p'
        group by ID_OSOBY, meno, PRIEZVISKO, SPOLOCNOST
            having count(ID_ZVIERA) > 3
                order by count(ID_ZVIERA) desc ;

----------------------------------------------------------------------------
select *
from FIN_OPERACIE
    where ID_OSOBY = 15 and (TYP_OPERACIE = 'P' or TYP_OPERACIE = 'p') and ID_ZVIERA is not null order by DATUM;
----------------------------------------------------------------------------

select ID_PLEM, min(cena)
from FIN_OPERACIE
where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n')
group by ID_PLEM
order by ID_PLEM;

select count(*)
    from FIN_OPERACIE
        where ID_PLEM = 1;

drop table fin_operacie;
drop table zakaznici_dodavatelia;
drop table zamestnanci;
drop table pobocky_zariadenia;
drop table zariadenia;
drop table zvierata;
drop table pobocky;
drop table plemena;
