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
