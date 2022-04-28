-- kaskadovito zmenit hodnotu id poberatela
create or replace trigger poberatel
    before update on p_poberatel
    for each row
    begin
        update P_PRISPEVKY set ID_POBERATELA = :new.ID_POBERATELA
        where ID_POBERATELA := :OLD.ID_POBERATELA;
    end;
/