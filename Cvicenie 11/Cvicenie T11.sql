-- ku každému poistencovi počet platieb
select ID_POISTENCA, count(CIS_PLATBY)
    from P_POISTENIE left join P_ODVOD_PLATBA using (id_poistenca)
        group by ID_POISTENCA
            order by count(CIS_PLATBY);

-- upravte selek, nebude počet pladieb ale počet rôznych rokov v ktorých zaplatili pladbu
select ID_POISTENCA, count(distinct extract(year from DAT_PLATBY)) as pocet_roznych_rokov
    from P_POISTENIE left join P_ODVOD_PLATBA using (id_poistenca)
        group by ID_POISTENCA
            order by count(distinct extract(year from DAT_PLATBY)) desc;
        -- nemôže ten count do grup by pretože by tam boli samé jednotky -> vytvorím kategoriu rok a preto by to vracalo same jednotky

-- chcem id maxima z toho predchádzajúceho, všetkých
select ID_POISTENCA, count(distinct extract(year from DAT_PLATBY)) as pocet_roznych_rokov
    from P_POISTENIE left join P_ODVOD_PLATBA using (id_poistenca)
        group by ID_POISTENCA
            having count(distinct extract(year from DAT_PLATBY)) = (select max (count(distinct extract(year from DAT_PLATBY)))
                                                                     from P_POISTENIE left join P_ODVOD_PLATBA using (id_poistenca)
                                                                        group by ID_POISTENCA )
                order by count(distinct extract(year from DAT_PLATBY)) desc;

-- Vytvorit pohlad aktuálny poberatelia
create or replace view akutalny_poberatelia
    as select *
            from  P_POBERATEL
                where DAT_DO is null or DAT_DO > sysdate;

select *
from akutalny_poberatelia;