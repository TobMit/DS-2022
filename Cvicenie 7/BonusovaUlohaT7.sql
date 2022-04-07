select distinct MENO,PRIEZVISKO, pobera.ID_TYPU
    from P_OSOBA join P_ZAMESTNANEC pzam on (P_OSOBA.ROD_CISLO = pzam.ROD_CISLO)
        join P_POBERATEL pobera on (P_OSOBA.ROD_CISLO = pobera.ROD_CISLO)
            join P_PRISPEVKY prispev on (pobera.ID_POBERATELA = prispev.ID_POBERATELA)
                where (pzam.DAT_DO is null or pzam.DAT_DO > sysdate)
                    and pzam.DAT_OD < prispev.KEDY and pobera.ID_TYPU in (select ID_TYPU
                                                                            from P_TYP_PRISPEVKU
                                                                                where POPIS like 'nezam%');


