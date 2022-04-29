#include <iostream>
#include <fstream>


void spracujData(string sourceName);

using namespace std;


int main() {
    /// Treba vždy zo súboru odstraniť utf 8 bom - cez hex editor prvé tri byty
    string sourceName[] = {"Fin_Operacie",
                            "Plemena",
                            "Pobocky",
                            "Pobocky_zariadenia",
                            "Zakaznici_dodavatelia",
                            "Zamestnanci",
                            "Zariadenia",
                            "Zvierata"} ;
    for (int i = 0; i < sourceName->size(); ++i) {
        spracujData(sourceName[i]);
    }

    return 0;
}

void spracujData(string sourceName) {
    ofstream zapisovac;
    fstream citac;

    citac.open("../Cvicenie 8/name_calendar.csv");
    zapisovac.open("../Cvicenie 8/name_day_calendar.txt");
    string  nacitane;
    string delimiter = ";";

    if (citac.is_open()) {
        size_t pos = 0;
        // nacita iba jedno meno

        while (getline(citac,nacitane)) {
            pos = nacitane.find(delimiter);
            zapisovac << nacitane.substr(0, pos) << "|";
            nacitane.erase(0, pos + delimiter.length());

            while ((pos = nacitane.find(delimiter)) != string::npos) {
                zapisovac << nacitane.substr(0, pos);
                nacitane.erase(0, pos + delimiter.length());
            }
            if (nacitane.size() > 2) {
                pos = nacitane.find("\r");
                zapisovac << nacitane.substr(0, pos) << "|" << endl;
            } else
            {
                zapisovac << "|" << endl;
            }

        }
    }
    zapisovac.close();
    citac.close();
}

