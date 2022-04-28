-- kaskadovito zmenit hodnotu id poberatela
create or replace trigger poberatel
    before update on p_poberatel
    for each row
    begin
        update P_PRISPEVKY set ID_POBERATELA = :new.ID_POBERATELA
        where ID_POBERATELA = :OLD.ID_POBERATELA;
    end;
/

alter trigger poberatel disable ;

-- DU ID UPDATE PLATITELA!!!! --------------------------------------------------

-- vytvorit pohlad zamestnancov spoločnosti ibm
create or replace view IBM
    as select *
        from P_ZAMESTNANEC
            where ID_ZAMESTNAVATELA in (select ico
                                            from P_ZAMESTNAVATEL
                                                where NAZOV = 'IBM')
                with check option;
-- check option dedí všetky podmienky aj keď je vnorený
select * from IBM;

insert into IBM values (12345678, '920801/6642', sysdate, null, 7);
-- ak spravíme toto cez triger tak obídeme view aj keď je nastavený na read only.
rollback;

-- pohlad ktorý bude obsahovať osoby a poberateľov (* nad oboma tabuľkami)
create or replace view pohlad_poberatel
    as select *
        from P_OSOBA join P_POBERATEL using (rod_cislo);
/

-- keď dám spojenie cez on tak to nebude fungovať, lebo môžu byť rovnaké názvi premenných, using je vhodnejšie
-- nie je možné vložiť, lebo máme dve tabuľky spojené

-- napísať triger ktorí toto spojenie pre insert rozbieje do dvoch tabuliek
create or replace trigger t_viewer_osoba_poberatel
    instead of insert on pohlad_poberatel
    for each row
    declare
        pocet int;
    begin
        select count(ROD_CISLO) into pocet
            from P_OSOBA
                where ROD_CISLO = :new.ROD_CISLO;
        if pocet = 0 then
        insert into P_OSOBA
            values (:new.rod_cislo, :new.meno, :new.priezvisko, :new.psc, :new.ulica);
        end if;
        insert into P_POBERATEL
            values (:new.id_poberatela, :new.rod_cislo, :new.id_typu, :new.perc_vyj, :new.dat_od, :new.dat_do);
    end;
/

