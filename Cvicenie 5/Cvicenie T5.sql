-- 5.4.1
select meno,priezvisko
    from p_osoba
        where substr(rod_cislo,3,1) BETWEEN 5 and 6;
        
-- 5.4.2
select meno, priezvisko
    from p_osoba
        where substr(rod_cislo, 3,2) = extract(month from sysdate) or substr(rod_cislo, 3,2) = (extract(month from sysdate) + 50);
        
        