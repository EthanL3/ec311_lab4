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
reg [21:0] data_with_parity = 22'b0; // for write mode
reg [4:0] check_bits; // for read mode
reg [22:0] parity_all; // for read mode

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
		// ReadData = ram[Address];
		// Currently, the above line just reads the data from the memory at that address.
		// Comment out that line and add your error-correcting code according to the instructions
		// You should be outputting to "ReadData" at the end.
        
        // C1 (P1): XOR of bits (1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
        check_bits[0] = ram[Address][2] ^ ram[Address][4] ^ ram[Address][6] ^ ram[Address][8] ^
                        ram[Address][10] ^ ram[Address][12] ^ ram[Address][14] ^ ram[Address][16] ^
                        ram[Address][18] ^ ram[Address][20];

        // C2 (P2): XOR of bits (2, 3, 6, 7, 10, 11, ...)
        check_bits[1] = ram[Address][2] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][9] ^
                        ram[Address][10] ^ ram[Address][13] ^ ram[Address][14] ^ ram[Address][17] ^ ram[Address][18];


        // C4 (P4): XOR of bits (4, 5, 6, 11, 12, 13, 14, 19, 20, 21)
        check_bits[2] = ram[Address][4] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][11] ^
                        ram[Address][12] ^ ram[Address][13] ^ ram[Address][14] ^ ram[Address][19] ^ ram[Address][20];

        // C8 (P8): XOR of bits (8, 9, 10, 11, 12, 13, 14, ...)
        check_bits[3] = ram[Address][8] ^ ram[Address][9] ^ ram[Address][10] ^ ram[Address][11] ^
                        ram[Address][12] ^ ram[Address][13] ^ ram[Address][14];

        // C16 (P16): XOR of bits (16, 17, 18, 19, 20, 21)
        check_bits[4] = ram[Address][16] ^ ram[Address][17] ^ ram[Address][18] ^ ram[Address][19] ^ ram[Address][20];

        // Calculate overall parity (P)
        parity_all = ^ram[Address][21:0];

        
        if ( check_bits != 0 ) begin
            if (parity_all) begin // C = 1 P = 1 - one error
                err=0;

                // error in a bit that is NOT a check bit so invert it
                if (!(check_bits == 5'd1 || check_bits == 5'd2 || check_bits == 5'd4 || check_bits == 5'd8 || check_bits == 5'd16)) begin
                    ram[Address][check_bits-1] = ~ram[Address][check_bits-1];
                end

            end 
            else begin // C = 1 P = 0 - two errors
                err = 1;
            end
        end else begin // C = 0 P = 1 - error in parity bit (do nothing)
            if (parity_all) begin
                err = 1;
            end else begin // C = 0 P = 0 - no error
                    err = 0;
            end
        end
        

        
        //ReadData = {ram[Address][16], ram[Address][17], ram[Address][18], ram[Address][19], ram[Address][20], // 20:16
         //   ram[Address][8], ram[Address][9], ram[Address][10], ram[Address][11], ram[Address][12], ram[Address][13], ram[Address][14], // 14:8
         //   ram[Address][4], ram[Address][5], ram[Address][6], // 6:4
         //   ram[Address][2]}; // bit 2

         ReadData = {
            ram[Address][16],    // bit 13 of WriteData
            ram[Address][17],    // bit 12 of WriteData
            ram[Address][18],    // bit 11 of WriteData
            ram[Address][19],    // bit 10 of WriteData
            ram[Address][20],    // bit 9 of WriteData
            ram[Address][7],     // bit 8 of WriteData
            ram[Address][9],     // bit 7 of WriteData
            ram[Address][10],    // bit 6 of WriteData
            ram[Address][11],    // bit 5 of WriteData
            ram[Address][12],    // bit 4 of WriteData
            ram[Address][13],    // bit 3 of WriteData
            ram[Address][3],     // bit 2 of WriteData
            ram[Address][4],     // bit 1 of WriteData
            ram[Address][5],     // bit 0 of WriteData
            ram[Address][2]      // LSB of WriteData
        };


    end

	if (MemWrite) begin
		// ram[Address] = WriteData;
		// Currently, the above line just writes the data to the memory at that address.
		// Comment out that line and add your parity-bits code according to the instructions.
		// You should be setting all 22 bits of ram[Address].

        // Place data bits into their positions excluding parity bits
        //data_with_parity[2] = WriteData[15];
        //data_with_parity[6:4] = WriteData[14:12];
        //data_with_parity[14:8] = WriteData[11:5];
        //data_with_parity[20:16] = WriteData[4:0];


        data_with_parity[2] = WriteData[15];
        data_with_parity[5:3] = WriteData[14:12]; // Adjusted to avoid P4
        data_with_parity[13:9] = WriteData[11:7]; // Adjusted to avoid P8
        data_with_parity[7] = WriteData[6];       // Filling the skipped bit after P8
        data_with_parity[20:16] = WriteData[4:0];

        // Calculates individual parity bits for write mode
        // P1 (C1 = XOR of bits 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
        data_with_parity[0] = ram[Address][2] ^ ram[Address][4] ^ ram[Address][6] ^ ram[Address][8] ^
                              ram[Address][10] ^ ram[Address][12] ^ ram[Address][14] ^ ram[Address][16] ^
                              ram[Address][18] ^ ram[Address][20];

        // P2 (C2 = XOR of bits 2, 3, 6, 7, 10, 11, ...)
        data_with_parity[1] = ram[Address][2] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][9] ^
                              ram[Address][10] ^ ram[Address][13] ^ ram[Address][14] ^ ram[Address][17] ^
                              ram[Address][18];

        // P4 (C4 = XOR of bits 4, 5, 6, 11, 12, 13, 14, 19, 20, 21)
        data_with_parity[3] = ram[Address][4] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][10] ^
                              ram[Address][11] ^ ram[Address][12] ^ ram[Address][13] ^ ram[Address][18] ^
                              ram[Address][19] ^ ram[Address][20];

        // P8 (C8 = XOR of bits 8, 9, 10, 11, 12, 13, 14, ...)
        data_with_parity[7] = ram[Address][8] ^ ram[Address][9] ^ ram[Address][10] ^ ram[Address][11] ^
                              ram[Address][12] ^ ram[Address][13] ^ ram[Address][14];

        // P16 (C16 = XOR of bits 16, 17, 18, 19, 20, 21)
        data_with_parity[15] = ram[Address][16] ^ ram[Address][17] ^ ram[Address][18] ^ ram[Address][19] ^
                               ram[Address][20] ^ ram[Address][21];


        // overall parity bit P22
        data_with_parity[21] = ^data_with_parity[20:0];

        // save our temp data_with_parity to ram
        ram[Address] = data_with_parity;
		
	end
end

endmodule
