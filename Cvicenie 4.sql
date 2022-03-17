-- Cvicenie 3
-- Zapisat fx vsetkym studentom kotri nemaju znamku z predmetu 
select *
    from predmet;
    
desc zap_predmety;
    
update zap_predmety
    set vysledok = 'F', datum_sk = sysdate
        where vysledok is null and cis_predm = 'BA10';
ROLLBACK;

-- odstranenie vsetky studentov ktori nemaju ziaden predmet
delete student
    where student.os_cislo not in (
        select os_cislo
            from zap_predmety);
            
-- vlozim sameho seba do tabulky
insert into os_udaje (rod_cislo, meno,priezvisko)
    values ('123456/1234','Janko','Hruska');
    
-- zapisat studenta do strudenta
desc student;

select *
    from st_odbory;

insert into student (os_cislo, st_odbor, st_zameranie, rod_cislo, rocnik, st_skupina)
    VALUES (123456, 100, 0, '123456/1234', 2, '5ZYI23');
    
ROLLBACK;