module debouncer(
    input wire clk,     
    input wire rst,     
    input wire button,  //Button input
    output reg debounced_button,  //Debounced button output
    input [7:0] in,
    output out
);
reg [1:0] state, next_state;
// Parameter for debounce delay (adjust this based on your clock frequency)
parameter DELAY_COUNT = 50000;  // You may need to adjust this value
reg [15:0] debounce_counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 2'b00;
        debounce_counter <= 16'b0;
    end else begin
        state <= next_state;
        debounce_counter <= debounce_counter + 1;
    end
end
//add state logic with IDLE being 2'b00, PRESSED being 2'b01, and RELEASED as 2'b10
parameter i = 2'b00, p = 2'b01, r = 2'b10;
always @(posedge clk or posedge rst) begin
    case (state)
        2'b00: begin // IDLE state
            if (button == 1'b0) begin
                next_state <= i; //fill in missing next state
            end else begin
                next_state <= p;//fill in missing next state
            end
        end

        2'b01: begin // PRESSED state
            if (button == 1'b0 && debounce_counter == DELAY_COUNT) begin
                next_state <= r; //fill in next state
            end else if (button == 1'b1) begin
                next_state <= p ;//fill in next state
            end else begin
                next_state <= r ;//fill in next state
            end
        end

        2'b10: begin // RELEASE_DETECTED state
            if (button == 1'b1 && debounce_counter == DELAY_COUNT) begin
                next_state <=  i;//fill in next state
            end else if (button == 1'b0) begin
                next_state <= r; //fill in next state
            end else begin
                next_state <= i; //fill in next state
            end
        end

        default: next_state <= 2'b00;
    endcase
end

//below is where debounced signal is outputted
always @(posedge clk or posedge rst) begin
    if (rst) begin
        debounced_button <= 1'b0;
    end else begin
        case (state)
            2'b10: debounced_button <= 1'b1; //Output 1 when RELEASED
            default: debounced_button <= 1'b0; //Output 0 otherwise
        endcase
    end
end
endmodule
