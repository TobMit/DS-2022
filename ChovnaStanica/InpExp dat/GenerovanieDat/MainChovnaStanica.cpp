#include <iostream>
#include <fstream>
#include "dataLoader/dataLoader.h"
#include <vector>
#include <array>
#include <sstream>

using namespace std;

vector<string> menaM, menaZ, ulice, priezviskaM, priezviskaZ, zariadenia, zvieraMenoM, zvieraMenoZ;
vector<array<string,2>> mesta;



void spracujData();
void ulozData(string sourceName);
void naplnPomocneTabulky();
void naplnanieTabuliek(vector<string> *vector, DataLoader *loader);
string& generujRodCislo(bool zena);

int main() {
    srand(time(NULL));
    static const int POCET_ZAZNAMOV = 100000;
    naplnPomocneTabulky();

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
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/priezviksa_zien.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&priezviskaZ,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/ulice.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&ulice,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/zariadenia.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&zariadenia,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/zveryM.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&zvieraMenoM,loader);
    }
    loader->openNew("../ChovnaStanica/InpExp dat/GenerovanieDat/sorceData/zveryZ.txt");
    if (loader->isOpen()) {
        naplnanieTabuliek(&zvieraMenoZ,loader);
    }

    /*
    for (int i = 0; i < zariadenia.size(); i++) {
        cout << zariadenia.at(i) << endl;
    }*/
}

void naplnanieTabuliek(vector<string> *vector, DataLoader *loader) {
    while (loader->nextLine()){
        vector->push_back(loader->getNextParameter());
    }
}

void spracujData() {
    /// Treba vždy zo súboru odstraniť utf 8 bom - cez hex editor prvé tri byty
    string sourceName[] = {"fin_operacie",
                           "plemena",
                           "pobocky",
                           "pobocky_zariadenia",
                           "zakaznici_dodavatelia",
                           "zamestnanci",
                           "zariadenia",
                           "zvierata"} ;
    for (int i = 0; i < 8; i++) {
        ulozData(sourceName[i]);
    }
}

void ulozData(string sourceName) {
    ofstream zapisovac;
    fstream citac;

    citac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName +".csv");
    zapisovac.open("../ChovnaStanica/InpExp dat/rawData/" + sourceName + ".txt");
    string  nacitane;
    string delimiter = ";";

    if (citac.is_open()) {
        size_t pos = 0;
        // nacita iba jedno meno

        while (getline(citac,nacitane)) {
            //pos = nacitane.find(delimiter);
            //zapisovac << nacitane.substr(0, pos) << "|";
            //nacitane.erase(0, pos + delimiter.length());

            while ((pos = nacitane.find(delimiter)) != string::npos) {
                zapisovac << nacitane.substr(0, pos) << "|";
                nacitane.erase(0, pos + delimiter.length());
            }

            pos = nacitane.find("\r");
            zapisovac << nacitane.substr(0, pos) << "|" << endl;

        }
    }
    zapisovac.close();
    citac.close();
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