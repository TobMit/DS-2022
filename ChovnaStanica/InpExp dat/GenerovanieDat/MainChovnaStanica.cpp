#include <iostream>
#include <fstream>
#include "dataLoader/dataLoader.h"
#include <vector>
#include <array>
#include <sstream>

using namespace std;

class zariadenia {
private:
    string idZariadenia;
    string nazovZariad;
public:
    string& id() {
        return idZariadenia;
    };
    string& nazovZariadenia(){
        return nazovZariad;
    };
};
class pobocky_zariadenia{
private:
    string idPoboc;
    string idZar;
public:
    string& idPobocky() {
        return idPoboc;
    };
    string& idZariad(){
        return idZar;
    };
};
class pobocky {
private:
    string idPoboc;
    string kapac;
    string pscA;
    string adresaA;
    string mestoA;
public:
    string& id() {
        return idPoboc;
    };
    string& kapacita(){
        return kapac;
    };
    string& psc(){
        return pscA;
    };
    string& adresa(){
        return adresaA;
    };
    string& mesto(){
        return mestoA;
    };

};
class zamestnanci {
private:
    string cisloZam;
    string pobocka;
    string rodCisl;
    string menO;
    string priezv;
    string prac_od;
    string prac_do;
public:
    string& id() {
        return cisloZam;
    };
    string& idPobocky(){
        return pobocka;
    };
    string& meno(){
        return menO;
    };
    string& priezvisko(){
        return priezv;
    };
    string& rodCislo(){
        return rodCisl;
    };
    string& pradOd(){
        return prac_od;
    };
    string& pradDo(){
        return prac_do;
    };
};
class plemena {
private:
    string idPlem;
    string nazovPlem;
public:
    string& id() {
        return idPlem;
    };
    string& nazovPlemena(){
        return nazovPlem;
    };
};
class zvierata {
private:
    string idZviera;
    string otc;
    string matk;
    string menoZver;
    string datumNar;
    string pohlav;
    string idPoboc;
    string plem;
public:
    string& id() {
        return idZviera;
    };
    string& otec(){
        return otc;
    };
    string& matka(){
        return matk;
    };
    string& menoZvierata(){
        return menoZver;
    };
    string& datumNarodenia(){
        return datumNar;
    };
    string& pohlavie(){
        return pohlav;
    };
    string& idPobocky(){
        return idPoboc;
    };
    string& pelemeno(){
        return plem;
    };

};
class finOperacie {
private:
    string idTran;
    string idOs;
    string datu;
    string idZver;
    string cen;
    string typ;
    string idPlem;
    string idPoboc;
public:
    string& id() {
        return idTran;
    };
    string& idOsoby(){
        return idOs;
    };
    string& datum(){
        return datu;
    };
    string& idZvierata(){
        return idZver;
    };
    string& cena(){
        return cen;
    };
    string& typOperacie(){
        return typ;
    };
    string& idPlemena(){
        return idPlem;
    };
    string& idPobocky(){
        return idPoboc;
    };

};
class zakazniciDodavatelia {
private:
    string idOsoby;
    string menO;
    string priezv;
    string spoloc;
public:
    string& id() {
        return idOsoby;
    };
    string& meno(){
        return menO;
    };
    string& priezvisko(){
        return priezv;
    };
    string& spolocnost(){
        return spoloc;
    };
};

vector<string> menaM, menaZ, ulice, priezviskaM, priezviskaZ, zariadeniaInport, zvieraMenoM, zvieraMenoZ, plemen, firmi;
vector<array<string,2>> mesta;

vector<zariadenia*> tableZariadenia;
vector<pobocky_zariadenia*> tablePobockyZariadenia;
vector<pobocky*> tablePobocky;
vector<zamestnanci*> tableZamestnanci;
vector<plemena*> tablePlemena;
vector<zvierata*> tableZvierata;
vector<finOperacie*> tableFinOperacie;
vector<zakazniciDodavatelia*> tableZakazniciDodavatelia;

