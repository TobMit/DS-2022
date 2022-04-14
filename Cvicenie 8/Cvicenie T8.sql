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

select f_Vyskladaj_skupinu('Z',100, 0, 1, 2) as vyskladana_Skupina
    from DUAL;