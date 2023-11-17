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


