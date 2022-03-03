
-- osoby ktor� s� �tudentami
select meno, priezvisko, ukoncenie, rocnik, case substr(st_skupina,2,1)
    when 'Z' then 'Zilina'
    when 'P' then 'Prievidza'
    when 'R' then 'Ruzomberok'
    end
 from os_udaje join student using(rod_cislo)
    where student.ukoncenie is null
    order by meno, priezvisko, substr(rod_cislo,1,2);


-- vypis mena ucitelov ktor� nem �iadny �tudent    
select priezvisko
  from ucitel 
    where not exists 
        (select 'x' from os_udaje join student using (rod_cislo)
            where ucitel.priezvisko = os_udaje.priezvisko);
            
            
select priezvisko
    from ucitel
        where priezvisko not in (
            select priezvisko from os_udaje join student using(rod_cislo));
  
  
-- predmety ktor� neboli zap�sane          
select cis_predm, nazov
    from predmet
        where cis_predm
            not in (select cis_predm From zap_predmety);
            
-- men� lud� ktor� sa narodil v decembri -> 2 podmienky

select meno, priezvisko
    from os_udaje
        where substr(rod_cislo, 3,2) = 12 or substr(rod_cislo, 3,2) = 62;
    

-- men� lud� ktor� sa narodil v decembri -> in    
select meno, priezvisko
    from os_udaje
        where substr(rod_cislo, 3,2) in (12,62);
        
-- vypis ucitelov kt.nikdy nic negarantovali

select *
    from ucitel
        where os_cislo not in (select garant from predmet_bod);
        
        
--         distinct potlaci duplicity
select distinct meno, priezvisko, nazov
    from ucitel join zap_predmety on (prednasajuci = ucitel.os_cislo) join predmet using(cis_predm)
        order by priezvisko;
        
-- Vypisat pocet druh�kov
select count(*)
    from student
        where rocnik = '2';
        
-- 1. Vypiste vsetky udaje o vsetkych studentoch

select *
    from student join os_udaje using (rod_cislo);
    
-- 2. Vyp�te menny zoznam v�etk�ch �tudentov 2. ro�n�ka.    

select meno, priezvisko
    from student join os_udaje using (rod_cislo)
        where rocnik = '2';
        
-- 3. Vypiste menny zoznam studentov narodenych v rokoch 1985-1989
select meno, priezvisko
    from os_udaje
        where substr (rod_cislo, 0,2) BETWEEN 85 and 89;
    

-- 4. Vypiste menny zooznam studentov, ktor� pracuj� na detesovanom pracovisku v prievidzy 
select meno, priezvisko
    from student join os_udaje using (rod_cislo)
        where substr(st_skupina,2,1) = 'P';

-- 5. Predch�dzaj�ci v�pis utriedte pod�a priezviska
select meno, priezvisko
    from student join os_udaje using (rod_cislo)
        where substr(st_skupina,2,1) = 'P'
            order by priezvisko;
            
-- 6. Vypiste menny zoznam studentov, ktori studuju predmet BI06  a usporiadj ich
select distinct meno, priezvisko
    from student join os_udaje using (rod_cislo) join zap_predmety using(os_cislo)
        where cis_predm = 'BI06'
            order by priezvisko;
            
-- 7. Vypiste vsetky kombinacie prednasajuci / cis_predm, ktore sa nachadzaj� v relacii zap_predmety tak, aby sa eliminovali dulik�ty
select distinct prednasajuci, cis_predm
    from ucitel join zap_predmety on (prednasajuci = ucitel.os_cislo) join predmet using(cis_predm);

        
-- 8. K predchadjajucemu vypisu doplne meno ucitela a nazov predmetu.
select distinct prednasajuci, cis_predm, meno,predmet.nazov
    from ucitel join zap_predmety on (prednasajuci = ucitel.os_cislo) join predmet using(cis_predm);
    
-- 9. Vypiste mena ucitelov, ktori ucia (s� prednasajucimi) studentov druheho rocnika bakalarskeho studia (t.j. cislo studijneho odbou je z intevalu <100,99>)
select distinct ucitel.meno, ucitel.priezvisko
    from ucitel join zap_predmety on (prednasajuci = ucitel.os_cislo) join student on (zap_predmety. os_cislo = student.os_cislo)
        where st_odbor BETWEEN 100 and 199;

