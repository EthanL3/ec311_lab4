`timescale 1ns / 1ps

module tb_moore_FSM;

    reg clk, reset, read;
    reg [7:0] in;
    wire out;
    
 
    
    moore_FSM dut (
        .out(out),
        .clk(clk),
        .reset(reset),
        .read(read),
        .in(in)
    );

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        read = 0;
        in = 8'b01010101;

        #5 reset = 0; 

        // State 0 (Idle state)
        $display("State: S0 (Idle State), out = %b", out);
        #10;

        // Transition to State 1
        read = 1;
        $display("State transition: S0 -> S1");
        #10;
        $display("State: S1, out = %b", out);
        #10;

        // Transition to State 2
        read = 0;
        $display("State transition: S1 -> S2");
        #10;
        $display("State: S2, out = %b", out);
        #10;

        // Transition to State 0 from State 2
        $display("State transition: S2 -> S0");
        #10;
        $display("State: S0 (Idle State), out = %b", out);
        #10;

        // Transition to State 3 from State 0
        reset = 1;
        $display("State transition: S0 -> S3");
        #10;
        $display("State: S0 (Idle State), out = %b", out);
        #10;
        
        $display("State transition: S3 -> S0");
        #10;
        $display("State: S0 Idle State, out = %b", out);
        // Reset and end simulation
        #10;
        
        $finish;
    end

    always #5 clk = ~clk; // Toggle clock every 5 time units

endmodule

