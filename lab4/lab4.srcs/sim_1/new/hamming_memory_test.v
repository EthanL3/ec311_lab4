`timescale 1ns / 1ps

// DO NOT MODIFY
// DO NOT MODIFY
// DO NOT MODIFY

module hamming_memory_test(

    );
    
reg    clock; 
reg    MemRead, MemWrite; 
reg    [8:0]  Address;
reg    [15:0] WriteData;
wire   [15:0] ReadData;
wire err;
integer i;

hamming_memory DUT (
    	.Address(Address),
   	.MemRead(MemRead), .ReadData(ReadData),
    	.MemWrite(MemWrite), .WriteData(WriteData),
    	.err(err)
); 

// Clock generator
always #1 clock = ~clock;

initial begin
// DO NOT MODIFY
// DO NOT MODIFY
// DO NOT MODIFY
  clock = 0;
  MemWrite = 0;
  MemRead  = 0;
  $display (" --- Start --- ");
  repeat (1) @ (negedge clock);
  
  /* Single error correction tests */
  // iterate through all 22 bits in the register.
  for (i=0; i < 22; i=i+1) begin
      // write some data to address 0x0.
      WriteData  <= 16'he427;
      Address    <= 0;  
      MemRead    <= 1'b0;
      MemWrite   <= 1'b1;
      repeat (1) @ (negedge clock);
  
      // flip the ith bit in memory (simulate data corruption).
      DUT.ram[0][i] = ~DUT.ram[0][i];
      repeat (1) @ (negedge clock);
      
      // read back the data at address 0x0.
      Address      <= 0;  
      MemRead      <= 1'b1;
      MemWrite     <= 1'b0;
      repeat (1) @ (negedge clock);
  end
  
  /* Double error correction test */
  // write some data to address 0x0.
  WriteData  <= 16'he427;
  Address    <= 0;  
  MemRead    <= 1'b0;
  MemWrite   <= 1'b1;
  repeat (1) @ (negedge clock);

  // simulate a double error.
  DUT.ram[0][4] = ~DUT.ram[0][4];
  DUT.ram[0][14] = ~DUT.ram[0][14];
  repeat (1) @ (negedge clock);
  
  // try to read back the data at address 0x0. 
  // We should get an error.
  Address      <= 0;  
  MemRead      <= 1'b1;
  MemWrite     <= 1'b0;
  repeat (1) @ (negedge clock);

end
  
  
always @ (negedge clock) begin 
    	$display ("MemWrite [%b], Address [%h] WriteData [%h]",MemWrite, Address, WriteData); 
    	$display ("MemRead  [%b], Address [%h] ReadData  [%h]",MemRead,  Address, ReadData);
end

initial #150 $finish;

endmodule
