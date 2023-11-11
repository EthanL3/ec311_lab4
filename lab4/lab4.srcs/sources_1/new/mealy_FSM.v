`timescale 1ns / 1ps

module mealy_FSM(in, out, clk);
    input clk, in;
    output reg out;
    
    reg [2:0] current_state, next_state;
    
    parameter S0 = 0, S1 = 1, S2 = 2;
    
    initial current_state = S0;
    always @(in or current_state) begin
        case(current_state)
            S0: 
                if(in)
                     next_state = S1;
                else
                    next_state = S2;            
            S1:
                if(in)
                    next_state = S1;
                else
                    next_state = S2;
            S2:
                if(in)
                    next_state = S1;
                else
                    next_state = S2;
        endcase
    end 
    
    always @(posedge clk) begin
        current_state <= next_state;
        case(current_state)
            S0:
                out = 0;
            S1:
                out = 1;
            S2:
                out = 0;
         endcase
    end
endmodule
