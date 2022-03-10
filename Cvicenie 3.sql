-- vypise os cislo studenta ktory ma predmet s 3 a
select student.os_cislo
    from student join zap_predmety 
        on (student.os_cislo = zap_predmety.os_cislo) 
            join predmet using (cis_predm)
                where nazov like '%a%a%a' or nazov like 'A%a%a%'; -- preto lebo prve pismeno bolo velke