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