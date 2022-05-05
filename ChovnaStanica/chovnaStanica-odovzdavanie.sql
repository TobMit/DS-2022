-- funkcia ktorá vráti počet obsadenia chovnej stanice
create or replace function obsadenost (cis_pobocky INTEGER)
    return number
is
    obsadenos integer;
begin
    select count(ID_POBOCKY) into obsadenos
        from ZVIERATA
            where ID_POBOCKY = cis_pobocky;
    return obsadenos;
end;
/
select ID_POBOCKY, KAPACITA, nvl(obsadenost(ID_POBOCKY),0) as obsadenost, psc, adresa, mesto
    from POBOCKY;
-- triger ktory aktualizuje kapacitu




-- Triger ktorý skontrouje či nieje prevíšena kapacita pobočky
create or replace trigger kontrola_kapacity
    before insert or update on ZVIERATA
    for each row
    declare
        cekovaKapacia integer;
        obsadenostPobocky integer := obsadenost(:new.ID_POBOCKY);
    begin
        select KAPACITA into cekovaKapacia
            from POBOCKY
                where ID_POBOCKY = :new.ID_POBOCKY;
        if (cekovaKapacia - obsadenostPobocky) <= 0 then raise_application_error(-20001, 'Pobocka je plna'); end if;
    end;
/



create or replace trigger kontrola_kapacity
    for insert or update of id_pobocky on ZVIERATA
compound trigger
    cekovaKapacia integer;
    obsadenostPobocky integer;
    before statement is
        begin
            select KAPACITA into cekovaKapacia
                from POBOCKY
                    where ID_POBOCKY = :new.ID_POBOCKY;
            obsadenostPobocky := obsadenost(:new.ID_POBOCKY);
        end before statement;

    before each row is
    begin
        if (cekovaKapacia - obsadenostPobocky) <= 0 then raise_application_error(-20001, 'Pobocka je plna'); end if;
    end before each row;
end kontrola_kapacity;
/

drop trigger kontrola_kapacity;

select *
    from ZVIERATA
        order by ID_POBOCKY;

update ZVIERATA
    set ID_POBOCKY = ID_POBOCKY;
rollback ;

drop table fin_operacie;
drop table zakaznici_dodavatelia;
drop table zamestnanci;
drop table pobocky_zariadenia;
drop table zariadenia;
drop table zvierata;
drop table pobocky;
drop table plemena;
