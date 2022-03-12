-- vypise os cislo studenta ktory ma predmet s 3 a
select student.os_cislo
    from student join zap_predmety 
        on (student.os_cislo = zap_predmety.os_cislo) 
            join predmet using (cis_predm)
                where nazov like '%a%a%a' or nazov like 'A%a%a%'; -- preto lebo prve pismeno bolo velke
                
                
-- vypise os cislo studenta ktory ma predmet s 3 a
-- potlacenie duplicit cez distinct
select distinct student.os_cislo
    from student join zap_predmety 
        on (student.os_cislo = zap_predmety.os_cislo) 
            join predmet using (cis_predm)
                where nazov like '%a%a%a' or nazov like 'A%a%a%'; -- preto lebo prve pismeno bolo velke
                
-- vypise os cislo studenta ktory ma predmet s 3 a
-- potlacenie duplicit inak ako cez distinct
select student.os_cislo
    from student st
        where st.os_cislo in (
            select * from zap_predmety join predmet on (zap_predmety.cis_predm = predmet.cis_predm)
              where predmet.nazov like '%a%a%a' or predmet.nazov like 'A%a%a%';  
              

-- vypise os cislo studenta ktory ma predmet s 3 a
-- potlacenie duplicit inak ako cez exist
select os_cislo
    from student 
        where exists 
        (select 'x'
            from zap_predmety
             join predmet using (cis_predm)
              where predmet.nazov like '%a%a%a' or predmet.nazov like 'A%a%a%'
                and student.os_cislo = zap_predmety.os_cislo);
                
 
 
                
select meno, priezvisko, rod_cislo
    from kvete3.p_osoba join kvet3.p_mesto  mesto_nar on (mesto_nar.psc = p_osoba.narod_psc)
        join kvet3.p_mesto  mesto_bydliska on (mesto_bydliska = p_osoba.aktualne_psc)
            where mesto_nar.n_mesta = mesto_bydliska.n_mesta;
    
    
desc kvet3.p_mesto;

-- vlozit nove udaje
insert into os_udaje (rod_cislo, meno, priezvisko, ulica, psc, obec)
    values ('010517/1435', 'Jozef', 'Dolny', 'Nahodna','05361', 'Kosice');
  
  
insert into os_udaje (rod_cislo, meno, priezvisko)
    values ('010417/1435', 'Jozef', 'Vlozeny');            


--
insert into os_udaje (rod_cislo, psc, meno, priezvisko, obec)
    select  rod_cislo, aktualne_psc, meno, priezvisko, p_mesto.n_mesta
        from kvet3.p_osoba 
         join kvet3.p_mesto on (p_osoba.aktualne_psc = p_mesto.psc)
            where kvet3.p_osoba.rod_cislo not in (select rod_cislo form os_udaje);
            
            
select count(rod_cislo)
    from os_udaje;
    
update student
    set ukoncenie = sysdate
        where ukoncenie is null;
        
-- zmen hodnotu rodneho cisla
insert into os_udaje (rod_cislo, meno, priezvisko)
    select '841107/3456', meno, priezvisko 
        from os_udaje
            where rod_cislo  = '841106/3456';
    
update student
 set rod_cislo='841107/3456'
    where rod_cislo='841106/3456';

delete 
    from os_udaje
        where rod_cislo = '841106/3456';
        
select * 
    from zap_predmety;     
-- Aktualizacia cisla predmetu, kedze sa na to nieco ukazuje tak to nemozem spravit priamo na dokoncenie

--

select * 
    from st_odbory 
      where popis_odboru = 'Informatika' and popis_zamerania is NULL;
     
select *
    from predmet_bod
        where cis_predm = 'BI11' ;
        
select *
    from os_udaje
        where priezvisko = 'Novy';

-- priprave pre ulohy
select *
    from predmet_bod
        where cis_predm = 'II07' ;

desc zap_predmety;
-- uloha 3.1.1

insert into os_udaje (rod_cislo, meno, priezvisko)
    values ('830722/6247','Karol','Novy');
    
commit;

insert into student (ROD_CISLO, OS_CISLO, ROCNIK, ST_SKUPINA, ST_ODBOR, ST_ZAMERANIE)
    values ('830722/6247', '123', '1', '5ZI012' ,'100' , '0');
    
commit;

insert into zap_predmety ( os_cislo, cis_predm, skrok, prednasajuci, ects)
    values ('123', 'BE01', '2008','EX002','1');

-- uloha 3.1.2
insert into os_udaje(rod_cislo, meno, priezvisko)
    select rod_cislo, meno, priezvisko 
        from kvet3.osoba;
commit;
insert into student(rod_cislo, os_cislo, rocnik, st_skupina,st_odbor, st_zameranie)
    select rod_cislo, os_cislo, rocnik, st_skupina, st_odbor, st_zameranie
        from kvet3.osoba;
commit;

insert into zap_predmety(os_cislo, cis_predm, skrok, prednasajuci, ects)
    select os_cislo, cis_predm, skrok, garant, ects
        from kvet3.skusky sk join predmet_bod using(cis_predm,skrok);
    
commit;
		
---- Update ----
 
 -------------------------------------------------------------------------------
select *
    from os_udaje join student using (rod_cislo)
        where student.os_cislo = '8';

select *
    from zap_predmety join student using (os_cislo)
        where cis_predm = 'BI11' 
        and rocnik = 1;  
        
select *
    from student
         where (st_odbor between 100 and 199) and rocnik < 3 
            or (st_odbor between 200 and 299) and rocnik < 2;

desc os_udaje;

ROLLBACk;


----------------------------------------------------------------------------
            
-- Uloha 3.2.1
update os_udaje set priezvisko = 'Stary' 
    where priezvisko = 'Novy';
            commit;
-- Uloha 3.2.2
            
update os_udaje set meno = 'Karolina' 
    WHERE rod_cislo in (select rod_cislo 
                    from student where os_cislo = '8');
commit; 


-- Uloha 3.2.3.

update zap_predmety set cis_predm = 'BI01' 
WHERE os_cislo in (select os_cislo from student
        where cis_predm = 'BI11' 
        and rocnik = 1);

-- Uloha 3.2.4.
update student set stav = 'S' 
    where stav is NULL;
            
            
-- Uloha 3.2.5.

update student set rocnik = (rocnik + 1), 
				   	  st_skupina = (substr(st_skupina, 0,4) || (substr(st_skupina, 5,1) + 1 ||
												(substr(st_skupina, 6,1))))
 where (st_odbor between 100 and 199) and rocnik < 3 
	or (st_odbor between 200 and 299) and rocnik < 2;
										    
										    
------ Delete  ------
select *
    from zap_predmety
         where os_cislo = '123';
         
select *
    from zap_predmety join student using (os_cislo)
         where cis_predm = 'BI01' and st_skupina = '5ZI022';

-- Uloha 3.3.1
delete from zap_predmety
        where os_cislo = '123' 
            and cis_predm = 'BE01';
            
-- Uloha 3.3.2

delete from zap_predmety
    where cis_predm = 'BI01' 
        and os_cislo in (select os_cislo
                                from student 
                                    where st_skupina = '5ZI022');
commit;