-- 7.2.1
select count(ID_ZAMESTNAVATELA)
    from P_ZAMESTNANEC join P_ZAMESTNAVATEL on ID_ZAMESTNAVATELA = ico
        where NAZOV = 'Tesco'
            group by ID_ZAMESTNAVATELA;

-- 7.2.3 Vypiste menny zoznam osôb koté sú oslobodené a nepoberajú prispevok
select meno, PRIEZVISKO
    from P_OSOBA join P_POISTENIE using (rod_cislo)
        where (OSLOBODENY = 'A' or OSLOBODENY = 'a')
        and ROD_CISLO not in (select ROD_CISLO from P_POBERATEL);

-- 7.2.4 Ku každej osobe vypíšte koľko zaplatila minulý kalendárny rok
select osob.MENO, osob.PRIEZVISKO, count(CIS_PLATBY)
    from P_OSOBA osob join P_POISTENIE pois on osob.ROD_CISLO = pois.ROD_CISLO left join P_ODVOD_PLATBA plad on pois.ID_POISTENCA = plad.ID_POISTENCA
        group by MENO, PRIEZVISKO;

-- 7.2.5 Ku každému človku vypíšete aj meno jeho menovca
select osob.meno, osob.priezvisko, men.meno, men.priezvisko
    from P_OSOBA osob join P_OSOBA men on osob.meno = men.meno;

-- 7.2.6 osoby ktoré poberajú viac príspevkov
select meno, PRIEZVISKO
    from P_OSOBA join P_POBERATEL using (rod_cislo)
        group by meno, PRIEZVISKO
            having count(ID_TYPU) > 1;

-- 7.2.7 menny zoznam a aj typy príspevkov
select distinct meno, PRIEZVISKO, ID_TYPU as typ
    from P_OSOBA join P_POBERATEL using (rod_cislo)
        group by ID_TYPU, PRIEZVISKO, meno;

--