static const int POCET_ZAZNAMOV_ZVEROV = 1000;
static const int KPACITA = 65;
static const int POCET_POBOCIEK = POCET_ZAZNAMOV_ZVEROV / KPACITA;
static const int POCET_ZAMESTNANCOV_NA_CHOVNU_STANICU = 6;
static const int POCET_FIN_OPERACI = POCET_ZAZNAMOV_ZVEROV;
static const int ZAKAZNICI_DODAVATELIA = POCET_FIN_OPERACI / 100;
static const int ZACIATOK_PODNIKANIA = 2010;

void spracujData();
void naplnPomocneTabulky();
void naplnanieTabuliek(vector<string> *vector, DataLoader *loader);
string& generujRodCislo(bool zena);
string& generujDatum();
void generujZariadenia();
void generujPlemena();
void generujPobocky(const int pocetPobociek);
void generujZamestnancov(const int minPocet);
void generujPobockyZariadenia();
void generujZakazniciDodavatelia(const int ZAKAZNICI_DODAVATELIA);
void generujZviera(const int minPoc);
void generujFinOperacie(const int minPoc);

int main() {
    srand(time(NULL));
    naplnPomocneTabulky();
    generujZariadenia();
    generujPlemena();
    generujPobocky(POCET_POBOCIEK);
    generujZamestnancov(POCET_ZAMESTNANCOV_NA_CHOVNU_STANICU);
    generujPobockyZariadenia();
    generujZakazniciDodavatelia(ZAKAZNICI_DODAVATELIA);
    generujZviera(POCET_ZAZNAMOV_ZVEROV);
    generujFinOperacie(POCET_FIN_OPERACI);
    spracujData();
    /*for (const auto &item:  tablePlemena) {
        cout << item->id()<< " "<< item->nazovPlemena()  << endl;
    }*/
    /*for (const auto &item: tableFinOperacie) {
        cout << item->id() << " " << item->idOsoby() << " " << item->datum() << " " << item->idZvierata() << " " << item->cena()<< " "  << item->typOperacie()<< " "  << item->idPlemena()<< " "<< item->idPobocky()<< endl;
    }*/

    return 0;
}

void naplnPomocneTabulky() {
    DataLoader *loader = new DataLoader("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/cities.txt");
    if (loader->isOpen()) {
        while (loader->nextLine()){
            array<string, 2> udaje;
            udaje.at(0) = loader->getNextParameter();
            udaje.at(1) = loader->getNextParameter();
            mesta.push_back(udaje);
        }
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/mena_muzov.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&menaM,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/mena_zien.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&menaZ,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/priezviska_muzov.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&priezviskaM,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/priezviska_zien.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&priezviskaZ,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/ulice.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&ulice,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/zariadenia.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&zariadeniaInport,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/zveryM.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&zvieraMenoM,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/zveryZ.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&zvieraMenoZ,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/plemena.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&plemen,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/nazvy_firiem.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&firmi,loader);
    }

/*
    for (int i = 0; i < firmi.size(); i++) {
        cout << firmi.at(i) << endl;
    }*/
}

void naplnanieTabuliek(vector<string> *vector, DataLoader *loader) {
    while (loader->nextLine()){
        vector->push_back(loader->getNextParameter());
    }
}

