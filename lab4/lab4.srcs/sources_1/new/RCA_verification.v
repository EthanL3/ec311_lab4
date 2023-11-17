// 32-bit adder -> 33-bit output
module adder_32bit(
    input [31:0] a,
    input [31:0] b,
    output [32:0] sum
);
    // Behavioral adder
    assign sum = a + b;
endmodule
