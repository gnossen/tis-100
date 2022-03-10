/* verilator lint_off PINCONNECTEMPTY */
/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNOPTFLAT */
module port(
    // Connected to A.
    a_blocked,
    a_read,
    a_in,
    a_write,
    a_out,

    // Connected to B
    b_blocked,
    b_read,
    b_in,
    b_write,
    b_out,

    // Connected centrally
    panic,
    reset,
    clk);
    parameter N = 8;

    output reg a_blocked;
    input reg a_read;
    output reg [N-1:0] a_in;
    input reg a_write;
    input [N-1:0] a_out;

    output reg b_blocked;
    input reg b_read;
    output reg [N-1:0] b_in;
    input reg b_write;
    input [N-1:0] b_out;

    output wire panic;
    input wire reset;
    input wire clk;

    reg [1:0] sender;
    reg [N-1:0] value;

    reg delayed_clear;

    assign panic = (((a_write | b_write) & sender != 2'b00) |
                   (a_read & sender == 2'b01) |
                   (b_read & sender == 2'b10) |
                   (a_write & b_write) |
                   (a_write & a_read) |
                   (b_write & b_read));

    always @(posedge clk) begin
        if (reset) begin
            delayed_clear <= 0;
        end else if (a_read | b_read) begin
            delayed_clear <= 1;
        end else if (delayed_clear) begin
            delayed_clear <= 0;
        end
    end


    always @(posedge clk) begin
        if (reset) begin
            sender <= 0;
            value <= 0;
        end else if (a_write) begin
            sender <= 2'b01;
            value <= a_out;
        end else if (b_write) begin
            sender <= 2'b10;
            value <= b_out;
        end else if (delayed_clear) begin
            sender <= 2'b00;
            value <= 0;
        end
    end

    always_comb begin
        if (a_read) begin
            a_in = value;
        end else begin
            a_in = 0;
        end
        if (b_read) begin
            b_in = value;
        end else begin
            b_in = 0;
        end
    end

    assign a_blocked = sender[0];
    assign b_blocked = sender[1];

endmodule
