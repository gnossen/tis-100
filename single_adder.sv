module single_adder(input x, y, c, output logic z, carry_out);
    assign z = (x ^ y) ^ c;
    assign carry_out = ((x & y) & ~c) | ((x | y) & c);
endmodule
