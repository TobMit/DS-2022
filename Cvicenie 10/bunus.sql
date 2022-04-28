-- DU ID UPDATE PLATITELA
-- update p_osoba
-- update p_poistenie
-- update p_poberatel
-- update p_ztp
-- update p_zamestnanec

create or replace trigger update_id_platitela
    before update on P_PLATITEL
    for each row
    begin

        update P_ZTP set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        update P_POBERATEL set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        update P_POISTENIE set ID_PLATITELA = :new.ID_PLATITELA
            where ID_PLATITELA = :OLD.ID_PLATITELA;
        update P_POISTENIE set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        update P_ZAMESTNANEC set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
        update P_OSOBA set ROD_CISLO = :new.ID_PLATITELA
            where ROD_CISLO = :OLD.ID_PLATITELA;
    end;
/


update P_PLATITEL set ID_PLATITELA = '545614/1234'
    where ID_PLATITELA = '545614/0001';
--------------------------------------------------------------
select *
    from P_OSOBA
        where ROD_CISLO = '545614/0001';
select *
from P_PLATITEL;
select *
from P_POISTENIE;
