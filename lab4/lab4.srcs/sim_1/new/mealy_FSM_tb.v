`timescale 1ns / 1ps

module mealy_FSM_tb;

    reg clk, in;
    wire out;
    
    mealy_FSM dut (
        .out(out),
        .clk(clk),
        .in(in)
    );
    
    initial begin
        // Initialize inputs
        clk = 0;
        in = 1;
        
        //S0 to S1
        #10;
        $display("Transition: S0 -> S1, out = %b", out);
        
        #10;
        in = 0;
        $display("Transition: S1 -> S2, out = %b", out);
        
        #10
        in = 0;
        $display("Transition, S2 -> S2, out = %b", out);
        
        #10
        in = 1;
        $display("Transition: S2 -> S1, out = %b", out);
        
        #10
        in = 1;
        $display("Transition: S1 -> S1, out = %b", out);
        #10
              
        $finish;
    end

    always #10 clk = ~clk; // Toggle clock every 5 time units
endmodule
