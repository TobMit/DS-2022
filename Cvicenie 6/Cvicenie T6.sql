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
        or mother_id is null; -- matematicky nedok·ûe porovn·vaù null hodnoty
-- cez exists je to univerz·lne, problÈm z null hodnotami nenastane                                    
select name, surname
    from kvet3.person_rec osoba
        where not exists  (select 'x'
                            from kvet3.person_rec surodenec 
                                    where osoba.person_id <> surodenec.person_id
                                        and surodenec.mother_id = osoba.mother_id
                                    );
-- oba selekty s˙ spr·vne, not in porovn·va podla matematickej oper·cie '=' ale null hodnotu nedok·ûe porovnaù     



-- vypÌsaù kaûdej osobe matku
select osoba.name, osoba.surname, matka.name, matka.surname
    from kvet3.person_rec osoba
        join kvet3.person_rec matka on (osoba.mother_id = matka.person_id);
        
-- vypÌaù kaûdej osob staru mamu
select osoba.name, osoba.surname, stara_mama.name, stara_mama.surname
    from kvet3.person_rec osoba
       left join kvet3.person_rec matka on (osoba.mother_id = matka.person_id)
            left join kvet3.person_rec stara_mama on (matka.mother_id = stara_mama.person_id);
            
------------------------------------------- PRISTUPOVE PR¡VA -------------------------------------------------------
grant select on kvet3.person_rec to public; -- public je rola, mÙûem daù len zopar studentom to je ina rola alebo vöetkym (public)
revoke select on kvet3.person_rec from public;
 
grant select on kvet3.person_rec to public;-- dostal som od ucitela pr·vo na tabulku a preto ho daù aj daæöÌm

-- ak ucitel odobrie pr·vo mne tak aj vöetci ostan˝ ktor˝ dostali odo mna pr·vo tak ho stratia

create user mk_test IDENTIFIED xxx; novy uzivatel
revoke connect from mitala1;

grant connect  to mk_test; -- dostal som pr·vo d·vaù pr·va in˝m uûÌvateæom
-- keÔ mne bude odobranÈ pr·vo tak ostatn˝m ost·va ale toto platÌ iba pre systÈmovÈ

drop user mk_test; -- musÌ byù odhl·sen˝, admin vie zruöiù session ale ak m· nejakÈ tabuæky tam musÌm najskÙr zrusit tabulky a potom session a potom ho odstranit