SELECT
    * FROM  student;
    
-- for each row sa viaze iba na riadky kotre sa menia

-- triger, ktory zabezpeci, ze suma prispevov nemoze byt zaporna
-- ci definujeme trger before alebo after !!!!! BUDE NA TESTE !!!!

create or replace trigger suma_
    before insert or update on P_PRISPEVKY
    for each row
        begin
            if :new.suma < 0 then raise_application_error(-20001, 'zaporna suma'); end if;
        end;
    /

update P_PRISPEVKY set suma = -100;
-- nemusím dávať rollback keďže sa žiadne data nemodifikovali
alter trigger suma_ disable;

-- chcek constrain ako triger
alter table P_PRISPEVKY
    add check ( SUMA >= 0 );

