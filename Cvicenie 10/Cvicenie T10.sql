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

