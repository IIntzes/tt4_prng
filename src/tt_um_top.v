//`default_nettype none

module tt_um_top #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the HEX0 - 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire CLK = clk;
    wire reset = ! rst_n;
    wire EN = ena;
    wire [6:0] HEX0;
	assign uo_out[7:0] = {HEX0, 1'b0};

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    wire [6:0] HEX1;
    // put bottom 8 bits of second counter out on the bidirectional gpio
	assign uio_out[7:0] = {HEX1, 1'b0};


	wire [15:0] lfsr16_to_mux;  //data
	wire [7:0] lfsr8_to_mux; 	//control
	wire [7:0] out_mux;
	
	reg clk12_5Mhz;
	
	
	integer counter_50M = 0;
  
	//Creation of 1Hz clock from 50Mhz input clock.
	always @(posedge CLK, negedge EN)

	begin
		if (!EN)
			counter_50M = 0;
		else if (counter_50M < 10000000)
			begin
				counter_50M = counter_50M + 1;
			end
		else if (counter_50M == 10000000)
			begin
				clk1hz = !clk1hz;
				counter_50M = 0;
			end
	end
		
	//Creation of 12.5MHz clock from 50Mhz input clock.
	integer counter = 0;
	always @(posedge clk1hz, negedge EN)

		begin
			 if (!EN)
				counter <=0;
			else if (counter < 21'd1_250_000)
				 begin
					counter <= counter + 1;
				 end
			else if (counter == 21'd1_250_000)
				 begin
					clk12_5Mhz <= !clk12_5Mhz;
					counter <=0;
				 end
		end
		
		//initialization
		lfsr8 lfsr_control(lfsr8_to_mux, clk12_5Mhz, EN);
		lfsr16 lfsr_data(lfsr16_to_mux, clk1hz, EN);
		
		mux_16to8 mux(lfsr16_to_mux, lfsr8_to_mux, out_mux);

		//assign {OUT[7], OUT[3], OUT[1], OUT[4], OUT[6], OUT[2], OUT[0], OUT[5]} =
		//		 {out_mux[7], out_mux[6], out_mux[5], out_mux[4], out_mux[3], out_mux[2], out_mux[1], out_mux[0]};
		 
		//Seven segment circuit
		DEC_7SEG i1
		(
			.Hex_digit(out_mux[3:0]),
			.segment_data(HEX0[6:0])
		);
	 
		DEC_7SEG i2
		(
			.Hex_digit(out_mux[7:4]),
			.segment_data(HEX1[6:0])
		);

endmodule

////////////////////////////////////////LFSR16BIT//////////////////////////////////////////
module lfsr16(
					lfsr_out, clk1hz, rst, 
					);
	
	//Input and outputs
	output reg [15:0] lfsr_out;
	input clk1hz, rst;
	
	//LFSR feedback
	wire feedback;
	assign feedback = ~(lfsr_out[15] ^ lfsr_out[14] ^ lfsr_out[12] ^ lfsr_out[3]);

	always @(posedge clk1hz, negedge rst)
	begin
		if (!rst)
			lfsr_out = 16'b00000000;
		else
			lfsr_out = {lfsr_out[14:0],feedback};
	end
  
endmodule

////////////////////////////////////////LFSR8BIT//////////////////////////////////////////
module lfsr8 (			
	output [7:0] lfsr_out, 
	input clk12_5Mhz, 
	input rst 
);
	
	//LFSR feedback
	wire feedback;
	assign feedback = ~(lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3]);

	always @(posedge clk12_5Mhz, negedge rst)
	begin
		if (!rst)
			lfsr_out = 8'b00000000;
		else
			lfsr_out = {lfsr_out[6:0],feedback};
	end
	
endmodule

module mux_2to1 (
    input wire a,
    input wire b,
    input wire select,
    output wire y
);
    assign y = (select) ? b : a;
endmodule

//////////////////////////////////////MUX////////////////////////////
module mux_16to8 (
    input [15:0] inputs,  // 16 inputs
    input [7:0] select,   // 3 control inputs (3-bit)
    output [7:0] outputs   // 8 outputs
);
    wire [7:0] mux_outputs [7:0]; 
    // Creation of 8 2:1 muxes
	genvar j;
	generate
		for (j = 0; j < 8; j = j + 1) begin : mux_inst_loop
			  mux_2to1 mux_inst (
					.a(inputs[j * 2]),
					.b(inputs[j * 2 + 1]),
					.select(select[j]),
					.y(mux_outputs[j])
			  );
		 end
	endgenerate

	genvar i;
		generate
			 for (i = 0; i < 8; i = i + 1) begin : assign_loop
				  assign outputs[i] = mux_outputs[i];
			 end
		endgenerate
endmodule
