begin
    declare
        pocet integer:= '50x';
    begin
        --pocet:= '1x';
        DBMS_OUTPUT.PUT_LINE('Hodnota je' || pocet);
        exception
            when others then dbms_output.put_line('Chyba hodnota');  
    end;
    exception
        when others then dbms_output.put_line('Vonkajsia chyba');
end;
/

set SERVEROUTPUT on;

create or replace function GetVek(p_rc char)
    return number
is
    vstupny_ret char(10);
    datum_narodenia date;
BEGIN
    vstupny_ret:=substr(p_rc, 5, 2) || '.'
                || mod(substr(p_rc, 3, 2),50)
                || '.19' || substr(p_rc, 1, 2);
    datum_narodenia:= to_date(vstupny_ret,'DD.MM.YYYY');
    return months_between(sysdate, datum_narodenia)/12;
    EXCEPTION
        when others then return -1;
end;
/

select GetVek(ROD_CISLO)
    from PRIKLAD_DB2.os_udaje;

declare
    vek number;
BEGIN
    vek:=GETVEK('571224/1234');
    DBMS_OUTPUT.PUT_LINE(vek);
end;
/

declare
    vek number;
BEGIN
    select GetVek('571224/1234') into vek from dual;
    DBMS_OUTPUT.PUT_LINE(vek);
end;
/

variable hodnota_veku number;
EXEC :hodnota_veku:=GetVek('571224/1234');
print hodnota_veku;


-- 8.1.1
create or replace procedure Vyskladaj_skupinu
(paracovisko char, odbor st_odbory.st_odbor%type, zameranie integer, rocnik char, kruzok char, st_skupina OUT char)
IS
    skratka char(2);
BEGIN
    select sk_odbor || sk_zamer into skratka
        from PRIKLAD_DB2.st_odbory
            where c_st_odboru = odbor
                and c_specializacie = zameranie;
    st_skupina:= '5' || paracovisko || skratka || rocnik || kruzok;
end;
/
select *
    from PRIKLAD_DB2.st_odbory;

variable skupina char(6);
exec Vyskladaj_skupinu('Z',100, 0, 1, 2, :skupina);
print skupina;

-- 8.1.2
create or replace function f_Vyskladaj_skupinu
(paracovisko char, odbor st_odbory.st_odbor%type, zameranie integer, rocnik char, kruzok char)
return char
IS
    skratka char(2);
BEGIN
    select sk_odbor || sk_zamer into skratka
    from PRIKLAD_DB2.st_odbory
    where c_st_odboru = odbor
      and c_specializacie = zameranie;
    return '5' || paracovisko || skratka || rocnik || kruzok;
end;
/

-- 8.1.3
select f_Vyskladaj_skupinu('Z',100, 0, 1, 2) as vyskladana_Skupina
    from DUAL;

select *
from STUDENT where rocnik = &vstup_cislo;
-- ked s� tam && tak ti prememenna hodnotu ulozi
-- potom treba undefine vstup_cislo;
undefine vstup_cislo;


-- 8.1.4
-- funkcia s 2 parametrami - cislo predmetu a nazov predmetu
-- treba skontrolovat ci su not null, ak sú not null, skontrolujem ci take cislo predmetu ut nie je, ak nie je , vlozim ho
CREATE or replace function skontroluj_predmet(cislo_predmetu char, nazov_predmetu char)
return integer
is
    pocet_predmetov integer;
BEGIN
    if cislo_predmetu is NULL or nazov_predmetu is null then return 0;
    end if;
    select count(*) into pocet_predmetov from PREDMET
        where cislo_predmetu = CIS_PREDM;
    if pocet_predmetov = 0 then insert into PREDMET values (cislo_predmetu, nazov_predmetu);
        return 1;
    else return 0;
    end if;
end;
/
-- select nezavolame ked modifikuje data
variable vysledok number;
exec :vysledok:=skontroluj_predmet('I123','INF');
print vysledok;

-- 8.1.6
create or replace function pocet_studentov(cislo_premetu char, sk_rok integer)
 return number
is
    vysledok number;
begin
    select count(*) into VYSLEDOK
        from STUDENT join ZAP_PREDMETY using (os_cislo) join PREDMET using (cis_predm)
            where CIS_PREDM = cislo_premetu
                and SKROK = sk_rok;
    return vysledok;
end;
/

select pocet_studentov('BH09', 2008) from DUAL;

-- 8.2.4 -- pred tým zavolať select coutn a scitať, alebo sql%rowcount (ten vráti počet záznamov)
create or replace function Zrus_predmet (cislo_predmetu integer)
return number
is
    pocet integer;
begin
    delete ZAP_PREDMETY
        where CIS_PREDM = cislo_predmetu;
    pocet := sql%rowcount;
    delete ST_PROGRAM
        where CIS_PREDM = cislo_predmetu;
    delete PREDMET_BOD
        where CIS_PREDM = cislo_predmetu;
    delete PREDMET
        where cislo_predmetu = CIS_PREDM;
    return pocet;
end;
/