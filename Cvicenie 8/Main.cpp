#include <iostream>
#include <fstream>


using namespace std;


int main() {
    ofstream zapisovac;
    fstream citac;

    citac.open("../Cvicenie 8/name_calendar.csv");
    zapisovac.open("../Cvicenie 8/day_calendar.unl");
    string  nacitane;
    string delimiter = ";";
    if (citac.is_open()) {
        size_t pos = 0;
        while (getline(citac,nacitane)) {
            citac >> nacitane;
            pos = nacitane.find(delimiter);
            zapisovac << nacitane.substr(0, pos)<< "|";
            nacitane.erase(0, pos + delimiter.length());
            zapisovac << nacitane << "|" << endl;
        }
    }
    zapisovac.close();
    citac.close();
    return 0;
}

