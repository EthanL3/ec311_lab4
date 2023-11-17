
module half_adder(
    input a, 
    input b,
    output sum, 
    output c_out
);

// Implement Figure 2 here.
    //sum and xor gate
    assign sum = a ^ b;
    //c_out and and gate
    assign c_out = a && b;
endmodule
