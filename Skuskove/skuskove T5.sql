-- Vymažte všetkým ženám odvody za posledných 5 rokov. Pozor na referenčnú integritu.
select count(ROD_CISLO)
from P_OSOBA
    where substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6;
select *
    from P_ODVOD_PLATBA
        where ID_POISTENCA in (select ID_POISTENCA from P_POISTENIE
                               where (substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6)
                                 and extract(year from DAT_PLATBY) >= extract(year from sysdate) - 5);

delete
from P_ODVOD_PLATBA
where ID_POISTENCA in (select ID_POISTENCA from P_POISTENIE
                       where (substr(ROD_CISLO, 3,1) = 5 or substr(ROD_CISLO, 3,1) = 6)
                         and extract(year from DAT_PLATBY) >= extract(year from sysdate) - 5);
rollback;

-- Vložte do databázy nové odvody pre zamestnancov ŽU za tento mesiac. Hodnoty odvodov budú rovnaké ako minulý mesiac s tým, že ak osoba už ukončila pracovný pomer, nové odvody mať nebude.
select *
    from P_ODVOD_PLATBA join P_POISTENIE pois using (id_poistenca) join P_ZAMESTNAVATEL zam on  zam.ico = pois.ID_PLATITELA
        where to_char(DAT_PLATBY, 'MM.YYYY') = to_char(add_months(sysdate,-67), 'MM.YYYY') and zam.NAZOV = 'ZU';

select *
from P_ODVOD_PLATBA order by CIS_PLATBY;


insert into P_ODVOD_PLATBA (cis_platby, id_poistenca, suma, dat_platby, obdobie)
    select CIS_PLATBY, ID_POISTENCA, suma, sysdate, add_months(OBDOBIE, 1)
        from P_ODVOD_PLATBA join P_POISTENIE pois using (id_poistenca) join P_ZAMESTNAVATEL zam on  zam.ico = pois.ID_PLATITELA
            where to_char(DAT_PLATBY, 'MM.YYYY') = to_char(add_months(sysdate,-67), 'MM.YYYY') and zam.NAZOV = 'ZU'
                and pois.ROD_CISLO in (select ROD_CISLO from P_ZAMESTNANEC where DAT_OD <= sysdate and (DAT_DO >= sysdate or DAT_DO is null) );

rollback

select *
from P_ODVOD_PLATBA where DAT_PLATBY = sysdate;

select *
    from P_ODVOD_PLATBA join P_POISTENIE pois using (id_poistenca) join P_ZAMESTNAVATEL zam on  zam.ico = pois.ID_PLATITELA
        where to_char(DAT_PLATBY, 'MM.YYYY') = to_char(add_months(sysdate,-67), 'MM.YYYY') and zam.NAZOV = 'ZU'
            and pois.ROD_CISLO in (select ROD_CISLO from P_ZAMESTNANEC where DAT_OD <= sysdate and (DAT_DO >= sysdate or DAT_DO is null) );
