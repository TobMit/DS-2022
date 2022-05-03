#include <iostream>
#include <fstream>
#include "dataLoader/dataLoader.h"
#include <vector>
#include <array>

using namespace std;

vector<string> menaM, menaZ, ulice, priezviskaM, priezviskaZ;
vector<array<string,2>> mesta;

void spracujData();
void ulozData(string sourceName);
void naplnPomocneTabulky();

void naplnanieTabuliek(vector<string> *vector, DataLoader *loader);

int main() {
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
    for (int i = 0; i < ulice.size(); i++) {
        cout << ulice.at(i) << endl;
    }
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

