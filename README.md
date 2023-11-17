James Conlon 
U23459610

Ethan Levine 
U71700384

TF: Bobby

For this lab the important thing to note is we included 2 moore_fsm modules since we modifed the moore machine to implement a debounced input. So we named one file moore_FSM_OG.v and one file moore_FSM.v. 

The "OG" original moore machine file does not use debounced input and the other one does use a debounced input. We managed to run this debounced machine on the FPGA as well using debounced buttons.

The section that took us the longest was the 4th problem because we were calculating partity bits using the ram address. This took a long time to debug the error but we managed to fix it by making sure we calcualted the parity bits with the data_with_parity reg and not using ram. We tried rewriting a lot of the section before realizing that this was the source of the error.

The rest of the lab went well and it was fairly easy to modify the original moore machine to be debounced and debounce direct on the FPGA.

Contribution summary:
We worked together on 1, 2, 3
James finished an error in 3 and did all of 4.
Ethan did all of 5 but we worked together to modify the moore machine for 5. We both finished 5 in lab.

Files submitted:
moore_FSM_OG.v // added
moore_FSM_tb.v
mealy_FSM.v
mealy_FSM_tb.v
RCA_nbit.v
RCA_verification.v
RCA_32bit_tb.v
hamming_memory_test.v
hamming_memory.v
hamming_memory_waveform.png
debouncer.v
FSM_debounced_tb.v
moore_FSM.v
README.md
