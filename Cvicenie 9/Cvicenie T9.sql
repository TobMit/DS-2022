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

-- triger ktory automatizovanie nastavi hodnotu sumy pre tabulku p_prispevky
-- vypocita sa to na zaklade zakladnej sumy pre dany typ prispevku (p_typ_prispevku)
-- a precentualneho vyjadrenia pruslusnosti daneho poberatela
create or replace trigger automatickeNastavenie
    before insert or update on P_PRISPEVKY
    for each row
    declare
        prispevku number;
        percentualneho number;
    begin
        select ZAKL_VYSKA into prispevku
            from P_TYP_PRISPEVKU
                where :new.ID_TYPU = P_TYP_PRISPEVKU.ID_TYPU;
        select PERC_VYJ into percentualneho
            from P_POBERATEL
                where P_POBERATEL.ID_POBERATELA = :new.id_poberatela;
        :new.suma :=(percentualneho * prispevku);
    end;
    /
-- nemôzem tam spravit insert do p_prispevky pretoze by sa znovu sputil triger atď

-- rozsirit p_prispevky o dasli atribut, ktori bude ukazovat kto modifikoval data
alter table P_PRISPEVKY
    add upravoval varchar2(30);

-- spravit triger ktori tieto hodnoty nastavi
create or replace trigger upravil_
    before insert or update on P_PRISPEVKY
    for each row
    begin
        :NEW.upravoval := user;
    end;
    /

alter trigger datum disable;
update P_PRISPEVKY set SUMA = SUMA;
select * from P_PRISPEVKY;

-- 9.1.1
alter table ZAP_PREDMETY
    add uzivatel varchar2(30);
alter table ZAP_PREDMETY
    add dat_zmeny date;

select *
    from ZAP_PREDMETY;

create or replace trigger logger_zap_predmety
    before insert or update on zap_predmety
    for each row
    begin
        :NEW.uzivatel := user;
        :new.dat_zmeny := sysdate;
    end;
/

update ZAP_PREDMETY set SKROK = SKROK, ZAP_PREDMETY.uzivatel = 'TEST';
commit;

-- 9.1.2
create or replace trigger kontola_opakovania_predmetov
    before insert on ZAP_PREDMETY
    for each row
    declare
        pocet integer;
    begin
        select count(CIS_PREDM) into pocet
            from ZAP_PREDMETY
                where OS_CISLO = :new.os_cislo and CIS_PREDM = :new.cis_predm
                group by OS_CISLO;
        if pocet >= 1 then raise_application_error(-20001, 'Ziak nemoze ten isty predmet viac krat'); end if;
    end;
/

insert into ZAP_PREDMETY(os_cislo, cis_predm, skrok, prednasajuci, ects)
    values (500428,'IN05',2005,'KI001',1);

select *
    from ZAP_PREDMETY
        where OS_CISLO = '500428';
drop trigger kontola_opakovania_predmetov;
rollback;
---------------------------------
-- vytvoril som si proceduru aby som pre oba trigre nemusel dupliokvat ten isty kod
create or replace procedure zmena_os(NEW_OS_CISLO number , OLD_OS_CISLO number) is
begin
    insert into STUDENT(OS_CISLO,ST_ODBOR, ST_ZAMERANIE, ROD_CISLO, ROCNIK, ST_SKUPINA, STAV, UKONCENIE, DAT_ZAPISU)
        select NEW_OS_CISLO,ST_ODBOR, ST_ZAMERANIE, ROD_CISLO, ROCNIK, ST_SKUPINA, STAV, UKONCENIE, DAT_ZAPISU
            from STUDENT
                where os_Cislo = OLD_OS_CISLO;
    update ZAP_PREDMETY
        set OS_CISLO = NEW_OS_CISLO
            where OS_CISLO = OLD_OS_CISLO;
    delete from STUDENT
        where OS_CISLO = OLD_OS_CISLO;
end;
/
-- 9.1.3

rollback;

