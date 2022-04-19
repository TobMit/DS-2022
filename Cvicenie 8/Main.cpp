#include <iostream>
#include <fstream>


using namespace std;


int main() {
    /// Treba vždy zo súboru odstraniť utf 8 bom - cez hex editor prvé tri byty
    ofstream zapisovac;
    fstream citac;

    citac.open("../Cvicenie 8/name_calendar.csv");
    zapisovac.open("../Cvicenie 8/name_day_calendar.unl");
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
    return 0;
}

