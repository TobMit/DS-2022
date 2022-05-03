#include <iostream>
#include <fstream>

using namespace std;

void spracujData(string sourceName);



int main() {
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
        spracujData(sourceName[i]);
    }

    return 0;
}

void spracujData(string sourceName) {
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

            //zapisovac << nacitane << "|" << endl;
            /*
            if (nacitane.size() > 2) {
                pos = nacitane.find("\r");
                zapisovac << nacitane.substr(0, pos) << "|" << endl;
            } else
            {
                zapisovac << "|" << endl;
            }*/

        }
    }
    zapisovac.close();
    citac.close();
}

