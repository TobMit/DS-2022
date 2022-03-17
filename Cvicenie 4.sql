-- Cvicenie 3
-- Zapisat fx vsetkym studentom kotri nemaju znamku z predmetu 
select *
    from predmet;
    
desc zap_predmety;
    
update zap_predmety
    set vysledok = 'F', datum_sk = sysdate
        where vysledok is null and cis_predm = 'BA10';
ROLLBACK;

-- odstranenie vsetky studentov ktori nemaju ziaden predmet
delete student
    where student.os_cislo not in (
        select os_cislo
            from zap_predmety);
            
