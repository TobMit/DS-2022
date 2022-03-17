-- Cvicenie 3
-- Zapisat fx vsetkym studentom kotri nemaju znamku z predmetu 
select *
    from predmet;
    
desc zap_predmety;
    
update zap_predmety
    set vysledok = 'F', datum_sk = sysdate
        where vysledok is null and cis_predm = 'BA10';
ROLLBACK;