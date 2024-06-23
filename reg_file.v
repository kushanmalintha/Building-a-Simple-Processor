module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);
    input [7:0] IN; // Input data
    input [2:0] INADDRESS; // Input address
    input WRITE, CLK, RESET; // Write control, clock, and reset signals
    input [2:0] OUT1ADDRESS, OUT2ADDRESS; // Output addresses
    output [7:0] OUT1, OUT2; // Output data

    reg [7:0] registers [7:0]; // Array of 8-bit registers

    // reading data asynchronusly
    assign #2 OUT1 = registers[OUT1ADDRESS]; // Output 1 based on specified address
    assign #2 OUT2 = registers[OUT2ADDRESS]; // Output 2 based on specified address

    always @(posedge CLK) begin // On positive clock edge
        if (RESET == 1'b1) begin // Reset condition
            for (integer i=0; i<8; i++) begin // Loop through all registers
                registers[i] = 8'b00000000; // Initialize each register to 0
            end
        end else if (WRITE == 1'b1) begin // Write operation
            #1 registers[INADDRESS] = IN; // Write input data to specified address
        end

    end

endmodule