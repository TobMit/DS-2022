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

