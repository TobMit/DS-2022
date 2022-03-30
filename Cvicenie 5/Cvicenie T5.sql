-- 5.4.1
select meno,priezvisko
    from p_osoba
        where substr(rod_cislo,3,1) BETWEEN 5 and 6;
        
-- 5.4.2
select meno, priezvisko
    from p_osoba
        where substr(rod_cislo, 3,2) = extract(month from sysdate) or substr(rod_cislo, 3,2) = (extract(month from sysdate) + 50);
        
-- 5.4.3
select meno, priezvisko
    from p_osoba
        where rod_cislo in (select rod_cislo
                                from p_ztp
                                    where dat_do < sysdate );
                                    
select count(*)
    from p_osoba;
    
    
-- 5.4.4

select count(*)
    from p_osoba
        where not EXISTS (select 'x'
                                from p_ztp ztp
                                    where ztp.rod_cislo = p_osoba.rod_cislo );

                                  
-- 5.4.5
select meno, priezvisko, to_char(sysdate, 'YY') + 100 - substr(rod_cislo, 1,2) "rok", rod_cislo
    from p_osoba
        where mod (to_char(sysdate, 'YY') + 100 - substr(rod_cislo, 1,2), 5 )= 0;
        
select to_char (sysdate, 'yy')
    from dual;
    
-- 5.4.6

select * from p_zamestnanec;
select * from p_poistenie order by id_poistenca;

select count(*) 
    from p_zamestnanec join p_zamestnavatel on (id_zamestnavatela = ICO) join p_poistenie poist using (id_poistenca) 
        where nazov = 'Tesco';
        
-- 5.4.7
select *
    from p_typ_prispevku;
    
select *
    from p_osoba
        where rod_cislo not in (select rod_cislo
                                    from p_poberatel)
              or rod_cislo in (select rod_cislo
                                from p_poberatel join p_typ_prispevku using(id_typu)
                                    where popis <> 'nezamest');
                                    
-- 5.4.8
select *
    from p_poberatel join p_prispevky prisp using (id_poberatela) join p_typ_prispevku typ on (prisp.id_typu = typ.id_typu)
        where popis <> 'nezamest' 
            and dat_do is null ;
            
-- 5.4.9
select count (*) "celkovy_pocet"
    from p_zamestnanec
        where dat_do is null and id_zamestnavatela in (select ico
                                                        from p_zamestnavatel
                                                            where nazov = 'Tesco');
-- 5.4.10
select sum(suma)
    from p_odvod_platba
        where id_poistenca in (select id_poistenca
                                 from p_poistenie
                                     where id_platitela in (select ico
                                        from p_zamestnavatel
                                          where nazov = 'Tesco')
                                                and dat_do is  null) ; 
                                                
-- 5.4.11
select meno, priezvisko, count(*) pocet_menovcov
    from p_osoba
        Group by meno, priezvisko
            having  count(*) > 1;
            
-- 5.4.12
desc p_platitel;
insert into p_platitel values ('112112/7777');
insert into p_osoba(rod_cislo, meno, priezvisko, psc)
    values ('112112/7777', 'Karol','Matiasko', '01304');
    
select *
    from p_mesto;
select *
    from p_platitel;
commit;



-- 5.4.13
desc p_prispevky;

select *
    from p_poberatel join p_typ_prispevku using (id_typu)
        where dat_do is null or dat_do > sysdate;

select id_poberatela, add_months(sysdate, +1) "obdobie", id_typu, (sysdate+16) - - extract(day from sysdate), (perc_vyj * zakl_vyska) / 100
    from p_poberatel join p_typ_prispevku using (id_typu)
        where dat_do is null or dat_do > sysdate;
        

insert into p_prispevky(id_poberatela, obdobie, id_typu, kedy, suma)
    select id_poberatela, add_months(sysdate, +1), id_typu, (sysdate+16) - - extract(day from sysdate), (perc_vyj * zakl_vyska) / 100
    from p_poberatel join p_typ_prispevku using (id_typu)
        where dat_do is null or dat_do > sysdate;
commit;

-- 5.4.14

-- rok 1965
-- posledny den mesiaca
select last_day(add_months(to_date('01-Jan-1965','dd-Mon-yyyy'),level -1)) "datum"
    from dual
        connect by level <= 12;
        
select *
    from p_prispevky;
        
insert into p_prispevky
    select '6268',last_day(add_months(to_date('01-Jan-1965','dd-Mon-yyyy'),level -1)),1, last_day(add_months(to_date('01-Jan-1965','dd-Mon-yyyy'),level -1)), 10
    from dual
        connect by level <= 12;
commit;

-- 5.4.15
select *
    from p_poberatel
        where perc_vyj < 10;
        
update p_poberatel set dat_do = last_day(add_months(sysdate, (12 - extract(year from sysdate))))
    where perc_vyj < 10;
    
commit;

-- 5.4.16
update p_poberatel set perc_vyj = perc_vyj + 10
    where id_typu in (select pober.id_typu
                        from p_poberatel pober join p_typ_prispevku on (pober.id_typu = p_typ_prispevku.id_typu)
                             where popis = 'nezamest');
commit;

-- 5.4.17

select *
    from p_poberatel;
        
                                               
update p_poberatel set dat_do = sysdate
    where id_poberatela not in (select id_poberatela
                                        from p_prispevky); 
                                               
-- 5.4.18
select *
    from p_poberatel
        where id_poberatela not in (select id_poberatela
                                               from p_prispevky);

-- sú zamestnanci                                         
select * 
    from p_poistenie
        where rod_cislo <> id_platitela;
         
select *
    from p_platitel
        where id_platitela not like '%/%';
        
select count(rod_cislo)
        from p_poberatel pober join p_typ_prispevku on (pober.id_typu = p_typ_prispevku.id_typu)
                where popis = 'nezamest' and rod_cislo in (select rod_cislo 
                                                            from p_poistenie
                                                                where rod_cislo <> id_platitela);

update p_poberatel set dat_do = sysdate
    where rod_cislo in (select rod_cislo
                            from p_poberatel pober join p_typ_prispevku on (pober.id_typu = p_typ_prispevku.id_typu)
                                 where popis = 'nezamest' and rod_cislo in (select rod_cislo 
                                                            from p_poistenie
                                                                where rod_cislo <> id_platitela));
commit;

-- 5.4.19

select count(*)
    from p_poistenie
        where extract(year from dat_do) < 2000;
        
select *
    from p_odvod_platba
        where exists(select 'x'
                        from p_poistenie
                            where extract(year from dat_do) < 2000
                            and p_poistenie.id_poistenca =  p_odvod_platba.id_poistenca);
                            
delete from p_odvod_platba
        where exists(select 'x'
                        from p_poistenie
                            where extract(year from dat_do) < 2000
                            and p_poistenie.id_poistenca =  p_odvod_platba.id_poistenca);
                            
delete from p_poistenie
         where extract(year from dat_do) < 2000;
rollback;

-- 5.4.20
 select rod_cislo
            from p_poberatel
                 where extract(year from sysdate) - extract(year from dat_do) > 10 ; 
        
        
select count(*)
    from p_prispevky
        where id_poberatela in ( select id_poberatela
                                    from p_poberatel
                                         where extract(year from sysdate) - extract(year from dat_do) > 4 ); 
                                         
        
delete from p_prispevky
        where exists ( select 'x'
                            from p_poberatel
                                where extract(year from sysdate) - extract(year from dat_do) > 10
                                and p_prispevky.id_poberatela = p_poberatel.id_poberatela); 
rollback;
        
delete from p_poberatel
            where extract(year from sysdate) - extract(year from dat_do) > 10 ; 