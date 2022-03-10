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
    from os_udaje;
        