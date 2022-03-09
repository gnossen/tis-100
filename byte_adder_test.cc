#include "Vbyte_adder.h"
#include "verilated.h"

#include <iostream>
#include <memory>

#include "rapidcheck.h"

const vluint64_t end_time = 256;
vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    auto byte_adder = new Vbyte_adder;

    rc::check("adder adds numbers",
            [byte_adder](unsigned char x, unsigned char y) {
                RC_PRE(x + y <= 255);
                byte_adder->x = x;
                byte_adder->y = y;
                for (int i = 0; i < end_time; ++i) {
                    byte_adder->eval();
                    main_time++;
                }
                RC_ASSERT(byte_adder->z == x + y);
            });

    delete byte_adder;
    return 0;
}
