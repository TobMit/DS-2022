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