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
-- nemusim davat rollback kedze sa ziadne data nemodifikovali
alter trigger suma_ disable;

-- chcek constrain ako triger
alter table P_PRISPEVKY
    add check ( SUMA >= 0 );

-- napiste (pokuste sa) check constraint - atribut kedy nemozeme mat hodnotu v buducnosti (tab. p_prispevky)
alter table P_PRISPEVKY
    add check (KEDY <= sysdate);
-- funkcia sysdate nie je deterministicka preto to nebude fungovat cez chcek constrain

create or replace trigger datum
    before insert or update on P_PRISPEVKY
    for each row
        begin
            if :new.kedy > sysdate then raise_application_error(-20001, 'chybne zadany datum'); end if;
        end;
    /

-- povolit triger ktori sme na zaciatku zakazali
alter trigger SUMA_ enable;
-- poradie spustania trigrov nie je garantovane
-- riesenie: dat dva trigre do jedneho
-- alebo v novom oracle ma follows a potom to vieme definovat

--