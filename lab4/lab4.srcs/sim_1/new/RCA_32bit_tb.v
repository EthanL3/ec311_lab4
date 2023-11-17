`timescale 1ns / 1ps

module rca_32_tb;
    reg [31:0] a, b; // 32-bit inputs
    wire [32:0] result_verify, result; // 33-bit output (33rd bit is count bit)
    wire cout; // redundant since bit 33 of result is also cout, but easier to display this way

    adder_32bit verification (
        .a(a),
        .b(b),
        .sum(result_verify)
    );
    
    ripple_carry_adder #(32) rcaparam (
        .cin(1'b0), // Single-bit carry-in, hardwired to 0
        .a(a),
        .b(b),
        .sum(result),
        .cout(cout)
    );

    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clk period
    end

    initial begin
        a = 0; b = 0;
        $display("a \t\t + \t\t b \t\t result \t cout \t\t result_verify");

        // Tests
        //this test should set cout=1 (bit 32 of output) to indicate overflow
        #10 a = 32'hFFFFFFFF; b = 1;
        #10 $display("%h + %h = %h, Cout: %b, Verify: %h", a, b, result, cout, result_verify);

        //rest of tests will have cout=0 (bit 32 of output is also 0)
        #10 a = 32'h12345678; b = 32'h87654321;
        #10 $display("%h + %h = %h, Cout: %b, Verify: %h", a, b, result, cout, result_verify);

        #10 a = 32'hABCDEF01; b = 0;
        #10 $display("%h + %h = %h, Cout: %b, Verify: %h", a, b, result, cout, result_verify);

        #10 a = 32'hFF43143; b = 32'h1;
        #10 $display("%h + %h = %h, Cout: %b, Verify: %h", a, b, result, cout, result_verify);

        #10 $finish;
    end
endmodule
