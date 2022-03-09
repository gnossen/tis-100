#include "Vbyte_adder.h"
#include "verilated.h"

#include <iostream>
#include <memory>

const vluint64_t end_time = 256;
vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    auto byte_adder = new Vbyte_adder;
    byte_adder->x = 23;
    byte_adder->y = 24;
    int output = byte_adder->z;
    while (!Verilated::gotFinish() && main_time < end_time) {
        byte_adder->eval();
        main_time++;
        output = byte_adder->z;
    }
    std::cout << "Output: " << output << std::endl;

    delete byte_adder;
    return 0;
}
