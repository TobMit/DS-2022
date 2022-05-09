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

select ID_POBOCKY, KAPACITA, nvl(vypoc_obsadenost(ID_POBOCKY),0) as obsadenost, psc, adresa, mesto, obsad_poboc
    from POBOCKY;

-- procedúra kotrá akutualizuje kapacitu v tabulke
create or replace procedure aktualizuj_obsadenost_pobocky
    is
    begin
        update POBOCKY set POBOCKY.obsad_poboc = vypoc_obsadenost(ID_POBOCKY);
    end;
/

begin
    aktualizuj_obsadenost_pobocky();
end;
/

-- Triger ktorý skontrouje či nieje prevíšena kapacita pobočky
create or replace trigger kontrola_kapacity_insert
    for update on ZVIERATA
    compound trigger
        cekovaKapacia integer;
        obsadenostPobocky integer;

    before each row is
    begin
        select KAPACITA, OBSAD_POBOC into cekovaKapacia, obsadenostPobocky
            from POBOCKY
                where ID_POBOCKY = :new.ID_POBOCKY;
        if (cekovaKapacia - obsadenostPobocky) <= 0 then raise_application_error(-20001, 'Pobocka je plna'); end if;
    end before each row;

    after statement is
    begin
        aktualizuj_obsadenost_pobocky();
    end after statement ;

end kontrola_kapacity_insert;
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

drop table fin_operacie;
drop table zakaznici_dodavatelia;
drop table zamestnanci;
drop table pobocky_zariadenia;
drop table zariadenia;
drop table zvierata;
drop table pobocky;
drop table plemena;