insert into STUDENT(OS_CISLO,ST_ODBOR, ST_ZAMERANIE, ROD_CISLO, ROCNIK, ST_SKUPINA, STAV, UKONCENIE, DAT_ZAPISU)
    select OS_CISLO + 1,ST_ODBOR, ST_ZAMERANIE, ROD_CISLO, ROCNIK, ST_SKUPINA, STAV, UKONCENIE, DAT_ZAPISU
            from STUDENT
                where ROD_CISLO ='845902/0012';
update ZAP_PREDMETY
    set OS_CISLO = 9
        where OS_CISLO = 8;
delete from STUDENT
    where OS_CISLO = 8;

create or replace trigger update_os1
    before update of OS_CISLO on STUDENT
    for each row
begin
    update ZAP_PREDMETY
        set OS_CISLO = :new.OS_CISLO
            where OS_CISLO = :old.OS_CISLO;
end;
/

select *
    from STUDENT;

update STUDENT
    set OS_CISLO = 9
        where OS_CISLO = 8;

-- 9.1.4
CREATE TABLE zap_predmety_log as
(
    select * from ZAP_PREDMETY
        where OS_CISLO = 7
);
-- je tam nexistujúci zaznam kôli tomu aby mi to dalo iba atribúty správne nastavené a žiaden záznam
alter table zap_predmety_log
    add operacia varchar2(15);

select *
    from zap_predmety_log;

select *
    from ZAP_PREDMETY
        order by OS_CISLO;

create or replace trigger zap_predmety_insert
    before insert on zap_predmety
    for each row
    begin
        insert into zap_predmety_log(OS_CISLO, CIS_PREDM, SKROK, PREDNASAJUCI, ECTS, ZAPOCET, VYSLEDOK, DATUM_SK, UZIVATEL, DAT_ZMENY, operacia)
            values (:new.OS_CISLO, :new.CIS_PREDM, :new.SKROK, :new.PREDNASAJUCI, :new.ECTS, :new.ZAPOCET, :new.VYSLEDOK, :new.DATUM_SK, user, sysdate, 'insert');
    end;
/

create or replace trigger zap_predmety_update
    before update on zap_predmety
    for each row
    begin
        insert into zap_predmety_log(OS_CISLO, CIS_PREDM, SKROK, PREDNASAJUCI, ECTS, ZAPOCET, VYSLEDOK, DATUM_SK, UZIVATEL, DAT_ZMENY, operacia)
            values (:old.OS_CISLO, :old.CIS_PREDM, :old.SKROK, :old.PREDNASAJUCI, :old.ECTS, :old.ZAPOCET, :old.VYSLEDOK, :old.DATUM_SK, user, sysdate, 'update');
    end;
/

create or replace trigger zap_predmety_delete
    before delete on zap_predmety
    for each row
begin
    insert into zap_predmety_log(OS_CISLO, CIS_PREDM, SKROK, PREDNASAJUCI, ECTS, ZAPOCET, VYSLEDOK, DATUM_SK, UZIVATEL, DAT_ZMENY, operacia)
    values (:old.OS_CISLO, :old.CIS_PREDM, :old.SKROK, :old.PREDNASAJUCI, :old.ECTS, :old.ZAPOCET, :old.VYSLEDOK, :old.DATUM_SK, user, sysdate, 'delete');
end;
/

insert into zap_predmety (os_cislo, cis_predm, skrok, prednasajuci, ects)
    values (8, 'BI30', 2022, 'KI003', 5);

update zap_predmety
    set os_cislo = 8, cis_predm ='BI30' , skrok = 2021, prednasajuci = 'KI003', ects = 5
        where OS_CISLO = 8 and CIS_PREDM = 'BI30';

delete ZAP_PREDMETY
    where OS_CISLO = 8 and CIS_PREDM = 'BI30';

-- 9.1.5

create or replace trigger zakazanie_delete_v_zap_predmet
    before delete on ZAP_PREDMETY
    for each row
    begin
        raise_application_error(-20001, 'Pokusate sa zmazat hodnotu v predmete');
    end;
    /

alter trigger zakazanie_delete_v_zap_predmet disable;

insert into zap_predmety (os_cislo, cis_predm, skrok, prednasajuci, ects)
    values (8, 'BI30', 2022, 'KI003', 5);
delete ZAP_PREDMETY
    where OS_CISLO = 8 and CIS_PREDM = 'BI30';
rollback;