void spracujData() {
    /// Treba vždy zo súboru odstraniť utf 8 bom - cez hex editor prvé tri byty

    ofstream zapisovac;
    string sourceName[] = {"fin_operacie",
                           "plemena",
                           "pobocky",
                           "pobocky_zariadenia",
                           "zakaznici_dodavatelia",
                           "zamestnanci",
                           "zariadenia",
                           "zvierata"} ;
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[0] + ".txt");
    for (int i = 0; i < tableFinOperacie.size(); i++) {
        zapisovac << tableFinOperacie.at(i)->id() << "|" << tableFinOperacie.at(i)->idOsoby() << "|" << tableFinOperacie.at(i)->datum()
                << "|" << tableFinOperacie.at(i)->idZvierata() << "|" << tableFinOperacie.at(i)->cena() << "|" << tableFinOperacie.at(i)-> typOperacie()
                << "|" << tableFinOperacie.at(i)->idPlemena() << "|" << tableFinOperacie.at(i)->idPobocky() << "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[1] + ".txt");
    for (int i = 0; i < tablePlemena.size(); i++) {
        zapisovac << tablePlemena.at(i)->id() << "|" << tablePlemena.at(i)->nazovPlemena() << "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[2] + ".txt");
    for (int i = 0; i < tablePobocky.size(); i++) {
        zapisovac << tablePobocky.at(i)->id() << "|" << tablePobocky.at(i)->kapacita() << "|" << tablePobocky.at(i)->adresa()
                << "|" << tablePobocky.at(i)->mesto() << "|" << tablePobocky.at(i)->psc()<< "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[3] + ".txt");
    for (int i = 0; i < tablePobockyZariadenia.size(); i++) {
        zapisovac << tablePobockyZariadenia.at(i)->idPobocky() << "|" << tablePobockyZariadenia.at(i)->idZariad() << "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[4] + ".txt");
    for (int i = 0; i < tableZakazniciDodavatelia.size(); i++) {
        zapisovac << tableZakazniciDodavatelia.at(i)->id() << "|" << tableZakazniciDodavatelia.at(i)->meno()
                << "|" << tableZakazniciDodavatelia.at(i)->priezvisko() << "|" << tableZakazniciDodavatelia.at(i)->spolocnost()<< "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[5] + ".txt");
    for (int i = 0; i < tableZamestnanci.size(); i++) {
        zapisovac << tableZamestnanci.at(i)->id() << "|" << tableZamestnanci.at(i)->idPobocky()
                  << "|" << tableZamestnanci.at(i)->rodCislo() << "|" << tableZamestnanci.at(i)->meno()
                << "|" << tableZamestnanci.at(i)->priezvisko()<< "|" << tableZamestnanci.at(i)->pradOd()
                << "|" << tableZamestnanci.at(i)->pradDo()<< "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[6] + ".txt");
    for (int i = 0; i < tableZariadenia.size(); i++) {
        zapisovac << tableZariadenia.at(i)->id() << "|" << tableZariadenia.at(i)->nazovZariadenia() << "|" << endl;
    }
    zapisovac.close();
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName[7] + ".txt");
    for (int i = 0; i < tableZvierata.size(); i++) {
        zapisovac << tableZvierata.at(i)->id() << "|" << tableZvierata.at(i)->matka()
                  << "|" << tableZvierata.at(i)->otec() << "|" << tableZvierata.at(i)->datumNarodenia()
                  << "|" << tableZvierata.at(i)->pohlavie()<< "|" << tableZvierata.at(i)->idPobocky()
                  << "|" << tableZvierata.at(i)->pelemeno()<< "|" << endl;
    }
    zapisovac.close();
}

string &generujRodCislo(bool zena) {
    stringstream stringBuilder;
    int rok = rand() % 50 + 55;
    rok %= 100;
    int mesiac = rand() % 12 + 1;
    if (zena) {
        mesiac += 50;
    }
    int den = rand() % 28 + 1;
    int posledneTrojcislie = rand() % 899 + 100;
    unsigned posledneCislo = ((10000000*rok) + (100000 * mesiac) + (1000 * den) + posledneTrojcislie) % 11;
    if (posledneCislo > 9) {
        return generujRodCislo(zena);
    }

    if (rok < 10) {
        stringBuilder << "0" << to_string(rok);
    } else {
        stringBuilder << to_string(rok);
    }
    if (mesiac < 10){
        stringBuilder << "0" << to_string(mesiac);
    } else {
        stringBuilder << to_string(mesiac);
    }
    if (den < 10){
        stringBuilder << "0" << to_string(den) << "/";
    } else {
        stringBuilder << to_string(den) << "/";
    }
    stringBuilder << to_string(posledneTrojcislie) << to_string(posledneCislo);


    string returnValue = stringBuilder.str();
    return returnValue;
}

string &generujDatum(){
    int den = rand() % 27 + 1;
    int mesiac = rand() % 12 + 1;
    int rok = rand() % 11 + ZACIATOK_PODNIKANIA;
    stringstream builder;
    if (den < 10) {
        builder << "0"<<to_string(den);
    } else {
        builder << to_string(den);
    }
    builder << ".";
    if (mesiac < 10) {
        builder << "0"<<to_string(mesiac);
    } else {
        builder << to_string(mesiac);
    }
    builder << "." << to_string(rok);
    string datum = builder.str();
    return datum;
}

void generujZariadenia() {
    int index = 1;
    for (const auto &item: zariadeniaInport) {
        auto *data = new zariadenia;
        data->id() = to_string(index);
        data->nazovZariadenia() = item;
        tableZariadenia.push_back(data);
        index++;
    }
}

void generujPlemena() {
    int index = 1;
    for (const auto &item: plemen) {
        auto *data = new plemena;
        data->id() = to_string(index);
        data->nazovPlemena() = item;
        tablePlemena.push_back(data);
        index++;
    }
}

void generujPobocky(const int pocetPobociek) {
    for (int i = 1; i <= pocetPobociek; ++i) {
        auto *data = new pobocky;
        data->id() = to_string(i);
        int randomKapacita = rand() % 50 - 25;
        data->kapacita() = to_string(KPACITA + randomKapacita);
        int indexMesto = rand() % mesta.size();
        int indexUlica = rand() % ulice.size();
        data->psc() = mesta.at(indexMesto).at(1);
        data->mesto() = mesta.at(indexMesto).at(0);
        data->adresa() = ulice.at(indexUlica);
        tablePobocky.push_back(data);
    }

}

void generujZamestnancov(const int minPocet) {
    int index = 1;
    bool zena = false;
    zamestnanci *data;
    for (int i = 0; i < tablePobocky.size(); ++i) {
        for (int j = 0; j <= minPocet; ++j) {
            if (rand() % 2 == 1) {
                zena = true;
            }
            data = new zamestnanci;
            data->id() = to_string(index);
            index++;
            data->idPobocky() = to_string(i + 1);
            if (zena) {
                data->meno() = menaZ.at(rand() % menaZ.size());
                data->priezvisko() = priezviskaZ.at(rand() % priezviskaZ.size());
            } else {
                data->meno() = menaM.at(rand() % menaM.size());
                data->priezvisko() = priezviskaM.at(rand() % priezviskaM.size());
            }
            data->rodCislo() = generujRodCislo(zena);
            data->pradDo() = "";

            int den = rand() % 27 + 1;
            int mesiac = rand() % 12 + 1;
            int rok = rand() % 11 + ZACIATOK_PODNIKANIA;
            stringstream builder;
            if (den < 10) {
                builder << "0"<<to_string(den);
            } else {
                builder << to_string(den);
            }
            builder << ".";
            if (mesiac < 10) {
                builder << "0"<<to_string(mesiac);
            } else {
                builder << to_string(mesiac);
            }
            builder << "." << to_string(rok);
            string datum = builder.str();
            data->pradOd() = datum;

            tableZamestnanci.push_back(data);
        }
        if (rand()%3 == 1) {
            //prestupuje niekde
            // zoberiemsi zamestnanca ktorého vygenerovalo ako posledného
            // spravym z neho končiaceho
            // potom s novým id priradim nahodnej pobočke
            int den = rand() % 27 + 1;
            int mesiac = rand() % 12 + 1;
            int rok = rand() % 7 + ZACIATOK_PODNIKANIA;
            stringstream builder;
            stringstream builderKoniec;
            stringstream novyZaciatok;
            if (den < 10) {
                builder << "0"<<to_string(den);
                builderKoniec << "0"<<to_string(den);
                novyZaciatok << "0"<<to_string(den);
            } else {
                builder << to_string(den);
                builderKoniec << to_string(den);
                novyZaciatok << to_string(den);
            }
            builder << ".";
            builderKoniec << ".";
            novyZaciatok << ".";
            if (mesiac < 10) {
                builder << "0"<<to_string(mesiac);
                builderKoniec << "0"<<to_string(mesiac);
                novyZaciatok << "0"<<to_string(mesiac);
            } else {
                builder << to_string(mesiac);
                builderKoniec << to_string(mesiac);
                novyZaciatok << to_string(mesiac);
            }
            builder << "." << to_string(rok);
            builderKoniec << "." << to_string(rok + 2);
            novyZaciatok << "." << to_string(rok + 3);
            string datum = builder.str();
            string datum2 = builderKoniec.str();
            string datum3 = novyZaciatok.str();
            tableZamestnanci.at(index - 2)->pradOd() = datum;
            tableZamestnanci.at(index - 2)->pradDo() = datum2;
            zamestnanci *novy = new zamestnanci;
            novy->id() = to_string(index);
            novy->meno() = tableZamestnanci.at(index - 2)->meno();
            novy->priezvisko() = tableZamestnanci.at(index - 2)->priezvisko();
            novy->idPobocky() = to_string(rand() % tablePobocky.size() + 1);
            novy->rodCislo() = tableZamestnanci.at(index - 2)->rodCislo();
            novy->pradDo() = "";
            novy->pradOd() = datum3;
            index++;
            tableZamestnanci.push_back(novy);

        } else {
            //konci na pobocke
            // zoberiemsi zamestnanca ktorého vygenerovalo ako posledného
            // a tomu zmením datumi tak aby to pasovalo k tomu že skončil.
            int den = rand() % 27 + 1;
            int mesiac = rand() % 12 + 1;
            int rok = rand() % 8 + ZACIATOK_PODNIKANIA;
            stringstream builder;
            stringstream builderKoniec;
            if (den < 10) {
                builder << "0"<<to_string(den);
                builderKoniec << "0"<<to_string(den);
            } else {
                builder << to_string(den);
                builderKoniec << to_string(den);
            }
            builder << ".";
            builderKoniec << ".";
            if (mesiac < 10) {
                builder << "0"<<to_string(mesiac);
                builderKoniec << "0"<<to_string(mesiac);
            } else {
                builder << to_string(mesiac);
                builderKoniec << to_string(mesiac);
            }
            builder << "." << to_string(rok);
            builderKoniec << "." << to_string(rok + 2);
            string datum = builder.str();
            string datum2 = builderKoniec.str();
            tableZamestnanci.at(index - 2)->pradOd() = datum;
            tableZamestnanci.at(index - 2)->pradDo() = datum2;
        }
    }
}

void generujPobockyZariadenia() {
    for (int i = 0; i < tablePobocky.size(); ++i) {
        auto *data = new pobocky_zariadenia;
        data->idPobocky() = to_string(i + 1);
        data->idZariad() = tableZariadenia.at(rand() % tableZariadenia.size())->id();
        tablePobockyZariadenia.push_back(data);
    }
}

void generujZakazniciDodavatelia(const int ZAKAZNICI_DODAVATELIA) {
    for (int i = 1; i <= ZAKAZNICI_DODAVATELIA; ++i) {
        auto *data = new zakazniciDodavatelia;
        data->id() = to_string(i);
        if (rand() % 2 == 1) {
            data->meno() = menaZ.at(rand() % menaZ.size());
            data->priezvisko() = priezviskaZ.at(rand() % priezviskaZ.size());
        } else {
            data->meno() = menaM.at(rand() % menaM.size());
            data->priezvisko() = priezviskaM.at(rand() % priezviskaM.size());
        }
        data->spolocnost() = "";

        if (rand() % 8 == 5) {
            data->spolocnost() = firmi.at(rand() % firmi.size());
        }
        tableZakazniciDodavatelia.push_back(data);
    }
}

void generujZviera(const int minPoc) {
    // tu sa budú ukldat indexi takých zvierat ktoré sú vhodnými kandidátmi byť rodičmi
    // datum narodenia majú null - nemusím riešiť rok narodenia
    vector<int> matka;
    vector<int> otec;
    //kolko volnych miest toľko krát sa index (nie ten ktorý sa getuje ale ten ktorý sa nachádza vo vektore) pobocky nachadza v tomto zozname
    vector<int>volnePobocky;
    for (int i = 0; i < tablePobocky.size(); ++i) {
        for (int j = 0; j < stoi(tablePobocky.at(i)->kapacita()); ++j) {
            volnePobocky.push_back(i);
        }
    }
    
    int index = 1;
    int deti = minPoc/3;
    int hlavneZaznami = minPoc - deti;
    zvierata *data;
    for (int i = 0; i < hlavneZaznami; ++i) {
        data = new zvierata;
        bool zena = false;
        if (rand() % 2 == 1) {
            zena = true;
        }
        data->id() = to_string(index);
        data->matka() = "";
        data->otec() = "";
        
        if (rand() % 4 == 1) {
            data->datumNarodenia() = "";
            if (zena) {
                matka.push_back(i);
            } else {
                otec.push_back(i);
            }
        } else {
            data->datumNarodenia() = generujDatum();
        }

        if (zena) {
            data->menoZvierata() = zvieraMenoZ.at(rand() % zvieraMenoZ.size());
            data->pohlavie() = "Z";
        } else {
            data->menoZvierata() = zvieraMenoM.at(rand() % zvieraMenoM.size());
            data->pohlavie() = "M";
        }
        int volnyIndex = rand() % volnePobocky.size();
        data->idPobocky() = tablePobocky.at(volnePobocky.at(volnyIndex))->id();
        volnePobocky.erase(volnePobocky.begin() + volnyIndex);

        data->pelemeno() = tablePlemena.at(rand() % tablePlemena.size())->id();
        index++;

        tableZvierata.push_back(data);
    }
    for (int i = 0; i < deti; ++i) {
        if (volnePobocky.empty()){
            break;
        }
        data = new zvierata;
        bool zena = false;
        if (rand() % 2 == 1) {
            zena = true;
        }
        data->id() = to_string(index);
        data->matka() = tableZvierata.at(matka.at(rand() % matka.size()))->id();
        data->otec() = tableZvierata.at(otec.at(rand() % otec.size()))->id();

        if (rand() % 4 == 1) {
            data->datumNarodenia() = "";
            if (zena) {
                matka.push_back(i);
            } else {
                otec.push_back(i);
            }
        } else {
            data->datumNarodenia() = generujDatum();
        }

        if (zena) {
            data->menoZvierata() = zvieraMenoZ.at(rand() % zvieraMenoZ.size());
            data->pohlavie() = "Z";
        } else {
            data->menoZvierata() = zvieraMenoM.at(rand() % zvieraMenoM.size());
            data->pohlavie() = "M";
        }
        int volnyIndex = rand() % volnePobocky.size();
        data->idPobocky() = tablePobocky.at(volnePobocky.at(volnyIndex))->id();
        volnePobocky.erase(volnePobocky.begin() + volnyIndex);

        data->pelemeno() = tablePlemena.at(rand() % tablePlemena.size())->id();
        index++;
        tableZvierata.push_back(data);
    }
}

void generujFinOperacie(const int minPoc) {
    int index = 1;
    finOperacie *data;
    for (int i = 0; i < minPoc; ++i) {
        bool nakup = false;
        if (rand() % 3 == 1){
            nakup = true;
        }
        //či sa bude manipulovať zo zvieraťom (nakup alebo predaj)
        bool zviera = false;
        if (rand() % 10 == 1) {
            zviera = true;
        }
        data = new finOperacie;
        data->id() = to_string(index);
        data->idOsoby() = tableZakazniciDodavatelia.at(rand() % tableZakazniciDodavatelia.size())->id();
        data->datum() = generujDatum();
        index++;
        if (zviera) {
            if (nakup) {
                int indexZvierata = rand() % tableZvierata.size();
                data->idZvierata() = tableZvierata.at(indexZvierata)->id();
                data->idPlemena() = tableZvierata.at(indexZvierata)->pelemeno();
                data->idPobocky() = tableZvierata.at(indexZvierata)->idPobocky();
                data->cena() = to_string(rand() % 101 + 150);
            } else {
                int indexZvierata = rand() % tableZvierata.size();
                data->idZvierata() = tableZvierata.at(indexZvierata)->id();
                data->idPlemena() = tableZvierata.at(indexZvierata)->pelemeno();
                data->idPobocky() = tableZvierata.at(indexZvierata)->idPobocky();
                tableZvierata.at(indexZvierata)->idPobocky() = "";
                data->cena() = to_string(rand() % 201 + 150);
            }
        } else {
            data->idZvierata() = "";
            data->idPlemena() = tablePlemena.at(rand() % tablePlemena.size())->id();
            data->idPobocky() = tablePobocky.at(rand() % tablePobocky.size())->id();
            data->cena() = to_string(rand() % 101 + 5);
        }
        if (nakup) {
            data->typOperacie() = "N";
        } else {
            data->typOperacie() = "P";
        }

        tableFinOperacie.push_back(data);
    }
}