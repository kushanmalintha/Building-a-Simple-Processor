module twosComplement(ip_number , op_number);
    // Define a module named 'complementNegNums' with input 'ip_number' and output 'op_number'
    input [7:0] ip_number; // Define an 8-bit input named 'ip_number'
    output [7:0] op_number; // Define an 8-bit output named 'op_number'

    // Assign output 'op_number' the complement of input 'ip_number' plus 1
    assign #1 op_number = ~ip_number + 8'b00000001;
endmodule
