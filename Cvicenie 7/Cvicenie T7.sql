select *
    from MITALA1.STUDENT;

-- vypísať ku kažému zamestnávatelovi počet zamestnancov
select count(*), ico, NAZOV
    from P_ZAMESTNAVATEL join P_ZAMESTNANEC on (ico = ID_ZAMESTNAVATELA)
        group by ico, NAZOV;

-- upravit tak aby som tam mal naozaj vsetkych
select count(*), ico, NAZOV
    from P_ZAMESTNAVATEL left join P_ZAMESTNANEC on (ico = ID_ZAMESTNAVATELA)
        group by ico, NAZOV;
