
// Testbench for a 32-bit adder with a 33-bit output
module rca_32_tb;

    // Test vectors and result signals
    reg [31:0] a, b; // 32-bit input vectors
    wire [32:0] result_verify, result; // 33-bit output vector for the sum
    wire [1:0] cout, cout_verify;
    
    // verificiation module
    adder_32bit verification (
        .a(a),
        .b(b),
        .sum(result_verify)
    );
    
    ripple_carry_adder #(.n(32)) rcaparam(
        .cin(2'b0), // hard wired to 0
        .a(a),
        .b(b),
        .sum(result),
        .cout(cout)
    );

    // Apply test cases and monitor results
    initial begin
        // Initialize inputs to zero
        a = 0; b = 0;
        
        // Display the header for the results
        $display("a \t\t + \t\t b \t\t result \t cout \t\t result_verify \t\t cout_verify ");
        //$display("----\t ----\t\t\t\t ----\t\t\t\t ------");

        // Test Case 1: Add two maximum 32-bit values
        //#10 a = 32'hFFFFFFFF; b = 1;
        //#10 $display("%g\t %h\t %h\t %h", $time, a, b, result);

        // Test Case 2: Add two arbitrary 32-bit values
        //#10 a = 32'h12345678; b = 32'h87654321;
        //#10 $display("%g\t %h\t %h\t %h", $time, a, b, result);

        // Test Case 3: Add zero to a 32-bit value
        //#10 a = 32'hABCDEF01; b = 0;
        //#10 $display("%g\t %h\t %h\t %h", $time, a, b, result);

        // add max 32bit value and 1 (should have cout) 
        #10
        a = 32'hFFFFFFFF; 
        b = 32'h1;
        #10
        $display("%h\t %h\t %h\t %h\t %h\t %h", a, b, result, cout, result_verify, cout_verify);
         
        #10
        a = 32'h12345678; 
        b = 32'h02138131;
        #10
        $display("%h\t %h\t %h\t %h\t %h\t %h", a, b, result, cout, result_verify, cout_verify);
         
         
        #10 $finish;
    end

endmodule



