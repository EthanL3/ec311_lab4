`timescale 1ns / 1ps

module moore_FSM(out, clk, reset, read, in);
    input clk, reset, read; 
    input [7:0] in;
    output reg out;
    
    reg [2:0] p;
    reg [2:0] present_state, next_state;
    
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    
    initial present_state = S3;
    
    always @(reset or read or present_state) begin
        case(present_state)
            S0: if(reset)              
                    next_state = S3;
                else if(read && !reset)           
                    next_state = S1;
                else if (!read && !reset)
                    next_state = S0;
            S1: next_state = S2;
            S2: next_state = S0;
            S3: next_state = S0;  
        endcase
    end 
    always @(posedge clk) begin
        present_state <= next_state;
        case(present_state)
            S1: out <= in[p];
            S2: p <= p + 1;
            S3: begin
                p <= 0;
                out <= 0;
                end
        endcase
    end
endmodule

