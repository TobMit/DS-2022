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

-- zapis predmet jazyk C++ studentovi
select *
    from predmet_bod
        where cis_predm = 'BI30';

insert into zap_predmety (os_cislo, cis_predm, skrok, prednasajuci, ects)
    values (123456, 'BI30', 2022, 'KI003', 5); 
    
-- odstranenie toho co sme zapisali
delete zap_predmety
    where os_cislo = 123456
        and cis_predm = 'BI30'
        and skrok = 2022;
        
delete from student
    where os_cislo = 123456;
    
delete from os_udaje
    where rod_cislo = '123456/1234' ;
rollback;


-- ukazka novych prikazov
create table tmp_table (
    id int,
    datum date
    );
    
    
create table tmp_table2
    as select os_cislo, sysdate as datum from student;

select * 
    from tmp_table2;
    
    
-- uprava existujucej tabulkz
alter table tmp_table2
    add a VARCHAR2(10);
    
-- odstranenie tabuly z databazy

drop table tmp_table2;