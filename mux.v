module mux(DATA1 , DATA2 , SELECT, OUTPUT);
    // Declare module 'mux' with four ports: OUTPUT, DATA1, DATA2, and SELECT
    input [7:0] DATA1 , DATA2;  // Define two 8-bit input data ports: DATA1 and DATA2
    input SELECT; // Define a single-bit input select port: SELECT
    output reg [7:0] OUTPUT; // Define an 8-bit output register: OUTPUT

    always @(DATA1 , DATA2 , SELECT)
    begin
        // Start of combinational logic block triggered by changes in DATA1, DATA2, or SELECT
        case(SELECT)
            1'b0 : OUTPUT = DATA1; // If SELECT is 0, OUTPUT receives DATA1
            1'b1 : OUTPUT = DATA2; // If SELECT is 1, OUTPUT receives DATA2
        endcase
    end
endmodule

// Use to select PC+4 OR PC+OFFSET
module mux32bit(DATA1, DATA2, SELECT, OUTPUT);
    // Declare module 'mux32bit' with four ports: OUTPUT, DATA1, DATA2, and SELECT
    input [31:0] DATA1, DATA2; // Define two 32-bit input data ports: DATA1 and DATA2
    input SELECT; // Define a single-bit input select port: SELECT
    output reg [31:0] OUTPUT; // Define an 32-bit output register: OUTPUT

    always @(DATA1, DATA2, SELECT)
    begin
        // Start of combinational logic block triggered by changes in DATA1, DATA2, or SELECT
        case(SELECT)
            1'b0 : assign OUTPUT = DATA1; // If SELECT is 0, OUTPUT receives DATA1
            1'b1 : assign OUTPUT = DATA2; // If SELECT is 1, OUTPUT receives DATA2
        endcase
    end
endmodule