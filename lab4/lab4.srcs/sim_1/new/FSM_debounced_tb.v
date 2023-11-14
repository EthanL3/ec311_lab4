`timescale 1ns / 1ps

module FSM_debounced_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    parameter DELAY_COUNT = 50000; // Debounce delay count
    
    // Inputs
    reg clk, reset, read, button;
    reg [7:0] in_data;
    
    // Outputs
    wire out, debounced_button;
    
    // Instantiate the modules
    moore_FSM uut(out, clk, reset, read, button, in_data);
    debouncer deb(clk, reset, button, debounced_button);

    // Clock generation
    initial begin
        clk = 0;
        forever #((CLK_PERIOD)/2) clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize inputs
        reset = 1;
        read = 0;
        button = 0;
        in_data = 8'b0;

        // Apply reset
        #10 reset = 0;

        // Test case 1: Press button and check debounced output
        #20 button = 1;
        #20 button = 0;

        // Test case 2: Set input data, trigger read, and check output
        #20 in_data = 8'b10101010;
        #20 read = 1;
        #20 read = 0;

        // Add more test cases as needed

        // End simulation
        #100 $finish;
    end

endmodule
