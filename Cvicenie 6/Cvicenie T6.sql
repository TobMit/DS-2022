select osoba.name, osoba.surname, surodenec.name, surodenec.surname
    from kvet3.person_rec osoba
        join kvet3.person_rec surodenec
            on (osoba.mother_id = surodenec.mother_id)
                and osoba.person_id <> surodenec.person_id;
                
select osoba.name, osoba.surname, surodenec.name, surodenec.surname
    from kvet3.person_rec osoba
        join kvet3.person_rec surodenec
            on (osoba.mother_id = surodenec.mother_id)
                and osoba.person_id > surodenec.person_id;

-- toto nefunguje cez null hodnoty                
select name, surname
    from kvet3.person_rec osoba
        where mother_id not in  (select mother_id
                                    from kvet3.person_rec surodenec 
                                        where osoba.person_id <> surodenec.person_id
                                        and mother_id is not null
                                    )
        or mother_id is null; -- matematicky nedok�e porovn�va� null hodnoty
-- cez exists je to univerz�lne, probl�m z null hodnotami nenastane                                    
select name, surname
    from kvet3.person_rec osoba
        where not exists  (select 'x'
                            from kvet3.person_rec surodenec 
                                    where osoba.person_id <> surodenec.person_id
                                        and surodenec.mother_id = osoba.mother_id
                                    );
-- oba selekty s� spr�vne, not in porovn�va podla matematickej oper�cie '=' ale null hodnotu nedok�e porovna�     



-- vyp�sa� ka�dej osobe matku
select osoba.name, osoba.surname, matka.name, matka.surname
    from kvet3.person_rec osoba
        join kvet3.person_rec matka on (osoba.mother_id = matka.person_id);
        
-- vyp�a� ka�dej osob staru mamu
select osoba.name, osoba.surname, stara_mama.name, stara_mama.surname
    from kvet3.person_rec osoba
       left join kvet3.person_rec matka on (osoba.mother_id = matka.person_id)
            left join kvet3.person_rec stara_mama on (matka.mother_id = stara_mama.person_id);
            
------------------------------------------- PRISTUPOVE PR�VA -------------------------------------------------------
grant select on kvet3.person_rec to public; -- public je rola, m��em da� len zopar studentom to je ina rola alebo v�etkym (public)
revoke select on kvet3.person_rec from public;
 
grant select on kvet3.person_rec to public;-- dostal som od ucitela pr�vo na tabulku a preto ho da� aj da���m

-- ak ucitel odobrie pr�vo mne tak aj v�etci ostan� ktor� dostali odo mna pr�vo tak ho stratia

create user mk_test IDENTIFIED xxx; novy uzivatel
revoke connect from mitala1;

grant connect  to mk_test; -- dostal som pr�vo d�va� pr�va in�m u��vate�om
-- ke� mne bude odobran� pr�vo tak ostatn�m ost�va ale toto plat� iba pre syst�mov�

drop user mk_test; -- mus� by� odhl�sen�, admin vie zru�i� session ale ak m� nejak� tabu�ky tam mus�m najsk�r zrusit tabulky a potom session a potom ho odstranit