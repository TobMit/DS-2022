-- Precvi?ovanie na test
-- 2.1.1

select *
    from student join os_udaje using (rod_cislo) join zap_predmety using (os_cislo);
    
-- 2.1.2
select meno, priezvisko
    from os_udaje join student using (rod_cislo)
        where rocnik = 2;
        
-- 2.1.3

select meno, priezvisko, rod_cislo
    from os_udaje
        where substr(rod_cislo,0,2) between 85 and 89;
        
-- 2.1.4
select meno, priezvisko
    from os_udaje
        where rod_cislo in (select rod_cislo
                            from student
                                where substr(st_skupina,2,1) = 'P');
                                
                                
-- 2.1.5
select meno, priezvisko
    from os_udaje
        where rod_cislo in (select rod_cislo
                            from student
                                where substr(st_skupina,2,1) = 'P')
            order by priezvisko;
            
-- 2.1.6            
select meno, priezvisko
    from os_udaje join student using  (rod_cislo)
        where os_cislo in (select os_cislo
                            from zap_predmety 
                                where cis_predm = 'BI06')
            order by meno;
            
-- 2.1.7
select DISTINCT prednasajuci, cis_predm
    from zap_predmety join ucitel on (prednasajuci = ucitel.os_cislo);
    
-- 2.1.8    
select DISTINCT prednasajuci, cis_predm
    from zap_predmety join ucitel on (prednasajuci = ucitel.os_cislo);    