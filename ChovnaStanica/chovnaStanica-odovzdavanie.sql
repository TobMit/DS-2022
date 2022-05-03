-- funkcia ktorá vráti počet obsadenia chovnej stanice
create or replace function obsadenost (cis_pobocky INTEGER)
    return number
is
    obsadenos integer;
begin
    select count(ID_POBOCKY) into obsadenos
        from ZVIERATA
            where ID_POBOCKY = cis_pobocky
                group by ID_POBOCKY;
    return obsadenos;
end;
/
select ID_POBOCKY, KAPACITA, nvl(obsadenost(ID_POBOCKY),0) as obsadenost
    from POBOCKY ;
