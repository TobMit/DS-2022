-- DU ID UPDATE PLATITELA
-- update p_osoba
-- update p_poistenie
-- update p_poberatel
-- update p_ztp
-- update p_zamestnanec

create or replace trigger update_id_platitela
    before update on P_PLATITEL
    for each row
    declare
        pocet_ztp int;
        pocet_poberatel int;
        pocet_pistenie int;
        pocet_poistenie2 int;
        pocet_zamestnanec int;
        pocet_posoba int;
    begin
        select count(ROD_CISLO) into pocet_ztp
            from P_ZTP where ROD_CISLO = :old.ID_PLATITELA;

        select count(ROD_CISLO) into pocet_poberatel
            from P_POBERATEL where ROD_CISLO = :old.ID_PLATITELA;

        select count(ROD_CISLO) into pocet_pistenie
            from P_POISTENIE where ID_PLATITELA = :old.ID_PLATITELA;

        select count(ROD_CISLO) into pocet_poistenie2
            from P_POISTENIE where ROD_CISLO = :old.ID_PLATITELA;

        select count(ROD_CISLO) into pocet_zamestnanec
            from P_ZAMESTNANEC where ROD_CISLO = :old.ID_PLATITELA;

        select count(ROD_CISLO) into pocet_posoba
            from P_OSOBA where ROD_CISLO = :old.ID_PLATITELA;

        if pocet_ztp > 0 then
        update P_ZTP set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        end if;

        if pocet_poberatel > 0 then
        update P_POBERATEL set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        end if;

        if pocet_pistenie > 0 then
        update P_POISTENIE set ID_PLATITELA = :new.ID_PLATITELA
            where ID_PLATITELA = :OLD.ID_PLATITELA;
        end if;

        if pocet_poistenie2 > 0 then
        update P_POISTENIE set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        end if;

        if pocet_zamestnanec > 0 then
        update P_ZAMESTNANEC set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        end if;

        if pocet_posoba > 0 then
        update P_OSOBA set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        end if;
    end;
/


update P_PLATITEL set ID_PLATITELA = '545614/1234'
    where ID_PLATITELA = '545614/0001';
--------------------------------------------------------------
select *
    from P_OSOBA
        where ROD_CISLO = '545614/1234';
select *
    from P_PLATITEL;
select *
    from P_POISTENIE;
