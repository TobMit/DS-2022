
-- testy či to funguje
select *
from ZVIERATA
where ID_ZVIERA = 1;

select *
from POBOCKY
where OBSAD_POBOC = KAPACITA;

-- 70 je plná
update ZVIERATA
set ID_POBOCKY = 5
where ID_ZVIERA = 1;

update FIN_OPERACIE
set ID_PLEM = 18
where ID_TRANSAKCIA = 926;

rollback;

select *
from ZVIERATA where ID_POBOCKY is not null order by ID_ZVIERA;
select *
from FIN_OPERACIE where TYP_OPERACIE = 'P' and ID_ZVIERA is null order by ID_TRANSAKCIA;

update FIN_OPERACIE
set ID_ZVIERA = 1
where ID_TRANSAKCIA = 5;

update FIN_OPERACIE
set CENA = CENA;

select *
from POBOCKY;

select *
from FIN_OPERACIE;

select ID_POBOCKY, KAPACITA, nvl(vypoc_obsadenost(ID_POBOCKY),0) as obsadenost, psc, adresa, mesto, obsad_poboc
from POBOCKY
where OBSAD_POBOC = KAPACITA;
rollback ;
commit ;

select ROD_CIS, count(CISLO_ZAMES)
    from ZAMESTNANCI
        group by ROD_CIS
            having count(CISLO_ZAMES) > 1;
select *
from ZAMESTNANCI
    where ROD_CIS = '045706/1264';


select * from ZVIERATA where ID_ZVIERA not in
(select za.ID_ZVIERA
    from ZVIERATA za join ZVIERATA mk on za.ID_ZVIERA = mk.MATKA) and ID_ZVIERA not in
(select za.ID_ZVIERA
    from ZVIERATA za join ZVIERATA fa on za.ID_ZVIERA = fa.OTEC)
order by ID_ZVIERA;

select mat.MENO_ZVER, mat.ID_ZVIERA, mat.MATKA, mat.OTEC, mat.PLEMENO, mat.ID_POBOCKY
    from zvierata syn join ZVIERATA mat on syn.MATKA = mat.MATKA
        where syn.ID_ZVIERA <> mat.ID_ZVIERA and syn.OTEC = mat.OTEC and syn.ID_ZVIERA = :id_zviera;

-- 8667
select *
from ZVIERATA where OTEC = 301 or MATKA = 301;
select *
from ZVIERATA;
-------------------------------------------------------------------------------
-- Výpis najlepších dodávateľov pre dané plemeno zvierat (majú najnižšie ceny).

select ID_OSOBY, MENO, PRIEZVISKO, SPOLOCNOST, CENA
from FIN_OPERACIE join ZAKAZNICI_DODAVATELIA using (id_osoby)
where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n') and ID_PLEM = :id_plem
  and CENA = (select min(cena)
              from FIN_OPERACIE
              where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n') and ID_PLEM = :id_plem
              group by ID_PLEM);

-- Výpis všetkých chovných staníc, ktoré v súčasnosti nemajú voľnú kapacitu pre ďalšie zvieratá.
select *
from POBOCKY
where KAPACITA = OBSAD_POBOC;

-- Výpis zákazníkov, ktorí kúpili viac ako 3 zvieratá.
select ID_OSOBY, meno, PRIEZVISKO, SPOLOCNOST, count (ID_ZVIERA)
from FIN_OPERACIE join ZAKAZNICI_DODAVATELIA using (id_osoby)
where  TYP_OPERACIE = 'P' or TYP_OPERACIE = 'p'
group by ID_OSOBY, meno, PRIEZVISKO, SPOLOCNOST
having count(ID_ZVIERA) > 3
order by count(ID_ZVIERA) desc ;


----------------------------------------------------------------------------
select *
from FIN_OPERACIE
where ID_OSOBY = 15 and (TYP_OPERACIE = 'P' or TYP_OPERACIE = 'p') and ID_ZVIERA is not null order by DATUM;
select ID_POBOCKY, KAPACITA, PSC, ADRESA, MESTO, f_hospodarenie(ID_POBOCKY)
from POBOCKY;
----------------------------------------------------------------------------

select ID_PLEM, min(cena)
from FIN_OPERACIE
where (TYP_OPERACIE = 'N' or TYP_OPERACIE = 'n')
group by ID_PLEM
order by ID_PLEM;

select count(*)
from FIN_OPERACIE
where ID_PLEM = 1;

drop table fin_operacie;
drop table zakaznici_dodavatelia;
drop table zamestnanci;
drop table pobocky_zariadenia;
drop table zariadenia;
drop table zvierata;
drop table pobocky;
drop table plemena;