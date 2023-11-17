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
reg [21:0] data_with_parity; // for write mode
reg [4:0] check_bits; // for read mode
reg parity_all; // for read mode
integer error_position; //for indexing where an error is found


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
        
        // C1: XOR of bits (3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
        check_bits[0] = ram[Address][0] ^ram[Address][2] ^ ram[Address][4] ^ ram[Address][6] ^ ram[Address][8] ^ ram[Address][10] ^ ram[Address][12] ^ ram[Address][14] ^ ram[Address][16] ^ ram[Address][18] ^ ram[Address][20];

        // C2: XOR of bits (3, 6, 7, 10, 11, 14, 15, 18, 19)
        check_bits[1] = ram[Address][1] ^ ram[Address][2] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][9] ^ ram[Address][10] ^ ram[Address][13] ^ ram[Address][14] ^ ram[Address][17] ^ ram[Address][18];

        // C4: XOR of bits (5, 6, 7, 12, 13, 14, 15, 20, 21)
        check_bits[2] = ram[Address][3] ^ ram[Address][4] ^ ram[Address][5] ^ ram[Address][6] ^ ram[Address][11] ^ ram[Address][12] ^ ram[Address][13] ^ ram[Address][14] ^ ram[Address][19] ^ ram[Address][20];

        // C8: XOR of bits (9, 10, 11, 12, 13, 14, 15)
        check_bits[3] = ram[Address][7] ^ ram[Address][8] ^ ram[Address][9] ^ ram[Address][10] ^ ram[Address][11] ^ ram[Address][12] ^ ram[Address][13] ^ ram[Address][14];

        // C16: XOR of bits (17, 18, 19, 20, 21)
        check_bits[4] = ram[Address][15] ^ ram[Address][16] ^ ram[Address][17] ^ ram[Address][18] ^ ram[Address][19] ^ ram[Address][20];

        // Calculate overall parity (P)
        parity_all = ^ram[Address][20:0];
        
        // Error detection  and correction
        error_position = check_bits[0] + check_bits[1]*2 + check_bits[2]*4 + check_bits[3]*8 + check_bits[4]*16;

        if (error_position != 0) begin // Error detected
            if (parity_all) begin // C=1 P=1 - single error pls correct
                ram[Address][error_position - 1] = ~ram[Address][error_position - 1];
                err = 0;
            end else begin // C=1 P=0 - double error cannot correct
                err = 1;
            end
        end else begin
            if (parity_all) begin // C=0 P=1 - parity error
                err = 0;
            end else begin // C=0 P=0 - no error
                err = 0;
            end
        end    

        // ReadData assignment
        ReadData = {
            ram[Address][20], // Data bit 15
            ram[Address][19], // Data bit 14
            ram[Address][18], // Data bit 13
            ram[Address][17], // Data bit 12
            ram[Address][16], // Data bit 11
            ram[Address][14], // Data bit 10
            ram[Address][13], // Data bit 9
            ram[Address][12], // Data bit 8
            ram[Address][11], // Data bit 7
            ram[Address][10], // Data bit 6
            ram[Address][9],  // Data bit 5
            ram[Address][7],  // Data bit 4
            ram[Address][6],  // Data bit 3
            ram[Address][5],  // Data bit 2
            ram[Address][4],  // Data bit 1
            ram[Address][2]   // Data bit 0
        };

    end

	if (MemWrite) begin
		// ram[Address] = WriteData;
		// Currently, the above line just writes the data to the memory at that address.
		// Comment out that line and add your parity-bits code according to the instructions.
		// You should be setting all 22 bits of ram[Address].

        // Place data bits into their positions excluding parity bits
        data_with_parity[2] = WriteData[0];
        data_with_parity[4] = WriteData[1];
        data_with_parity[5] = WriteData[2];
        data_with_parity[6] = WriteData[3];
        data_with_parity[8] = WriteData[4];
        data_with_parity[9] = WriteData[5];
        data_with_parity[10] = WriteData[6];
        data_with_parity[11] = WriteData[7];
        data_with_parity[12] = WriteData[8];
        data_with_parity[13] = WriteData[9];
        data_with_parity[14] = WriteData[10];
        data_with_parity[16] = WriteData[11];
        data_with_parity[17] = WriteData[12];
        data_with_parity[18] = WriteData[13];
        data_with_parity[19] = WriteData[14];
        data_with_parity[20] = WriteData[15];

        // Calculate individual parity bits for write mode
        // P1 (parity for bits 3, 5, 7, 9, 11, 13, 15, 17, 19, 21)
        data_with_parity[0] = data_with_parity[2] ^ data_with_parity[4] ^ data_with_parity[6] ^ data_with_parity[8] ^ data_with_parity[10] ^ data_with_parity[12] ^ data_with_parity[14] ^ data_with_parity[16] ^ data_with_parity[18] ^ data_with_parity[20];

        // P2 (parity for bits 3, 6, 7, 10, 11, 14, 15, 18, 19)
        data_with_parity[1] = data_with_parity[2] ^ data_with_parity[5] ^ data_with_parity[6] ^ data_with_parity[9] ^ data_with_parity[10] ^ data_with_parity[13] ^ data_with_parity[14] ^ data_with_parity[17] ^ data_with_parity[18];

        // P4 (parity for bits 5, 6, 7, 12, 13, 14, 15, 20, 21)
        data_with_parity[3] = data_with_parity[4] ^ data_with_parity[5] ^ data_with_parity[6] ^ data_with_parity[11] ^ data_with_parity[12] ^ data_with_parity[13] ^ data_with_parity[14] ^ data_with_parity[19] ^ data_with_parity[20];

        // P8 (parity for bits 9, 10, 11, 12, 13, 14, 15)
        data_with_parity[7] = data_with_parity[8] ^ data_with_parity[9] ^ data_with_parity[10] ^ data_with_parity[11] ^ data_with_parity[12] ^ data_with_parity[13] ^ data_with_parity[14];

        // P16 (parity for bits 17, 18, 19, 20, 21)
        data_with_parity[15] = data_with_parity[16] ^ data_with_parity[17] ^ data_with_parity[18] ^ data_with_parity[19] ^ data_with_parity[20];

        // Calculate overall parity bit (XOR of all bits)
        data_with_parity[21] = ^data_with_parity[20:0];

        // Save the data with parity bits to RAM
        ram[Address] = data_with_parity;
	end
end

endmodule
