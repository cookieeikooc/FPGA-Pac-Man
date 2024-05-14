//
//  HexArray.cpp
//  Final Lab Exam
//
//  Created by Bing Yu Li on 2024/1/6.
//

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
using namespace std;

int main()
{
    ifstream fin("/Users/bingyuli/Documents/CPP/Programming Class/Programming Class/input1.txt");
    ofstream fout("/Users/bingyuli/Documents/CPP/Programming Class/Programming Class/output1.txt");
    if (fin.fail()) {
        cout << "Failed to open input file.";
        exit(1);
    }
    else if (fout.fail()) {
        cout << "Failed to open output file.";
        exit(1);
    }
    //char ch;
    int num;
    while (!fin.eof()) {
        fin >> num;
        switch (num) {
            case 0:
                fout << "000000";
                break;
            case 1:
                fout << "000001";
                break;
            case 2:
                fout << "00010";
                break;
            case 3:
                fout << "000011";
                break;
            case 4:
                fout << "000100";
                break;
            case 5:
                fout << "000101";
                break;
            case 6:
                fout << "000110";
                break;
            case 7:
                fout << "000111";
                break;
            case 8:
                fout << "001000";
                break;
            case 9:
                fout << "001001";
                break;
            case 10:
                fout << "001010";
                break;
            case 11:
                fout << "001011";
                break;
            case 12:
                fout << "001100";
                break;
            case 13:
                fout << "001101";
                break;
            case 14:
                fout << "001110";
                break;
            case 15:
                fout << "001111";
                break;
            case 16:
                fout << "010000";
                break;
            case 17:
                fout << "010001";
                break;
            case 18:
                fout << "010010";
                break;
            case 19:
                fout << "010011";
                break;
            case 20:
                fout << "010100";
                break;
            case 21:
                fout << "010101";
                break;
            case 22:
                fout << "010110";
                break;
            case 23:
                fout << "010111";
                break;
            case 24:
                fout << "011000";
                break;
            case 25:
                fout << "011001";
                break;
            case 26:
                fout << "011010";
                break;
            case 27:
                fout << "011011";
                break;
            case 28:
                fout << "011100";
                break;
            case 29:
                fout << "011101";
                break;
            case 30:
                fout << "011110";
                break;
            case 31:
                fout << "011111";
                break;
            case 32:
                fout << "100000";
                break;
            case 33:
                fout << "100001";
                break;
        }
    }
    
    fin.close();
    fout.close();
    return 0;
    
}

/*
 char ch;
 int count = 0;
 fout << "2'd";
 while (!fin.eof()) {
     fin.get(ch);
     count += 1;
     if (ch != ' '){
         fout << ch;
     }
     if (ch == ' ') {
         fout << ", ";
         if (count % 32 == 0) {
             fout << "\n";
         }
         fout << "2'd";
     }
 }
 return 0;
 */
