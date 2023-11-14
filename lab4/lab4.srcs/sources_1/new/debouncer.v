module debouncer(
    input wire clk,     
    input wire rst,     
    input wire button,  //Button input
    output reg debounced_button  //Debounced button output
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
        if (debounce_counter == DELAY_COUNT)
            debounce_counter <= 16'b0;
        else
            debounce_counter <= debounce_counter + 1;
    end
end

always @(posedge clk or posedge rst) begin
    case (state)
        2'b00: begin // IDLE state
            if (button == 1'b0) begin
                next_state <= 2'b01; // Move to PRESSED state
            end else begin
                next_state <= 2'b00; // Stay in IDLE state
            end
        end

        2'b01: begin // PRESSED state
            if (button == 1'b0 && debounce_counter == DELAY_COUNT) begin
                next_state <= 2'b10; // Move to RELEASE_DETECTED state
            end else if (button == 1'b1) begin
                next_state <= 2'b01; // Stay in PRESSED state
            end else begin
                next_state <= 2'b00; // Move to IDLE state
            end
        end

        2'b10: begin // RELEASE_DETECTED state
            if (button == 1'b1 && debounce_counter == DELAY_COUNT) begin
                next_state <= 2'b00; // Move to IDLE state
            end else if (button == 1'b0) begin
                next_state <= 2'b10; // Stay in RELEASE_DETECTED state
            end else begin
                next_state <= 2'b01; // Move to PRESSED state
            end
        end

        default: next_state <= 2'b00;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        debounced_button <= 1'b0;
    end else begin
        case (state)
            2'b10: debounced_button <= 1'b1; // Output 1 when RELEASE_DETECTED
            default: debounced_button <= 1'b0; // Output 0 otherwise
        endcase
    end
end

endmodule
