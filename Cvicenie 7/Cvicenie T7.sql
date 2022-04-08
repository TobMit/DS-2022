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

-- 7.1.1
select max(substr(extract(year from ukoncenie), 3) - substr(rod_cislo, 1, 2) + 100) as najstarsi_Ukoncenie
from STUDENT;

-- 7.1.2 -- vyťiahnutie mesiaca
select meno, PRIEZVISKO, ROD_CISLO
    from OS_UDAJE
        where (case substr(ROD_CISLO, 3,2) when '51' then '11' when '52' then '12'  else substr(ROD_CISLO, 3,2 )end) = (extract(month from sysdate) + 1)
-- 7.1.3
select min(znamka),max(znamka), count(os_cislo), CIS_PREDM
    from (
         select (case VYSLEDOK when 'A' then 1 when 'B' then 1.5 when 'C' then 2 when 'D' then 2.5 when 'E' then 3 when 'F' then 4 when null then 4 end) as znamka,  CIS_PREDM, OS_CISLO
                from ZAP_PREDMETY)
        group by CIS_PREDM;

-- 7.1.4
select MENO, PRIEZVISKO, avg(case VYSLEDOK when 'A' then 1 when 'B' then 1.5 when 'C' then 2 when 'D' then 2.5 when 'E' then 3 when 'F' then 4 when null then 4 end) as priemer , OS_CISLO
from OS_UDAJE join STUDENT using (rod_cislo) join ZAP_PREDMETY using (os_cislo)
        group by os_cislo, MENO, PRIEZVISKO;

select count(distinct os_Cislo)
    from ZAP_PREDMETY;

-- 7.1.5
select NAZOV
    from PREDMET join ZAP_PREDMETY using (cis_predm)
        where SKROK = 2006
        group by CIS_PREDM, NAZOV
            having count(CIS_PREDM) > 4;

-- 7.1.6
select distinct MENO, PRIEZVISKO
    from OS_UDAJE join STUDENT S on (OS_UDAJE.ROD_CISLO = S.ROD_CISLO)
        join ZAP_PREDMETY using (os_cislo)
            group by SKROK, os_cislo, MENO, PRIEZVISKO
                having count(SKROK) > 1;

-- 7.1.7
select MENO, PRIEZVISKO, count(CIS_PREDM)
    from OS_UDAJE join STUDENT S on (OS_UDAJE.ROD_CISLO = S.ROD_CISLO)
              join ZAP_PREDMETY using (os_cislo)
                where SKROK = 2006
                    group by MENO, PRIEZVISKO;

-- 7.1.8
select CIS_PREDM
    from ST_PROGRAM
        where SKROK = 2006 and not exists(select 'x'
                                            from ZAP_PREDMETY
                                                where skrok = 2006
                                                and ST_PROGRAM.CIS_PREDM = ZAP_PREDMETY.CIS_PREDM);

select CIS_PREDM
from ST_PROGRAM
where SKROK = 2006 and CIS_PREDM not in (select cis_predm
                                  from ZAP_PREDMETY
                                  where skrok = 2006);

-- 7.1.9 -- císla my zam vychádzajú zaporne, zrejme to je naprd nahraté v databaze, kedze zápocet sa konal neskôr ako skúska
select CIS_PREDM,to_char(ZAPOCET, 'DD-MM-YYYY') as zapocet, to_char(DATUM_SK, 'DD-MM-YYYY') as skuska, DATUM_SK - ZAPOCET as pocet_dni
    from ZAP_PREDMETY
        where ZAPOCET is not null and DATUM_SK is not null;

-- 7.1.10 -- podmienku mesiada dávam opacne aby mi aspon nieco vyhodilo, kedze majú zle nahraté dátumi alebo sa to musím opýtať
select CIS_PREDM,to_char(ZAPOCET, 'DD-MM-YYYY') as zapocet, to_char(DATUM_SK, 'DD-MM-YYYY') as skuska, DATUM_SK - ZAPOCET as pocet_dni
    from ZAP_PREDMETY
        where ZAPOCET is not null and DATUM_SK is not null and ((extract(month from ZAPOCET) + 1) <= extract(month from DATUM_SK));
-- 7.1.11
select meno, PRIEZVISKO
    from OS_UDAJE
        where ROD_CISLO not in (select ROD_CISLO
                                from STUDENT join ZAP_PREDMETY using (os_cislo)
                                    group by SKROK, os_cislo, ROD_CISLO
                                        having count(SKROK) > 1);

-- 7.1.12a
select count(*)
from STUDENT;
-- 7.1.12b
select ROCNIK, count(*) as pocet_studentov
    from STUDENT
        group by ROCNIK;
-- 7.1.12c
select st_odbor, count(*) as pocet_studentov
    from STUDENT
        group by st_odbor;

-- 7.1.13
select *
    from ZAP_PREDMETY
        where OS_CISLO = '500439'
        and CIS_PREDM in (select CIS_PREDM
                            from ST_PROGRAM
                                where TYP_POVIN = 'V');
-- 7.1.14
select NAZOV, count(OS_CISLO) as pocet_Studentov
    from PREDMET join ZAP_PREDMETY using(cis_predm)
        where CIS_PREDM in (select CIS_PREDM
                                from ST_PROGRAM
                                    where skrok = 2008 and TYP_POVIN = 'P')
        group by NAZOV;

select *
from ST_PROGRAM;

-- 7.2.1
select nazov, count(*) as pocet_zamestnancov
    from P_ZAMESTNANEC join P_ZAMESTNAVATEL PZ on PZ.ICO = P_ZAMESTNANEC.ID_ZAMESTNAVATELA
        where NAZOV = 'Tesco'
            group by nazov;

-- 7.2.2
select (case when substr(ROD_CISLO, 1,2) < to_char(sysdate, 'YY') then to_char(sysdate, 'YY') -  substr(ROD_CISLO, 1,2)
    else 100 + to_char(sysdate, 'YY') -  substr(ROD_CISLO, 1,2) end) rok_narodenia,
    count(ROD_CISLO) pocet_Ludi
from P_POISTENIE
    where OSLOBODENY = 'A' or OSLOBODENY = 'a'
        group by substr(ROD_CISLO, 1,2)
        order by rok_narodenia;

-- 7.2.3
select MENO, PRIEZVISKO
    from P_OSOBA join P_POISTENIE using (rod_cislo)
        where ROD_CISLO not in (select  ROD_CISLO
                                    from P_POBERATEL)
        and (OSLOBODENY = 'A' or OSLOBODENY = 'a');

-- 7.2.4
select meno, PRIEZVISKO, sum (SUMA)
    from P_OSOBA join P_POISTENIE using (rod_cislo) join P_ODVOD_PLATBA using (id_poistenca)
        where extract(month from DAT_PLATBY) =  extract(month from sysdate) -1
            group by meno, PRIEZVISKO;

--