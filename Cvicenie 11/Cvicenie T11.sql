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
                where DAT_DO is null or DAT_DO > sysdate
        with check option;
-- bude fungovať import ale nebude to videť v pohlade
-- keď je with chcek tak by nešlo vložiť data ktoré nespňajupodmienku
-- ak chceme urobiť nejaky insert treba triger ktorý by bol insted of a dva inserty

select *
from akutalny_poberatelia;

-- triger ktorí bude kontrolovať či je poberatel aktuálny, ten dátum od a dátum do pre aktuálneho poberatela keď je vkladaý nový poberatel
create or replace trigger akutalny_poberatelia
    before insert or update on p_prispevky
    for each row
    declare
        datum_do date;
        datum_od date;
    begin
        select DAT_DO, DAT_OD into datum_do, datum_od
            from P_POBERATEL
                where P_POBERATEL.ID_POBERATELA = :new.id_poberatela;
       if datum_do < sysdate or datum_od is null or datum_do > sysdate then raise_application_error(-20001, 'Poberatel nie je aktualny');
       end if;

    end;
/

update P_PRISPEVKY
    set ID_POBERATELA = ID_POBERATELA;
rollback;

-- zistiť ako sa vyvíja základná výška, predpokla je že či každým rokom rastie cena alebo nie, spraviť podmienku pre konkrétny typ prispevku c

create or replace function f_vyska_prisp (id_typu_prispevku integer)
return int
is
    cursor kurzor(id integer) is select ZAKL_VYSKA from P_HISTORIA where ID_TYPU = id order by DAT_OD;
    predtym number; -- je inicializované na null takže v podmienke to prejde na else vetvu
    potom number;
begin

    for riadok in kurzor(id_typu_prispevku)
    loop
           potom:=riadok.ZAKL_VYSKA;
           if potom < predtym then return 0; end if;
           predtym := predtym;
    end loop;
    return 1;

end;
/
-- ak anomalia nerastie skonci cyklus vrati 1, ak nastane tak vrati 0 a ten return to zastavi

select ID_TYPU, f_vyska_prisp(ID_TYPU)
from P_TYP_PRISPEVKU;