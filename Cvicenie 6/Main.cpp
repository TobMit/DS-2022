#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

string meno[10] = {"Anna", "Zuzana", "Katarina", "Jana", "Eva", "Helena", "Miroslav", "Milan", "Tomas", "Stefan"};
string priezvisko [5] = {"Kovac", "Varga", "Toth", "Nagy", "Balaz"};

int main() {
    srand(time(NULL));
    ofstream zapisovac;
    zapisovac.open("zamestnanci.txt");

    for (int i = 1; i <= 20; ++i) {
        zapisovac << i << "|" << meno[rand() % 10] << "|" << priezvisko[rand() % 5] << "|" << "|"<< endl;
    }
    for (int i = 21; i <= 50; ++i) {
        zapisovac << i << "|" << meno[rand() % 10] << "|" << priezvisko[rand() % 5] << "|" << rand() % i << "|" << endl;
    }
    zapisovac.close();
    return 0;
}

