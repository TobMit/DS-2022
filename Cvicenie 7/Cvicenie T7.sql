select *
    from MITALA1.STUDENT;

-- vypísať ku kažému zamestnávatelovi počet zamestnancov
select count(*), ico, NAZOV
    from P_ZAMESTNAVATEL join P_ZAMESTNANEC on (ico = ID_ZAMESTNAVATELA)
        group by ico, NAZOV;

-- upravit tak aby som tam mal naozaj vsetkych
select count(ROD_CISLO), ico, NAZOV
    from P_ZAMESTNAVATEL left join P_ZAMESTNANEC on (ico = ID_ZAMESTNAVATELA)
        group by ico, NAZOV;

-- vypisat len zamestnavatelov ktory maju len 10 zamestnancov
select count(ROD_CISLO), ico, NAZOV
    from P_ZAMESTNAVATEL left join P_ZAMESTNANEC on (ico = ID_ZAMESTNAVATELA)
        group by ico, NAZOV
            having count(ROD_CISLO) >= 2;
-- zamestnavatel kotrý ma najviac zamestnancov
select count(ROD_CISLO), ico, NAZOV
    from P_ZAMESTNAVATEL left join P_ZAMESTNANEC on (ico = ID_ZAMESTNAVATELA)
        group by ico, NAZOV
            having (select max(count(ROD_CISLO))
                 from P_ZAMESTNANEC
                    group by id_zamestnavatela
       ) = count(ROD_CISLO);

-- ku kazdej osobe kolko dostala odvodov podla roku
select sum(suma), to_char(obdobie,'YYYY'), rod_cislo
    from P_ODVOD_PLATBA join P_POISTENIE using (id_poistenca) join P_OSOBA using (rod_cislo)
        group by to_char(obdobie,'YYYY'), rod_cislo;

-- cez poberatela a prispevky
select sum(suma), to_char(obdobie,'YYYY'), rod_cislo
    from P_PRISPEVKY join P_POBERATEL using (id_poberatela) join P_OSOBA using (rod_cislo)
        group by to_char(obdobie,'YYYY'), rod_cislo;

-- ci dana osoba dostala viac od socialnej poistovne alebo mala vecie odvoddy
select sum(suma), to_char(obdobie,'YYYY') as obdobie, rod_cislo
    from P_ODVOD_PLATBA join P_POISTENIE using (id_poistenca) join P_OSOBA using (rod_cislo)
        group by to_char(obdobie,'YYYY'), rod_cislo
    union
        select sum(suma), to_char(obdobie,'YYYY') as obodobie, rod_cislo
            from P_PRISPEVKY join P_POBERATEL using (id_poberatela) join P_OSOBA using (rod_cislo)
                group by to_char(obdobie,'YYYY'), rod_cislo;

-- celkova suma
-- ku kazdej osobe kolko dostala odvodov podla roku
select rod_cislo, rok, sum (celkova_suma)
    from (
         select -sum(suma) as celkova_suma, to_char(obdobie,'YYYY') as rok, rod_cislo
            from P_ODVOD_PLATBA join P_POISTENIE using (id_poistenca) join P_OSOBA using (rod_cislo)
                group by to_char(obdobie,'YYYY'), rod_cislo
         union
            select sum(suma), to_char(obdobie,'YYYY') as rok, rod_cislo
                 from P_PRISPEVKY join P_POBERATEL using (id_poberatela) join P_OSOBA using (rod_cislo)
                    group by to_char(obdobie,'YYYY'), rod_cislo
         )
            GROUP BY rod_cislo, rok;