module alu(DATA1, DATA2, RESULT, ZERO, SELECT, SHIFT_op, AMOUNT);

    input [7:0] DATA1, DATA2; // Inputs for data to be operated on
    input [2:0] SELECT; // Input to select the operation
    output reg [7:0] RESULT; // Output for the result of the operation
    output ZERO; // Output indicating whether the result is zero
    input SHIFT_op; // Shift operation selector: 1 for SLL, 0 for SLR
    input [2:0] AMOUNT; // Amount for shifting operations

    // Internal wires to hold intermediate results of different operations
    wire [7:0] forward_data, add_data, and_data, or_data, mult_data, shift_data, sra_data, ror_data;

    // Instantiate modules for each operation
    FORWARD forward_inst (DATA1, DATA2, forward_data);
    ADD add_inst (DATA1, DATA2, add_data);
    AND and_inst (DATA1, DATA2, and_data);
    OR or_inst (DATA1, DATA2, or_data);
    MULT mult_inst (DATA1, DATA2, mult_data);
    SHIFT shift_inst (DATA1, DATA2, shift_data, SHIFT_op, AMOUNT);
    SRA sra_inst (DATA1, DATA2, sra_data, AMOUNT);
    ROR ror_inst (DATA1, DATA2, ror_data, AMOUNT);

    // Logic to select the operation based on the value of SELECT
    always @(*) begin
        case(SELECT)
            3'b000 : #1 RESULT = forward_data;   // Select forward operation
            3'b001 : #2 RESULT = add_data;       // Select addition operation
            3'b010 : #1 RESULT = and_data;       // Select AND operation
            3'b011 : #1 RESULT = or_data;        // Select OR operation
            3'b100 : #3 RESULT = mult_data;      // Select MUL operation
            3'b101 : #2 RESULT = shift_data;     // Select SHIFT operation
            3'b110 : #2 RESULT = sra_data;       // Select SRA operation
            3'b111 : #2 RESULT = ror_data;       // Select ROR operation
            default : ; // No operation selected
        endcase
    end

    // Compute the ZERO output based on the result bits using an assign statement
    assign ZERO = (RESULT == 8'b00000000);

endmodule

// Module for forwarding operation
module FORWARD(DATA1, DATA2, RESULT);

    input [7:0] DATA1, DATA2; // Inputs
    output [7:0] RESULT; // Output
    assign RESULT = DATA2; // Result is equal to DATA2

endmodule

// Module for addition operation
module ADD(DATA1, DATA2, RESULT);

    input [7:0] DATA1, DATA2; // Inputs
    output [7:0] RESULT; // Output
    assign RESULT = DATA2 + DATA1; // Result is sum of DATA2 and DATA1

endmodule

// Module for bitwise AND operation
module AND(DATA1, DATA2, RESULT);

    input [7:0] DATA1, DATA2; // Inputs
    output [7:0] RESULT; // Output
    assign RESULT = DATA2 & DATA1; // Result is bitwise AND of DATA2 and DATA1

endmodule

// Module for bitwise OR operation
module OR(DATA1, DATA2, RESULT);

    input [7:0] DATA1, DATA2; // Inputs
    output [7:0] RESULT; // Output
    assign RESULT = DATA2 | DATA1; // Result is bitwise OR of DATA2 and DATA1

endmodule

//Full Adder
module FullAdder(A, B, Cin, SUM, Cout);

	//Input and output port declaration
	input A, B, Cin;
	output SUM, Cout;
	
	//Combinational logic for SUM and CARRY bit outputs
	assign SUM = (A ^ B ^ Cin);
	assign Cout = (A & B) + (Cin & (A ^ B));

endmodule

//Calculates the product of two 8-bit numbers
module MULT(DATA1, DATA2, RESULT);

	//Input and output port declaration
	input signed [7:0] DATA1, DATA2;
	output signed[7:0] RESULT;
	
	//Carry bits for intermediate sums
	wire C0 [5:0];
	wire C1 [4:0];
	wire C2 [3:0];
	wire C3 [2:0];
	wire C4 [1:0];
	wire C5;
	
	//Intermediate sums
	wire sum0 [5:0];
	wire sum1 [4:0];
	wire sum2 [3:0];
	wire sum3 [2:0];
	wire sum4 [1:0];
	wire sum5;
	
	//Bus to store result before output
	wire [7:0] OUT;
	
	//First bit of RESULT can be directly set
	assign OUT[0] = DATA2[0] & DATA1[0];	
	
	
	//Full Adder array to calculate result by shifting and adding
	//Layer 0
	FullAdder FA0_0(DATA2[0] & DATA1[1], DATA2[1] & DATA1[0], 1'b0, OUT[1], C0[0]);
	FullAdder FA0_1(DATA2[0] & DATA1[2], DATA2[1] & DATA1[1], C0[0], sum0[0], C0[1]);
	FullAdder FA0_2(DATA2[0] & DATA1[3], DATA2[1] & DATA1[2], C0[1], sum0[1], C0[2]);
	FullAdder FA0_3(DATA2[0] & DATA1[4], DATA2[1] & DATA1[3], C0[2], sum0[2], C0[3]);
	FullAdder FA0_4(DATA2[0] & DATA1[5], DATA2[1] & DATA1[4], C0[3], sum0[3], C0[4]);
	FullAdder FA0_5(DATA2[0] & DATA1[6], DATA2[1] & DATA1[5], C0[4], sum0[4], C0[5]);
	FullAdder FA0_6(DATA2[0] & DATA1[7], DATA2[1] & DATA1[6], C0[5], sum0[5], );
	
	//Layer 1
	FullAdder FA1_0(sum0[0], DATA2[2] & DATA1[0], 1'b0, OUT[2], C1[0]);
	FullAdder FA1_1(sum0[1], DATA2[2] & DATA1[1], C1[0], sum1[0], C1[1]);
	FullAdder FA1_2(sum0[2], DATA2[2] & DATA1[2], C1[1], sum1[1], C1[2]);
	FullAdder FA1_3(sum0[3], DATA2[2] & DATA1[3], C1[2], sum1[2], C1[3]);
	FullAdder FA1_4(sum0[4], DATA2[2] & DATA1[4], C1[3], sum1[3], C1[4]);
	FullAdder FA1_5(sum0[5], DATA2[2] & DATA1[5], C1[4], sum1[4], );
	
	//Layer 2
	FullAdder FA2_0(sum1[0], DATA2[3] & DATA1[0], 1'b0, OUT[3], C2[0]);
	FullAdder FA2_1(sum1[1], DATA2[3] & DATA1[1], C2[0], sum2[0], C2[1]);
	FullAdder FA2_2(sum1[2], DATA2[3] & DATA1[2], C2[1], sum2[1], C2[2]);
	FullAdder FA2_3(sum1[3], DATA2[3] & DATA1[3], C2[2], sum2[2], C2[3]);
	FullAdder FA2_4(sum1[4], DATA2[3] & DATA1[4], C2[3], sum2[3], );
	
	//Layer 3
	FullAdder FA3_0(sum2[0], DATA2[4] & DATA1[0], 1'b0, OUT[4], C3[0]);
	FullAdder FA3_1(sum2[1], DATA2[4] & DATA1[1], C3[0], sum3[0], C3[1]);
	FullAdder FA3_2(sum2[2], DATA2[4] & DATA1[2], C3[1], sum3[1], C3[2]);
	FullAdder FA3_3(sum2[3], DATA2[4] & DATA1[3], C3[2], sum3[2], );
	
	//Layer 4
	FullAdder FA4_0(sum3[0], DATA2[5] & DATA1[0], 1'b0, OUT[5], C4[0]);
	FullAdder FA4_1(sum3[1], DATA2[5] & DATA1[1], C4[0], sum4[0], C4[1]);
	FullAdder FA4_2(sum3[2], DATA2[5] & DATA1[2], C4[1], sum4[1], );
	
	//Layer 5
	FullAdder FA5_0(sum4[0], DATA2[6] & DATA1[0], 1'b0, OUT[6], C5);
	FullAdder FA5_1(sum4[1], DATA2[6] & DATA1[1], C5, sum5, );
	
	//Layer 6
	FullAdder FA6_0(sum5, DATA2[7] & DATA1[0], 1'b0, OUT[7], );
	
	//Sending out result after #3 time unit delay
	assign RESULT = OUT;

endmodule

// 2x1 Mux
module mux2X1( in0,in1,sel,out);

    input in0,in1;
    input sel;
    output out;
    assign out=(sel)?in1:in0;
    
endmodule

// Module for logical shift operation
// SHIFT_op = 1 ---> SLL (Shift Left Logical)
// SHIFT_op = 0 ---> SLR (Shift Right Logical)
module SHIFT(DATA1, DATA2, RESULT, SHIFT_op, AMOUNT);

    input [7:0] DATA1, DATA2; // Inputs
    input SHIFT_op; // Shift operation selector
    input [2:0] AMOUNT; // Shift amount
    output [7:0] RESULT; // Output
    wire [7:0] sr_x, sr_y, sr_result;
    wire [7:0] sl_x, sl_y, sl_result;
    
    // 4-bit shift right
    mux2X1 sr_ins_23 (.in0(DATA1[7]), .in1(1'b0), .sel(AMOUNT[2]), .out(sr_x[7]));
    mux2X1 sr_ins_22 (.in0(DATA1[6]), .in1(1'b0), .sel(AMOUNT[2]), .out(sr_x[6]));
    mux2X1 sr_ins_21 (.in0(DATA1[5]), .in1(1'b0), .sel(AMOUNT[2]), .out(sr_x[5]));
    mux2X1 sr_ins_20 (.in0(DATA1[4]), .in1(1'b0), .sel(AMOUNT[2]), .out(sr_x[4]));
    mux2X1 sr_ins_19 (.in0(DATA1[3]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(sr_x[3]));
    mux2X1 sr_ins_18 (.in0(DATA1[2]), .in1(DATA1[6]), .sel(AMOUNT[2]), .out(sr_x[2]));
    mux2X1 sr_ins_17 (.in0(DATA1[1]), .in1(DATA1[5]), .sel(AMOUNT[2]), .out(sr_x[1]));
    mux2X1 sr_ins_16 (.in0(DATA1[0]), .in1(DATA1[4]), .sel(AMOUNT[2]), .out(sr_x[0]));
    
    // 2-bit shift right
    mux2X1 sr_ins_15 (.in0(sr_x[7]), .in1(1'b0), .sel(AMOUNT[1]), .out(sr_y[7]));
    mux2X1 sr_ins_14 (.in0(sr_x[6]), .in1(1'b0), .sel(AMOUNT[1]), .out(sr_y[6]));
    mux2X1 sr_ins_13 (.in0(sr_x[5]), .in1(sr_x[7]), .sel(AMOUNT[1]), .out(sr_y[5]));
    mux2X1 sr_ins_12 (.in0(sr_x[4]), .in1(sr_x[6]), .sel(AMOUNT[1]), .out(sr_y[4]));
    mux2X1 sr_ins_11 (.in0(sr_x[3]), .in1(sr_x[5]), .sel(AMOUNT[1]), .out(sr_y[3]));
    mux2X1 sr_ins_10 (.in0(sr_x[2]), .in1(sr_x[4]), .sel(AMOUNT[1]), .out(sr_y[2]));
    mux2X1 sr_ins_09 (.in0(sr_x[1]), .in1(sr_x[3]), .sel(AMOUNT[1]), .out(sr_y[1]));
    mux2X1 sr_ins_08 (.in0(sr_x[0]), .in1(sr_x[2]), .sel(AMOUNT[1]), .out(sr_y[0]));
    
    // 1-bit shift right
    mux2X1 sr_ins_07 (.in0(sr_y[7]), .in1(1'b0), .sel(AMOUNT[0]), .out(sr_result[7]));
    mux2X1 sr_ins_06 (.in0(sr_y[6]), .in1(sr_y[7]), .sel(AMOUNT[0]), .out(sr_result[6]));
    mux2X1 sr_ins_05 (.in0(sr_y[5]), .in1(sr_y[6]), .sel(AMOUNT[0]), .out(sr_result[5]));
    mux2X1 sr_ins_04 (.in0(sr_y[4]), .in1(sr_y[5]), .sel(AMOUNT[0]), .out(sr_result[4]));
    mux2X1 sr_ins_03 (.in0(sr_y[3]), .in1(sr_y[4]), .sel(AMOUNT[0]), .out(sr_result[3]));
    mux2X1 sr_ins_02 (.in0(sr_y[2]), .in1(sr_y[3]), .sel(AMOUNT[0]), .out(sr_result[2]));
    mux2X1 sr_ins_01 (.in0(sr_y[1]), .in1(sr_y[2]), .sel(AMOUNT[0]), .out(sr_result[1]));
    mux2X1 sr_ins_00 (.in0(sr_y[0]), .in1(sr_y[1]), .sel(AMOUNT[0]), .out(sr_result[0]));
    
    // 4-bit shift left
    mux2X1 sl_ins_23 (.in0(DATA1[7]), .in1(DATA1[3]), .sel(AMOUNT[2]), .out(sl_x[7]));
    mux2X1 sl_ins_22 (.in0(DATA1[6]), .in1(DATA1[2]), .sel(AMOUNT[2]), .out(sl_x[6]));
    mux2X1 sl_ins_21 (.in0(DATA1[5]), .in1(DATA1[1]), .sel(AMOUNT[2]), .out(sl_x[5]));
    mux2X1 sl_ins_20 (.in0(DATA1[4]), .in1(DATA1[0]), .sel(AMOUNT[2]), .out(sl_x[4]));
    mux2X1 sl_ins_19 (.in0(DATA1[3]), .in1(1'b0), .sel(AMOUNT[2]), .out(sl_x[3]));
    mux2X1 sl_ins_18 (.in0(DATA1[2]), .in1(1'b0), .sel(AMOUNT[2]), .out(sl_x[2]));
    mux2X1 sl_ins_17 (.in0(DATA1[1]), .in1(1'b0), .sel(AMOUNT[2]), .out(sl_x[1]));
    mux2X1 sl_ins_16 (.in0(DATA1[0]), .in1(1'b0), .sel(AMOUNT[2]), .out(sl_x[0]));

    // 2-bit shift left
    mux2X1 sl_ins_15 (.in0(sl_x[7]), .in1(sl_x[5]), .sel(AMOUNT[1]), .out(sl_y[7]));
    mux2X1 sl_ins_14 (.in0(sl_x[6]), .in1(sl_x[4]), .sel(AMOUNT[1]), .out(sl_y[6]));
    mux2X1 sl_ins_13 (.in0(sl_x[5]), .in1(sl_x[3]), .sel(AMOUNT[1]), .out(sl_y[5]));
    mux2X1 sl_ins_12 (.in0(sl_x[4]), .in1(sl_x[2]), .sel(AMOUNT[1]), .out(sl_y[4]));
    mux2X1 sl_ins_11 (.in0(sl_x[3]), .in1(sl_x[1]), .sel(AMOUNT[1]), .out(sl_y[3]));
    mux2X1 sl_ins_10 (.in0(sl_x[2]), .in1(sl_x[0]), .sel(AMOUNT[1]), .out(sl_y[2]));
    mux2X1 sl_ins_09 (.in0(sl_x[1]), .in1(1'b0), .sel(AMOUNT[1]), .out(sl_y[1]));
    mux2X1 sl_ins_08 (.in0(sl_x[0]), .in1(1'b0), .sel(AMOUNT[1]), .out(sl_y[0]));

    // 1-bit shift left
    mux2X1 sl_ins_07 (.in0(sl_y[7]), .in1(sl_y[6]), .sel(AMOUNT[0]), .out(sl_result[7]));
    mux2X1 sl_ins_06 (.in0(sl_y[6]), .in1(sl_y[5]), .sel(AMOUNT[0]), .out(sl_result[6]));
    mux2X1 sl_ins_05 (.in0(sl_y[5]), .in1(sl_y[4]), .sel(AMOUNT[0]), .out(sl_result[5]));
    mux2X1 sl_ins_04 (.in0(sl_y[4]), .in1(sl_y[3]), .sel(AMOUNT[0]), .out(sl_result[4]));
    mux2X1 sl_ins_03 (.in0(sl_y[3]), .in1(sl_y[2]), .sel(AMOUNT[0]), .out(sl_result[3]));
    mux2X1 sl_ins_02 (.in0(sl_y[2]), .in1(sl_y[1]), .sel(AMOUNT[0]), .out(sl_result[2]));
    mux2X1 sl_ins_01 (.in0(sl_y[1]), .in1(sl_y[0]), .sel(AMOUNT[0]), .out(sl_result[1]));
    mux2X1 sl_ins_00 (.in0(sl_y[0]), .in1(1'b0), .sel(AMOUNT[0]), .out(sl_result[0]));

    
    // Select between shift right and shift left based on SHIFT_op
    mux2X1 result_mux_7 (.in0(sr_result[7]), .in1(sl_result[7]), .sel(SHIFT_op), .out(RESULT[7]));
    mux2X1 result_mux_6 (.in0(sr_result[6]), .in1(sl_result[6]), .sel(SHIFT_op), .out(RESULT[6]));
    mux2X1 result_mux_5 (.in0(sr_result[5]), .in1(sl_result[5]), .sel(SHIFT_op), .out(RESULT[5]));
    mux2X1 result_mux_4 (.in0(sr_result[4]), .in1(sl_result[4]), .sel(SHIFT_op), .out(RESULT[4]));
    mux2X1 result_mux_3 (.in0(sr_result[3]), .in1(sl_result[3]), .sel(SHIFT_op), .out(RESULT[3]));
    mux2X1 result_mux_2 (.in0(sr_result[2]), .in1(sl_result[2]), .sel(SHIFT_op), .out(RESULT[2]));
    mux2X1 result_mux_1 (.in0(sr_result[1]), .in1(sl_result[1]), .sel(SHIFT_op), .out(RESULT[1]));
    mux2X1 result_mux_0 (.in0(sr_result[0]), .in1(sl_result[0]), .sel(SHIFT_op), .out(RESULT[0]));
    
endmodule

// Module for arithmetic shift right operation
module SRA(DATA1, DATA2, RESULT, AMOUNT);

    input [7:0] DATA1, DATA2; // Inputs
    input [2:0] AMOUNT; // Shift amount
    output [7:0] RESULT; // Output
    wire [7:0] sra_x, sra_y;
    
    // 4-bit arithmetic shift right
    mux2X1 sr_ins_23 (.in0(DATA1[7]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(sra_x[7]));
    mux2X1 sr_ins_22 (.in0(DATA1[6]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(sra_x[6]));
    mux2X1 sr_ins_21 (.in0(DATA1[5]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(sra_x[5]));
    mux2X1 sr_ins_20 (.in0(DATA1[4]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(sra_x[4]));
    mux2X1 sr_ins_19 (.in0(DATA1[3]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(sra_x[3]));
    mux2X1 sr_ins_18 (.in0(DATA1[2]), .in1(DATA1[6]), .sel(AMOUNT[2]), .out(sra_x[2]));
    mux2X1 sr_ins_17 (.in0(DATA1[1]), .in1(DATA1[5]), .sel(AMOUNT[2]), .out(sra_x[1]));
    mux2X1 sr_ins_16 (.in0(DATA1[0]), .in1(DATA1[4]), .sel(AMOUNT[2]), .out(sra_x[0]));
    
    // 2-bit arithmetic shift right
    mux2X1 sr_ins_15 (.in0(sra_x[7]), .in1(DATA1[7]), .sel(AMOUNT[1]), .out(sra_y[7]));
    mux2X1 sr_ins_14 (.in0(sra_x[6]), .in1(DATA1[7]), .sel(AMOUNT[1]), .out(sra_y[6]));
    mux2X1 sr_ins_13 (.in0(sra_x[5]), .in1(sra_x[7]), .sel(AMOUNT[1]), .out(sra_y[5]));
    mux2X1 sr_ins_12 (.in0(sra_x[4]), .in1(sra_x[6]), .sel(AMOUNT[1]), .out(sra_y[4]));
    mux2X1 sr_ins_11 (.in0(sra_x[3]), .in1(sra_x[5]), .sel(AMOUNT[1]), .out(sra_y[3]));
    mux2X1 sr_ins_10 (.in0(sra_x[2]), .in1(sra_x[4]), .sel(AMOUNT[1]), .out(sra_y[2]));
    mux2X1 sr_ins_09 (.in0(sra_x[1]), .in1(sra_x[3]), .sel(AMOUNT[1]), .out(sra_y[1]));
    mux2X1 sr_ins_08 (.in0(sra_x[0]), .in1(sra_x[2]), .sel(AMOUNT[1]), .out(sra_y[0]));
    
    // 1-bit arithmetic shift right
    mux2X1 sr_ins_07 (.in0(sra_y[7]), .in1(DATA1[7]), .sel(AMOUNT[0]), .out(RESULT[7]));
    mux2X1 sr_ins_06 (.in0(sra_y[6]), .in1(sra_y[7]), .sel(AMOUNT[0]), .out(RESULT[6]));
    mux2X1 sr_ins_05 (.in0(sra_y[5]), .in1(sra_y[6]), .sel(AMOUNT[0]), .out(RESULT[5]));
    mux2X1 sr_ins_04 (.in0(sra_y[4]), .in1(sra_y[5]), .sel(AMOUNT[0]), .out(RESULT[4]));
    mux2X1 sr_ins_03 (.in0(sra_y[3]), .in1(sra_y[4]), .sel(AMOUNT[0]), .out(RESULT[3]));
    mux2X1 sr_ins_02 (.in0(sra_y[2]), .in1(sra_y[3]), .sel(AMOUNT[0]), .out(RESULT[2]));
    mux2X1 sr_ins_01 (.in0(sra_y[1]), .in1(sra_y[2]), .sel(AMOUNT[0]), .out(RESULT[1]));
    mux2X1 sr_ins_00 (.in0(sra_y[0]), .in1(sra_y[1]), .sel(AMOUNT[0]), .out(RESULT[0]));

endmodule

// Module for rotate right operation
module ROR(DATA1, DATA2, RESULT, AMOUNT);

    input [7:0] DATA1, DATA2; // Inputs
    input [2:0] AMOUNT; // Shift amount
    output [7:0] RESULT; // Output
    wire [7:0] ror_x, ror_y;
    
    // 4-bit arithmetic shift right
    mux2X1 sr_ins_23 (.in0(DATA1[7]), .in1(DATA1[3]), .sel(AMOUNT[2]), .out(ror_x[7]));
    mux2X1 sr_ins_22 (.in0(DATA1[6]), .in1(DATA1[2]), .sel(AMOUNT[2]), .out(ror_x[6]));
    mux2X1 sr_ins_21 (.in0(DATA1[5]), .in1(DATA1[1]), .sel(AMOUNT[2]), .out(ror_x[5]));
    mux2X1 sr_ins_20 (.in0(DATA1[4]), .in1(DATA1[0]), .sel(AMOUNT[2]), .out(ror_x[4]));
    mux2X1 sr_ins_19 (.in0(DATA1[3]), .in1(DATA1[7]), .sel(AMOUNT[2]), .out(ror_x[3]));
    mux2X1 sr_ins_18 (.in0(DATA1[2]), .in1(DATA1[6]), .sel(AMOUNT[2]), .out(ror_x[2]));
    mux2X1 sr_ins_17 (.in0(DATA1[1]), .in1(DATA1[5]), .sel(AMOUNT[2]), .out(ror_x[1]));
    mux2X1 sr_ins_16 (.in0(DATA1[0]), .in1(DATA1[4]), .sel(AMOUNT[2]), .out(ror_x[0]));
    
    // 2-bit arithmetic shift right
    mux2X1 sr_ins_15 (.in0(ror_x[7]), .in1(DATA1[1]), .sel(AMOUNT[1]), .out(ror_y[7]));
    mux2X1 sr_ins_14 (.in0(ror_x[6]), .in1(DATA1[0]), .sel(AMOUNT[1]), .out(ror_y[6]));
    mux2X1 sr_ins_13 (.in0(ror_x[5]), .in1(ror_x[7]), .sel(AMOUNT[1]), .out(ror_y[5]));
    mux2X1 sr_ins_12 (.in0(ror_x[4]), .in1(ror_x[6]), .sel(AMOUNT[1]), .out(ror_y[4]));
    mux2X1 sr_ins_11 (.in0(ror_x[3]), .in1(ror_x[5]), .sel(AMOUNT[1]), .out(ror_y[3]));
    mux2X1 sr_ins_10 (.in0(ror_x[2]), .in1(ror_x[4]), .sel(AMOUNT[1]), .out(ror_y[2]));
    mux2X1 sr_ins_09 (.in0(ror_x[1]), .in1(ror_x[3]), .sel(AMOUNT[1]), .out(ror_y[1]));
    mux2X1 sr_ins_08 (.in0(ror_x[0]), .in1(ror_x[2]), .sel(AMOUNT[1]), .out(ror_y[0]));
    
    // 1-bit arithmetic shift right
    mux2X1 sr_ins_07 (.in0(ror_y[7]), .in1(DATA1[0]), .sel(AMOUNT[0]), .out(RESULT[7]));
    mux2X1 sr_ins_06 (.in0(ror_y[6]), .in1(ror_y[7]), .sel(AMOUNT[0]), .out(RESULT[6]));
    mux2X1 sr_ins_05 (.in0(ror_y[5]), .in1(ror_y[6]), .sel(AMOUNT[0]), .out(RESULT[5]));
    mux2X1 sr_ins_04 (.in0(ror_y[4]), .in1(ror_y[5]), .sel(AMOUNT[0]), .out(RESULT[4]));
    mux2X1 sr_ins_03 (.in0(ror_y[3]), .in1(ror_y[4]), .sel(AMOUNT[0]), .out(RESULT[3]));
    mux2X1 sr_ins_02 (.in0(ror_y[2]), .in1(ror_y[3]), .sel(AMOUNT[0]), .out(RESULT[2]));
    mux2X1 sr_ins_01 (.in0(ror_y[1]), .in1(ror_y[2]), .sel(AMOUNT[0]), .out(RESULT[1]));
    mux2X1 sr_ins_00 (.in0(ror_y[0]), .in1(ror_y[1]), .sel(AMOUNT[0]), .out(RESULT[0]));

endmodule