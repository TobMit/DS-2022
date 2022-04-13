-- Zamestnanci
CREATE TABLE name_day_calendar
(
    datum                 DATE NOT NULL ,
    meno                 Varchar2(20) NULL,

    primary key(datum)
);
commit ;

---------- procedúra vrati meno menin podla datumu --------------------------
CREATE OR REPLACE FUNCTION name_day(p_datum date)
RETURN VARCHAR2
IS NAVR_MENO VARCHAR2(20);
BEGIN
    select meno into NAVR_MENO
        from name_day_calendar
            where to_char(datum, 'DD/MM') = to_char(p_datum, 'DD/MM');
    RETURN NAVR_MENO;
END;

------------------ Volanie proceduri -----------------------------------
select NAME_DAY(sysdate), to_char(sysdate, 'DD.MM')
    from DUAL;

--------------- test ci naozaj funguje -------------------------------
select to_char(datum, 'DD.MM'), meno
    from name_day_calendar
        where to_char(datum, 'DD/MM') = to_char(sysdate, 'DD/MM');


select to_char(datum, 'DD.MM.YYYY') as datum,meno
from name_day_calendar;
