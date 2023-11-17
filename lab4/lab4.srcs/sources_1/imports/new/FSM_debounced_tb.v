`timescale 1ns / 1ps

module FSM_debounced_tb;

    parameter CLK_PERIOD = 10;
    parameter DELAY_COUNT = 1000000; // we set to match the debouncer time (10ms) for some of the test cases
    reg clk, reset, read, button;
    reg [7:0] in_data;
    wire out, debounced_button;

    moore_FSM uut(out, clk, reset, read, in_data);
    debouncer deb(clk , button, debounced_button);

    // Clock 10ns
    initial begin
        clk = 0;
        forever #((CLK_PERIOD)/2) clk = ~clk;
    end

    initial begin
        #5 reset = 1;
        read = 0;
        button = 0;
        in_data = 8'b0;
 
        #5 reset = 0;
        #20;

        // Case 1: Press button 
        button = 1;
        #100 button = 0;
        
        // Case 1a: Press button again
        #50 button = 1;
        #(DELAY_COUNT * CLK_PERIOD * 2); button = 0; // wait 2x longer than debounce time to guaruntee the clean output comes out.
        

        //Case 2: Set input data, trigger read, and check output  (implementing moore machine) - we also ran on board to test this one
        #20 in_data = 8'b10101010;
        #20 read = 1;
        #20 read = 0;

        // Case 3: Rapid button toggling
        #10 button = 1;
        #5 button = 0; // Quick toggle
        #5 button = 1;
        #150 button = 0; // Should only debounce after DELAY_COUNT
        
        // Case 4: more buttons
        #50 button = 1;
        #70 button = 0;
        #70 button = 1;
        #150 button = 0;
        
        #50 $finish;
    end

endmodule