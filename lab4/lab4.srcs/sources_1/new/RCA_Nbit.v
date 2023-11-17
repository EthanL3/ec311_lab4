// this file has 3 modules: RCA (parameterized), full adder, half adder
// we commented out the full and half adders and implemented them in a separate file but left them here for reference

module ripple_carry_adder #(parameter n = 32)(
    input cin,
    input [31:0] a,
    input [31:0] b,
    output [n:0] sum,
    output cout
);
    wire [n:0] carry; //carry wire
    wire [n:0] sum_o;
    assign carry[0] = cin;

    generate
        genvar i;
        for(i=0; i<n; i=i+1) begin : full_adder_loop
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .c_in(carry[i]),
                .sum(sum_o[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout=carry[n]; // carry[n] is cout
    assign sum = sum_o;
    assign sum[32] = carry[n];
endmodule

/*
//full adder and half unmodified from previous labs
module full_adder(
    input c_in,
    input a,
    input b,
    output sum,
    output cout
);

    wire w1, w2, w3, w4;
    //will call 2 half adders
    half_adder myha1 (
    .a(a), 
    .b(b),
    .sum(w1), //connects wire 'w1' to the module's sum output
    .c_out(w2)
    );

    half_adder myha2 (
    .a(c_in),
    .b(w1),
    .sum(w4),
    .c_out(w3)
    );

    //a full adder must also have an or gate
    //output sum
    assign sum = w4;

    //output cout with the or gate
    assign cout = w2 | w3;

endmodule      

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

*/
