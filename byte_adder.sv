`include "single_adder.sv"
/* verilator lint_off PINCONNECTEMPTY */
/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNOPTFLAT */

module byte_adder(x, y, z, carry);
  parameter N = 8;
  input [N-1:0] x;
  input [N-1:0] y;
  output [N-1:0] z;
  output logic carry;

  logic [N-1:0] carries;

  single_adder sa(.x(x[0]), .y(y[0]), .c(0), .z(z[0]), .carry_out(carries[0]));

  genvar i;
  generate
      for (i = 1; i < N; i = i + 1) begin
        single_adder sa(.x(x[i]), .y(y[i]), .c(carries[i-1]), .z(z[i]), .carry_out(carries[i]));
      end
  endgenerate

  assign carry = carries[N-1];
endmodule
