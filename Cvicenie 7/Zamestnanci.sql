-- Zamestnanci
Create table  CV6_Zamestnanci (
                         id int NOT NULL ,
                         meno Varchar2 (20) NOT NULL ,
                         priezvisko Varchar2 (30) NOT NULL ,
                         nadriadeny int,
                         primary key (id),
                         foreign key (nadriadeny) references CV6_Zamestnanci (id)
);

commit ;
select *
    from CV6_Zamestnanci;

