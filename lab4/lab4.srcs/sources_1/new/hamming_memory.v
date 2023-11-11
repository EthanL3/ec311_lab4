`timescale 1ns / 1ps

module hamming_memory(
        Address,
   	    MemRead, 
		ReadData,
    	MemWrite,
		WriteData,
		err
    );
    
input MemRead, MemWrite; 
input [8:0] Address; // 9 bit address, largest is 511
input [15:0]   WriteData;
output reg [15:0]  ReadData;
output reg err;     // set this error flag only for double-errors (which are uncorrectable)

// If you need extra registers, you can instantiate them here.
// 
// YOUR CODE HERE 
reg [21:0] data_with_parity = 22'b0;
reg [4:0] check_bits;


// 512 entries in RAM. Instantiate memory.
localparam MEM_DEPTH = 1 << 9;
reg [21:0] ram[0:MEM_DEPTH-1]; // 16 bits + 5 parity bits

// bit position:  1   2     3   4    5  6  7    8   9 10 11 12 13 14 15  16   17 ... 21
// value:         p_1 p_2 data p_4  |< data >| p_8 |<------ data ---->| p_16  |< data >|

/* Initialize memory. Do not modify. */
integer i;
initial begin
	for (i=0;i<MEM_DEPTH;i=i+1) begin
		ram[i] = 0;
	end
end

always@(MemRead or MemWrite or Address or WriteData) begin
    
	if (MemRead) begin
		//ReadData = ram[Address];
		// Currently, the above line just reads the data from the memory at that address.
		// Comment out that line and add your error-correcting code according to the instructions
		// You should be outputting to "ReadData" at the end.
		// 
        // YOUR CODE HERE 
        // 
        check_bits = {ram[1], ram[2], ram[3], ram[7], ram[15]};
       // if (check_bits != 5'b00000) //means there is some error
        //begin
            //error in a bit that is NOT a check bit so invert it
            if (!(check_bits == 5'd0 || check_bits == 5'd1 || check_bits == 5'd3 || check_bits == 5'd7 || check_bits == 5'd15))
                if(ram[21] ==0) begin
                    //double errror
                    err=1;
                end else begin //c=1 and p=1 single error correction
                    ram[check_bits] = ~ram[check_bits];
                    err=0;   
                end    
           
            // correct, read in data
        else begin
            ReadData = ram[Address];
           // err=1;
        end 


    

    // Extract data from ram and assign to ReadData
    // Assuming data bits are at positions 3, 5-7, 9-15, 17-21 in ram
    ReadData = {ram[Address][20:16], ram[Address][14:8], ram[Address][6:4], ram[Address][2]};
end



	if (MemWrite) begin
		//ram[Address] = WriteData;
		// Currently, the above line just writes the data to the memory at that address.
		// Comment out that line and add your parity-bits code according to the instructions.
		// You should be setting all 22 bits of ram[Address].
		// 
        // YOUR CODE HERE 
        // 

        // Initialize data_with_parity with zeros
       // data_with_parity = 22'b0;

        // Place data bits into their positions excluding parity bits
        data_with_parity[2] = WriteData[15];
        data_with_parity[6:4] = WriteData[14:12];
        data_with_parity[14:8] = WriteData[11:5];
        data_with_parity[20:16] = WriteData[4:0];


        // Calculate individual parity bits
          // P1 Calculation (C1 = XOR of bits 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
        data_with_parity[0] = ram[Address][2] ^ ram[Address][4] ^ ram[Address][6] ^ ram[Address][8] ^
                              ram[Address][10] ^ ram[Address][12] ^ ram[Address][14] ^ ram[Address][16] ^
                              ram[Address][18] ^ ram[Address][20];

        // P2 Calculation (C2 = XOR of bits 2, 3, 6, 7, 10, 11, ...)
        data_with_parity[1] = ram[Address][2] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][9] ^
                              ram[Address][10] ^ ram[Address][13] ^ ram[Address][14] ^ ram[Address][17] ^
                              ram[Address][18];

        // P4 Calculation (C4 = XOR of bits 4, 5, 6, 11, 12, 13, 14, 19, 20, 21)
        data_with_parity[3] = ram[Address][4] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][10] ^
                              ram[Address][11] ^ ram[Address][12] ^ ram[Address][13] ^ ram[Address][18] ^
                              ram[Address][19] ^ ram[Address][20];

        // P8 Calculation (C8 = XOR of bits 8, 9, 10, 11, 12, 13, 14, ...)
        data_with_parity[7] = ram[Address][8] ^ ram[Address][9] ^ ram[Address][10] ^ ram[Address][11] ^
                              ram[Address][12] ^ ram[Address][13] ^ ram[Address][14];

        // P16 Calculation (C16 = XOR of bits 16, 17, 18, 19, 20, 21)
        data_with_parity[15] = ram[Address][16] ^ ram[Address][17] ^ ram[Address][18] ^ ram[Address][19] ^
                               ram[Address][20] ^ ram[Address][21];


        // Calculate the overall parity bit (22nd bit)
        data_with_parity[21] = ^data_with_parity[20:0];

        // Write the 22-bit word with parity bits to memory
        ram[Address] = data_with_parity;
		
	end
end

endmodule
